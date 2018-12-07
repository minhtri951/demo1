require("./db_config.js")
var path = require('path')
VAR_DIRECTION = {
  ADJUSTMENT: true,

}
var fs = require('fs')
var https = require('https')
const bodyParser = require('body-parser');
var cors = require('cors')
express = require('express');
app = express();
app.use(express.static(path.join(__dirname, 'public')));
var session = require('express-session')
var db = require('./services/db.js')
var SessionStore = require('express-sql-session')(session);
app.use(cors())


//FILE UPLOADER 
const fileUpload = require('express-fileupload');
app.use(fileUpload());



// app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.urlencoded({
  extended: false
}))
app.use(express.json());
app.use(express.urlencoded());
expressWs = require('express-ws')(app);
moment = require('moment');


if (ENV.includes("PRODUCT")) {
  var privateKey = fs.readFileSync(__dirname + '/../ssl_cert/private.key');
  var certificate = fs.readFileSync(__dirname + '/../ssl_cert/certificate.crt');

  var server = https.createServer({
    key: privateKey,
    cert: certificate
  }, app).listen(3000);
  expressWs = require('express-ws')(app, server);
} else {
  app.listen(3000);
}
var storeOptions = {
  client: 'mysql',
  connection: {
    host: VAR_HOST,
    port: "3306",
    user: VAR_USER,
    password: VAR_PASSWORD,
    database: VAR_DATABASE
  },
  table: "tb_session",
  expires: 365 * 24 * 60 * 60 * 1000
};

app.use(function (req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  // res.header("Access-Control-Allow-Origin", "http://localhost");
  // var allowedOrigins = ['https://smartoptionsnow.com', 'http://smartoptionsnow.com', 'http://localhost:8086', 'http://localhost:8087','http://192.168.1.201:8086'];
  // var origin = req.headers.origin;
  // if (allowedOrigins.indexOf(origin) > -1) {
  //     res.header('Access-Control-Allow-Origin', origin);
  // }
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  next();
});

store = new SessionStore(storeOptions);
mysession = session({
  secret: '5CC36237FEF6D88C39476DA6B5E9A2F7',
  resave: true,
  saveUninitialized: false,
  key: 'sid',
  store: store
});
app.use(mysession)


var socket = require('./socket.js')
var webapi = require('./webapi')
