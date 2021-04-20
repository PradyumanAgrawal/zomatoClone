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

//Insert user into database
app.post('/user', (req, res) => {
    con.connect(function(err) {
        var sql = "INSERT INTO user VALUES (2,'Swapnil','ss93@iitbbs.ac.in','8085241233','Gondia','https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png')";
        con.query(sql, function (err, result) {
            if (err) throw err;
            console.log("1 record inserted");
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
        con.query(`DELETE FROM address where addrId=${req.params.addrId}`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.post('/address', (req, res) => {
    con.connect(function(err) {
        var sql = "INSERT INTO address VALUES ";
        con.query(sql, function (err, result) {
            if (err) throw err;
            console.log("1 record inserted");
        });
    });
});

//get all shops details
app.get('/shops', (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM shop`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//get details for products for one shop
app.get('/shops/:shopId', (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM products where shopId=${req.params.shopId}`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//get all categories types
app.get('/categories', (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM categories`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//Get all orders for one specific addrId
app.get('/orders/:addrId', (req, res) => {
    con.connect(function(err) {
        console.log(req.params.id)
        con.query(`SELECT * FROM orders where addrId=${req.params.userId}`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//get all products details
app.get('/products', (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM products`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//get all products details discount sorted
// app.get('/products', (req, res) => {
//     con.connect(function(err) {
//         con.query(`SELECT * FROM products orderBy discount`, function(err, result, fields) {
//             if (err) res.send(err);
//             if (result) res.send(result);
//         });
//     });
// });

//get details for one product
app.get('/products/:productId', (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM products  where productId=${req.params.productId}`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//get all products for one categories
app.get('/products/type/:type', (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM products where type=${req.params.type}`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.get("search/product/:query", (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM products where pname is like %${req.params.query}%`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.get("search/shop/:query", (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM shop where shopName is like %${req.params.query}%`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});


app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})