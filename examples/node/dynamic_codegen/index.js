const client = require("./client");
const express = require("express");
const bodyParser = require("body-parser");

const app = express();

var hostname = process.env.HOSTNAME

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.get("/", (req, res) => {
    client.sayHello({name: 'user'}, function(err, response) {
        if (!err) {
            res.send('Im ' + hostname + 'and You got a message from: ' + response.message);
        }
      });
});

app.listen(3000);