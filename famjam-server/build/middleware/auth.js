"use strict";
var jwt = require("jsonwebtoken");
var config_1 = require("../app/config");
exports.authorizeToken = function (req, res, next) {
    var token = req.header("Authorization").split(" ")[0];
    jwt.verify(token, config_1.config.secret, function (err, decoded) {
        res.json(decoded);
    });
};
