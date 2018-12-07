ENV = "DEBUG";
const publicIp = require('public-ip');
//CAU HINH CLIENT
VAR_HOST = "192.168.1.50";
VAR_USER = "username";
VAR_PASSWORD = "password";
VAR_DATABASE = "smartoptionsnow";
VAR_APPLICATION_NAME = "Smart Options Now";

HOST_SERVER = "http://192.168.1.201:8086"

publicIp.v4().then(ip => {
  if (ip.includes("45.76.219.51") || ip.includes("8.9.37.102")) {
    ENV = "PRODUCT"
  }
});


if (ENV.includes("PRODUCT")) {
  //CAU HINH SERVER 
  VAR_HOST = "localhost";
  VAR_USER = "smartoptionsnow";
  VAR_PASSWORD = "?Lnqg525";
  VAR_DATABASE = "smartoptionsnow";

  HOST_SERVER = "https://smartoptionsnow.com"
}
