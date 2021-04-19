const express = require('express')
const logger = require("morgan");
const mysql = require('mysql');

// Set up the express app
const app = express()
const port = 3000

// Log requests to the console.
app.use(logger("dev"));

// Parse incoming requests data
app.use(express.json());

const con = mysql.createConnection({
    host: "database-1.ct5yrt1vuny7.ap-south-1.rds.amazonaws.com",
    user: "admin",
    password: "Password"
});

con.connect(function(err) {
    if (err) throw err;
    console.log("Database Connected!");
    con.query('USE amazon;');
});


app.get('/', (req, res) => {
  res.send('Hello World!')
})

//get all users details
app.get('/user', (req, res) => {
    con.connect(function(err) {
        
        con.query(`SELECT * FROM user`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//get details for one user
app.get('/user/:id', (req, res) => {
    con.connect(function(err) {
        console.log(req.params.id)
        con.query(`SELECT * FROM user where userId=${req.params.id}`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//Get all address for one specific user
app.get('/address/:userId', (req, res) => {
    con.connect(function(err) {
        console.log(req.params.id)
        con.query(`SELECT * FROM address where userId=${req.params.userId}`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//delete one specific addrId's address entry
app.delete('/address/:addrId', (req, res) => {
    con.connect(function(err) {
        console.log(req.params.id)
        con.query(`SELECT * FROM address where userId=${req.params.id}`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.post('/user', (req, res) => {
    con.connect(function(err) {
        var sql = "INSERT INTO user VALUES (2,'Swapnil','ss93@iitbbs.ac.in','8085241233','Gondia','https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png')";
        con.query(sql, function (err, result) {
            if (err) throw err;
            console.log("1 record inserted");
        });
    });
});


app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})