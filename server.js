var arguments = process.argv;

var port = 80;

if (arguments.length == 2) {
				//console.log(arguments.length);
				port = 80;
}
else {
				port = 3000;
}

console.log(port);

const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');

var cors = require("cors");

const db = require(__dirname + "/database/db_interface.js")
const database = new db.Database();

const app = express();
//const port = process.env.PORT || 80;

app.use(cors());

app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(express.static(path.join(__dirname, './static')));
app.use(express.json());

app.get('/', (req, res) => {
  const recieved_items = database.get_items();

  //console.log(JSON.stringify(recieved_items));

  res.status(200).render('index', {
    items: JSON.stringify(recieved_items)
  });
});

app.get('/new-item', (req, res) => {
  
  res.status(200).render('new-item');
});

app.post("/new-item", (request, response) => {
  //Destructure the request body
  var resData = {
    serverData: request.body,
  };

  database.new_item(request.body.title, request.body.due_day, request.body.due_month, request.body.due_year, request.body.description);
  response.status(200).render('new-item');
});

app.get('*', (req, res) => { /* 404 error */
  res.render('404.ejs');
});

app.listen(port);

console.log("Listening at port http://pdxgrantc.com");
