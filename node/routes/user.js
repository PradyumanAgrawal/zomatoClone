const userRouter = require('express').Router();
const mysql = require('mysql');
const con = require('../index.js');

//get details for one user
userRouter.get('/:userId', (req, res) => {
    console.log(req.params.id)
    con.query(`SELECT * FROM user where userId=?`,[req.params.userId],function(err, result, fields) {
        if (err) res.send(err);
        if (result) res.send(result);
    });
});

module.exports = userRouter;