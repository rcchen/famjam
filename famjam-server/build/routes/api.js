"use strict";
var aws = require("aws-sdk");
var bcrypt = require("bcrypt");
var bodyParser = require("body-parser");
var express = require("express");
var jsonwebtoken = require("jsonwebtoken");
var uuid = require("node-uuid");
var config_1 = require("../app/config");
var middleware_1 = require("../middleware");
var models_1 = require("../models");
exports.api = express();
exports.api.use(bodyParser.json());
aws.config.region = "us-west-2";
exports.api.post("/users", function (req, res) {
    var username = req.body.username;
    bcrypt.hash(req.body.password, 10, function (err, password) {
        new models_1.User({ username: username, password: password }).save(function (err, user) {
            res.json(user);
        });
    });
});
exports.api.post("/authenticate", function (req, res) {
    var username = req.body.username;
    models_1.User.findOne({ username: username }, "password", function (err, user) {
        bcrypt.compare(req.body.password, user.password, function (err, authenticated) {
            if (authenticated) {
                var uid = user._id;
                jsonwebtoken.sign({ uid: uid }, config_1.config.secret, {}, function (token) {
                    res.json(token);
                });
            }
            else {
                res.sendStatus(401);
            }
        });
    });
});
exports.api.get("/users", middleware_1.authorizeToken, function (req, res) {
    models_1.User.find({}, function (err, users) {
        res.json(users);
    });
});
exports.api.get("/topics", middleware_1.authorizeToken, function (req, res) {
    var _creator = req.authenticatedUser._id;
    models_1.Topic.find({ _creator: _creator }, function (err, topics) {
        res.json(topics);
    });
});
exports.api.post("/topics", middleware_1.authorizeToken, function (req, res) {
    var user = req.authenticatedUser;
    new models_1.Topic({
        _creator: user._id,
        name: req.body["name"],
        users: [user]
    }).save(function (err, topic) {
        if (err)
            res.status(500).json(err);
        else {
            res.json(topic);
        }
    });
});
exports.api.get("/topics/:id", middleware_1.authorizeToken, function (req, res) {
    models_1.Topic.findById(req.params["id"])
        .populate("images")
        .exec(function (err, topic) {
        res.json(topic);
    });
});
exports.api.post("/topics/:id", middleware_1.authorizeToken, function (req, res) {
    new models_1.Image({
        _creator: req.authenticatedUser._id,
        _topic: req.params["id"],
        description: req.body["description"],
        url: req.body["url"]
    }).save(function (err, image) {
        models_1.Topic.findById(req.params["id"], function (err, topic) {
            topic.images.push(image._id);
            topic.save(function (err) {
                if (err)
                    res.status(401).json(err);
                else {
                    res.sendStatus(200);
                }
            });
        });
    });
});
exports.api.post("/get_signed_upload", middleware_1.authorizeToken, function (req, res) {
    var s3 = new aws.S3();
    var s3_params = {
        Bucket: "famjam",
        Key: uuid.v4(),
        ContentType: req.body["file_type"]
    };
    s3.getSignedUrl("putObject", s3_params, function (err, data) {
        if (err)
            res.status(500).json(err);
        else {
            res.json(data);
        }
    });
});
