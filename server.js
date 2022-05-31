const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
var cors = require("cors");

const db = require(__dirname + "/database/db_interface.js")
const database = new db.Database();

const app = express();
const port = process.env.PORT || 80;

app.use(cors());

app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(express.static(path.join(__dirname, './static')));
app.use(express.json());

app.get('/', (req, res) => {
  const recieved_items = database.get_items();

  res.render('index', {
    items: JSON.stringify(recieved_items)
  });
});

app.get('/new-item', (req, res) => {
  
  res.render('new-item');
});

app.post("/new-item", (request, response) => {
  //Destructure the request body
  var resData = {
    serverData: request.body,
  };

  database.new_item(request.body.title, request.body.due_day, request.body.due_month, request.body.due_year, request.body.description);

  //Console log the response data (for debugging)
  //console.log(resData.serverData);
  //Send the response as JSON with status code 200 (success)
  response.status(200).render('new-item');
});

/*
app.post("/new-item", (req, res) => {
  let data = req.body;
  var title = Number(req.body.title);
  var date = Number(req.body.date);
  var description = Number(req.body.description);
  res.redirect("/");
});
*/
app.get('*', (req, res) => { /* 404 error */
  res.render('404.ejs');
});

app.listen(port);

console.log("Listening at port http://pdxgrantc.com");
