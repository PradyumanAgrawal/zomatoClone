const express = require('express')
const logger = require("morgan");
var dotenv = require('dotenv');
const mysql = require('mysql');

//const userRouter = require('./routes/user.js');

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

//app.use('/user',userRouter);

const con = mysql.createConnection({
    host:process.env.sql_endpoint,
    user: process.env.db_username,
    password: process.env.db_password,
    database: 'amazon',
    multipleStatements: true
});

con.connect(function(err) {
    if (err) throw err;
    console.log("Database Connected!");
});


//register user
app.post('/user', (req, res) => {
    con.connect(function(err) {
        let body=req.body;
        con.query(`INSERT IGNORE INTO user(userId,name,email,displayPic) values(?,?,?,?)`,[body.uid,body.displayName,body.email,body.photoUrl], function(err, result) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});


//update user profile
app.put('/user/:userId', (req, res) => {
    con.connect(function(err) {
        var sql=`UPDATE user SET `;
        var arg=[]
        if(req.body.name){
            sql+=`name=? ,`;
            arg.push(req.body.name)
        }
        if(req.body.phone){
            sql+=`mobileNo=? `;
            arg.push(req.body.phone)
        }
        sql+= `WHERE userId=?`;
        arg.push(req.params.userId)
        console.log(sql)
        console.log(arg)
        
        con.query(sql,arg, function(err, result, fields) {
            if (err) {res.json({status:0});console.log(err)};
            if (result) res.json({status:1});
        });
    });
});

//get details for one user
app.get('/user/:userId', (req, res) => {
    con.query(`SELECT * FROM user where userId=?`,[req.params.userId],function(err, result, fields) {
        if (err) res.send(err);
        if (result) res.send(result);
    });
});


//get all users details
app.get('/user', (req, res) => {
    con.query(`SELECT * FROM user`, function(err, result, fields) {
        if (err) res.send(err);
        if (result) res.send(result);
    });
});

//Get all address for one specific user
app.get('/user/address/:userId', (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM Address where userId=?`,[req.params.userId], function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//delete one specific addrId's address entry
app.delete('/address/:addrId', (req, res) => {
    con.connect(function(err) {
        con.query(`DELETE FROM Address where addrId=?`,[req.params.addrId], function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.post('/address', (req, res) => {
    con.connect(function(err) {
        let body=req.body;
        con.query(`INSERT INTO Address(userId,city,line1,line2,name,phone,state) values (?,?,?,?,?,?,?)`,[body.userId,body.city,body.line1,body.line2,body.name,body.phone,body.state], function(err, result) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//get cart details for one user
app.get('/cart/:userId', (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM (SELECT * FROM cart where userId = ?) c`
        +` natural join products`,[req.params.userId], function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//make changes to your cart
app.post('/cart',(req,res)=>{
    con.connect(function(err) {
        let body=req.body;
        con.query(`select exists(select quantity from cart where userId=? and productId=?) as res;`
        +`call modifyCart(?,?,?)`,
        [body.userId,body.productId,body.userId,body.productId,body.quantity],
        function(err, result) {
            console.log(result[0][0].res);
            if (err) res.send(err);
            if (result&&result[0][0].res) res.json({status:1});
            else res.json({status:2})
        });
    });
})

//make a review
app.post('/review',(req,res)=>{
    con.connect(function(err) {
        console.log(req.body);
        let body=req.body;
        con.query(`call makeReview(?,?,?)`,[body.userId,body.productId,body.rating], function(err, result) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
})

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
        con.query(`SELECT * FROM shop where shopId=?`,[req.params.shopId], function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//get details for products for one shop
app.get('/shops/:shopId/products', (req, res) => {
    con.connect(function(err) {
        con.query(`SELECT * FROM products where shopId=?`,[req.params.shopId], function(err, result, fields) {
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
        con.query(` select * from (SELECT * FROM Address where userId = ? ) a`
        +` natural join orders natural join products`,[req.params.userId], function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

//Place an order
app.post('/orders/:addrId', (req, res) => {
    con.connect(function(err) {
        con.query(`call cartToOrder(?)`,[req.params.addrId], function(err, result, fields) {
            if (err) res.json({status:0});
            if (result) res.json({status:1});
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
    
        con.query(`SELECT * FROM products ${removeNull} order by ? ?`,[req.query.sort,req.query.order], function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

// //get all products details with offers sorted
// app.get('/offers', (req, res) => {
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
        con.query(`SELECT * FROM products where category=?`,req.params.type, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.get("/search/product/:query", (req, res) => {
    con.connect(function(err) {
        req.params.query="%"+req.params.query+"%"
        con.query(`Select * from products where productId in (Select productId FROM tags where tags like ?)`
        +` union `+
        `SELECT * FROM products where pName like ? `,[req.params.query,req.params.query], function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.get("/search/shop/:query", (req, res) => {
    con.connect(function(err) {
        req.params.query="%"+req.params.query+"%"
        con.query(`SELECT * FROM shop where shopName like ?`,req.params.query, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.get("/sort/:stream", (req, res) => {
    var sql;
    var args=[];
    var table="products";
    if(req.query.isVeg&&(!req.query.isVeg.localeCompare("true"))){
        table="vegProducts"
    }
    if(req.params.stream.localeCompare("category")==0){
        sql=`SELECT * FROM ${table} where category=? order by price`
        args.push(req.query.meta);
    }
    else if(req.params.stream.localeCompare("shop")==0)
    {
        sql=`SELECT * FROM ${table} where shopId=? order by price`
        args.push(req.query.meta);
    }
    else if(req.params.stream.localeCompare("search")==0)
    {
        sql=`Select * from (Select * from ${table} where productId in (Select productId FROM tags where tags like ?)`
        +` union `+
        `SELECT * FROM ${table} where pName like ?) s order by price`

        //sql=`SELECT * FROM ${table} where pName like ? order by price`
        req.query.meta="%"+req.query.meta+"%"
        args.push(req.query.meta);
        args.push(req.query.meta);
    }
    else if(req.params.stream.localeCompare("offer")==0)
    {
        sql=`SELECT * FROM ${table} where discount is not NULL order by price`
    }
    else
    {
        sql=`SELECT * FROM ${table} order by price`
    }    
    if(req.query.order.localeCompare("desc")==0)
    {
        sql+=' DESC'
    }
    con.connect(function(err) {
        con.query(sql,args, function(err, result, fields) {
            if (err) res.send(err);
            if (result) res.send(result);
        });
    });
});

app.listen(port, () => {
  console.log(`app listening at http://localhost:${port}`)
})

module.exports=con