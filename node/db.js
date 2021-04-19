const mysql = require('mysql');

const con = mysql.createConnection({
    host: "database-1.ct5yrt1vuny7.ap-south-1.rds.amazonaws.com",
    user: "admin",
    password: "Password"
});

con.connect(function(err) {
    if (err) throw err;
    console.log("Connected!");
    con.query(`SELECT * FROM amazon.user`, function(err, result, fields) {
        if (err)
            console.log(err);
        if (result)
            console.log(result);
    });
    con.end();
});