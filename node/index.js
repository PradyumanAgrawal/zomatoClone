const express = require('express')
const logger = require("morgan");
var dotenv = require('dotenv');
const mysql = require('mysql');

// Set up the express app
const app = express()
dotenv.config();
const port = process.env.PORT;

// Log requests to the console.
app.use(logger("dev"));

// Parse incoming requests data
app.use(express.json());
app.use(express.urlencoded({
    extended: true
}));

const con = mysql.createConnection({
    host:process.env.sql_endpoint,
    user: process.env.db_username,
    password: process.env.db_password,
    database: 'amazon'
});

con.connect(function(err) {
    if (err) throw err;
    console.log("Database Connected!");
    console.log(`${err}`);
    //con.query('USE amazon;');
});


app.get('/', (req, res) => {
  res.send('Hello World!')
})

//register user
app.post('/user', (req, res) => {
    con.connect(function(err) {
        console.log(req.body);
        let body=req.body;
        con.query(`INSERT IGNORE INTO user(userId,name,email,displayPic) values ('${body.uid}','${body.displayName}','${body.email}','${body.photoUrl}')`, function(err, result) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});


//update user profile
app.put('/user/:userId', (req, res) => {
    con.connect(function(err) {
        con.query(`UPDATE user SET userId = value1, column2 = value2, ...
        WHERE condition;`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});


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
        console.log(req.body);
        // con.query(sql, function (err, result) {
        //     if (err) throw err;
        //     console.log("1 record inserted");
        // });
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


//get details for one shop
app.get('/shops/:shopId', (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM shop where shopId=${req.params.shopId}`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//get details for products for one shop
app.get('/shops/:shopId/products', (req, res) => {
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
        con.query(`SELECT distinct category from products`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//Get all orders for one specific addrId
app.get('/orders/:userId', (req, res) => {
    con.connect(function(err) {
        console.log(req.params.id)
        con.query(`SELECT * FROM orders natural join Address where userId=${req.params.userId}`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//get all products details
app.get('/products', (req, res) => {
    con.connect(function(err) {
        var removeNull='';
        if(!req.query.sort)
        req.query.sort="productId";
        if(!req.query.order)
        req.query.order="Asc";
        if(req.query.sort.localeCompare("discount")==0)
        removeNull='where discount is not NULL'
        // obj = JSON.parse(req.query.productId));
        // shareInfoLen = Object.keys(obj.shareInfo[0]).length;
        // console.log(JSON.parse(req.query.productId).size())
        con.query(`SELECT * FROM products ${removeNull} order by ${req.query.sort} ${req.query.order}`, function(err, result, fields) {
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
// });`

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
        con.query(`SELECT * FROM products where category='${req.params.type}'`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.get("/search/product/:query", (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM products where pName is like %${req.params.query}%`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.get("/search/shop/:query", (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM shop where shopName is like %${req.params.query}%`, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.get("/sort/:stream", (req, res) => {
    var sql;
    if(req.params.stream.localeCompare("category")==0){
        console.log("-----------------");
    }
    if(req.params.stream.localeCompare("category")==0){
        sql=`SELECT * FROM products where category='${req.query.meta}' order by price ${req.query.order}`
    }
    else if(req.params.stream.localeCompare("shop")==0)
        sql=`SELECT * FROM products where shopId=${req.query.meta} order by price ${req.query.order}`
    else
        sql=`SELECT * FROM products order by price ${req.query.order}`
    con.connect(function(err) {
        con.query(sql, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})