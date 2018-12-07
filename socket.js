var self = this;

var socketmessage = require('./lib/socketmessage.js');
WebSocket = require('ws');
var db = require("./services/db.js");
var candles = require("./lib/candles.js");
var room = require("./lib/room.js");
var devteamHelper = require('./lib/devteamHelper')
var colors = require('colors');

expressWs.getWss().on('connection', function (ws, req) {
    ws.upgradeReq = req;
    console.log("connect socket")
    ws.on('message', function incoming(data) {
        // console.log(data)
        try {
            json = JSON.parse(data)
            let error = validateSocket(json)
            if (error) {
                console.log("validate: ws request: ", error)
                var response = {}
                response.result = {
                    status: false,
                    message: error,
                    code: 400
                };
                ws.send(JSON.stringify(response))
                return
            }

            if (!ws.userid) {
                if (json.sessionID) {
                    var sid = json.sessionID;
                    db.getSession(sid, function (session) {
                        if (session.userid) {
                            ws.userid = session.userid;
                        }
                    });
                }
                else {
                    //CLIENT KHÔNG GỬI SESSION ID CHO SERVER
                    data.result = {
                        status: false,
                        message: "Session Required",
                        code: 400
                    };
                    ws.send(JSON.stringify(data))
                }
            }
            else {
                //CÓ GỬI SESSION ID NHƯNG HẾT HẠN
                data.result = {
                    status: false,
                    message: "Session Expired",
                    code: 401
                };
                ws.send(JSON.stringify(data))
            }
            handleNewMessageFromClient(ws, json);
        } catch (ex) {
            console.log("Can't parse json from client");
        }
    });
});

expressWs.getWss().on('error', function close() {
    console.log('error');
  });

expressWs.getWss().on('close', function close() {
    console.log('disconnected');
  });

app.ws('/', function (ws, req) {
    ws.upgradeReq = req;
    ws.on('close', function () {
        console.log("close")
        // callback.onClosed();
    });
});



function handleNewMessageFromClient(ws, data) {
    try {
        if (data.cmd == "req") {
            // console.log("send candles")
            ws.subMarket = data.args[0];
            socketmessage.sendCandles(ws, data);
        }
        //{"cmd":"buy","args":["candle.M1.btcusdt",10,"DEMO","CALL"]}
        if (data.cmd == "buy") {
            if (!checkPendingOrderUser(data.sessionID)) {
                socketmessage.orderBuy(ws, data);
            }
            else {
                data.result = {
                    status: false,
                    message: "Your pre-order is in process. Please wait a bit! We will notification when your pre-order is done",
                    data: null
                }
                ws.send(JSON.stringify(data));
            }

        }
        if (data.cmd == "playmode") {
            socketmessage.changePlayMode(ws, data);
        }
    } catch (ex) {
        console.error(ex);
    }
}


function validateSocket(data) {
    if (!data.cmd) {
        return "Miss cmd"
    }

    if (!data.sessionID) {
        return "Miss sessionID"
    }

    if ((data.cmd == "buy" || data.cmd == "req") && !data.args) {
        return "Miss args"
    }

    if (data.cmd == "playmode" && !data.playmode) {
        return "Miss playmode"
    }

    if (data.cmd == "req" && (!Array.isArray(data.args) || data.args.length != 3
        || typeof data.args[0] !== 'string' || isNaN(data.args[1]) || isNaN(data.args[2]))) {
        return "CMD: req wrong agrs"
    }

    if (data.cmd == "buy" && (!Array.isArray(data.args) || data.args.length != 4
        || typeof data.args[0] !== 'string' || isNaN(data.args[1]) || typeof data.args[2] !== 'string' || typeof data.args[3] !== 'string')) {
        return "CMD: buy wrong agrs"
    }

    return null
}

function checkPendingOrderUser(sessionID) {
    db.getSession(sessionID, function (session) {
        if (arrUserOrderPending && arrUserOrderPending[session.userid]) {
            return true
        }
        return false
    })
    return false
}

function testConnectionDataBase() {

    
    db.testConnection(function (data) {
        console.log(data)
        if (data && data.length > 0) {

            if (ENV.includes("PRODUCT")) {
                var message = `[SUCCESS] ${VAR_APPLICATION_NAME} restart. SQL connect *successfully*`
                devteamHelper.sendMessage(message);
            }
            

            console.log(colors.green("Test connection success - SQL MODE: "), data[0].sql_mode)
            if (data[0].sql_mode.includes("ONLY_FULL_GROUP_BY")) {
                console.log(colors.yellow("Waring: SQL MODE CONTAIN ONLY_FULL_GROUP_BY - Please use your admin account to set SQL MODE."))

                if (ENV.includes("PRODUCT")) {
                    var message = `[ERROR]  ${VAR_APPLICATION_NAME} SQL full group by *enable*. Please disable mode `
                    devteamHelper.sendMessage(message);
                }
                
            }
        }
        else {
            console.log(colors.red("Test connection fail - Please check user name and password database"))
            if (ENV.includes("PRODUCT")) {
                var message = `[ERROR] ${VAR_APPLICATION_NAME} restart. Test connection fail - Please check user name and password database `
                devteamHelper.sendMessage(message);
            }
            
        }
    })
}

//------------------------------------------------------
//-------------Call functions---------------------------
//------------------------------------------------------

var interval = setInterval(function () {
    // console.log("SEND TIME & ROOM STATUS")
    expressWs.getWss().clients.forEach(function each(client) {
        if (client.readyState === WebSocket.OPEN) {
            socketmessage.sendTime(client)
            socketmessage.sendStatusRoom(client, { "cmd": "room" })
        }
    });
}, 1000);

//clearInterval(interval);
candles.init(function (candle) {
    // console.log("co",wss.clients.size,"client")
    expressWs.getWss().clients.forEach(function each(client) {
        if (client.readyState === WebSocket.OPEN && client.subMarket && client.subMarket.includes(candle.type)) {
            client.send(JSON.stringify(candle));
        }
    });
});
room.handleRoom(function (dataToClient) {
    if (dataToClient.orders) {
        var orders = dataToClient.orders;
        var dicOrders = {}
        var currentUserid = null
        for (let i = 0; i < orders.length; i++) {
            const order = orders[i];
            if(!currentUserid || currentUserid != order.userid){
                dicOrders[order.userid] = []
                currentUserid = order.userid
            }
            dicOrders[order.userid].push(order)
        }

        expressWs.getWss().clients.forEach(function each(client) {
            console.log("TONG CONG CO", orders.length, "KET QUA")
            if (client && client.userid && client.readyState === WebSocket.OPEN) {
                if(dicOrders[client.userid]){
                    var data = { "cmd": "buy" };
                    data.result = {
                        status: true,
                        message: null,
                        data: dicOrders[client.userid]
                    }
                    console.log(data.result.data)
                    client.send(JSON.stringify(data));
                }
            }
        });
    }
    if (dataToClient.balances) {
        var balances = dataToClient.balances;
        expressWs.getWss().clients.forEach(function each(client) {
            if (client && client.userid && client.readyState === WebSocket.OPEN) {
                balances.forEach(balance => {
                    if (client.userid == balance.id) {
                        var data = {
                            cmd: "balance",
                            result: {
                                status: true,
                                message: null,
                                data: [
                                    { key: "livebalance", value: balance.livebalance },
                                    { key: "basebalance", value: balance.basebalance },
                                    { key: "demobalance", value: balance.demobalance }
                                ]
                            }
                        }
                        console.log("balance")
                        client.send(JSON.stringify(data));
                    }
                });
            }
        });
    }
});

testConnectionDataBase()