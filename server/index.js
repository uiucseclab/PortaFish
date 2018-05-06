const express = require('express')
var fs = require('fs');
var http = require('http');
var url = require('url');
const app = express();
var dirPath = 'data';
var jsonfile = require('jsonfile')
var bodyParser = require('body-parser')
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

//Select filename to write credentials under /server/data
var filename = "filenameTest"

var urlencodedParser = bodyParser.urlencoded({ extended: false });

app.get('/ServerStatus', function (req, res) {
  res.send('Server is online');
	console.log("Server Status checked");
})

app.get('/clientConnect', function (req, res) {
	console.log("A client has pinged the server");
})


app.post('/', function (req, res) {
  res.send('POST request to the homepage')
})

app.post('/sendData', urlencodedParser, function(request, respond) {
  if (!request.body) return respond.sendStatus(400)
    var fileNames = fs.readdirSync(dirPath);	//Load file names on startup
    //Check if filename exists
    console.log("writing File");
    filePath = __dirname + '/data/' + filename + '.json';

        jsonfile.writeFile(filePath, request.body.jsonData, function (err) {
          console.error(err)
        })
        console.log(request.body.jsonData);
        // console.log(body);
        respond.end('Wrote file data' + filename + '.json at' + filePath);
});

var port = 4000;
app.listen(port, function () {
  console.log('Server Back-end Running on ' + port)
});
