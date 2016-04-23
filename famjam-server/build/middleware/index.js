"use strict";
var jwt = require("jsonwebtoken");
var config_1 = require("../app/config");
var models_1 = require("../models");
exports.authorizeToken = function (req, res, next) {
    var authorizationHeader = req.header("Authorization");
    if (authorizationHeader === undefined)
        res.sendStatus(401);
    else {
        var token = authorizationHeader.split(" ")[1];
        jwt.verify(token, config_1.config.secret, function (err, decoded) {
            if (err)
                res.sendStatus(401);
            else {
                models_1.User.findById(decoded.uid, function (err, user) {
                    if (err)
                        res.sendStatus(401);
                    req.authenticatedUser = user;
                    next();
                });
            }
        });
    }
};
