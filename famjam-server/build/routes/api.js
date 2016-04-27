"use strict";
var aws = require("aws-sdk");
var bcrypt = require("bcrypt");
var bodyParser = require("body-parser");
var express = require("express");
var jsonwebtoken = require("jsonwebtoken");
var multer = require("multer");
var uuid = require("node-uuid");
var multerS3 = require("multer-s3");
var config_1 = require("../app/config");
var middleware_1 = require("../middleware");
var models_1 = require("../models");
exports.api = express();
exports.api.use(bodyParser.json());
aws.config.region = "us-west-2";
var s3 = new aws.S3();
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
    var uid = req.authenticatedUser._id;
    models_1.Topic.find({
        $or: [
            { _creator: uid },
            { users: {
                    $in: [uid]
                } }
        ]
    }, function (err, topics) {
        res.json(topics);
    });
});
exports.api.post("/topics", middleware_1.authorizeToken, function (req, res) {
    var user = req.authenticatedUser;
    new models_1.Topic({
        _creator: user._id,
        name: req.body["name"],
        users: req.body["users"]
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
        .populate("_creator")
        .populate("images")
        .populate("users")
        .exec(function (err, topic) {
        res.json(topic);
    });
});
var upload = multer({
    storage: multerS3({
        acl: "public-read",
        bucket: "famjam",
        contentType: function (req, file, cb) {
            cb(null, "image/jpeg");
        },
        key: function (req, file, cb) {
            cb(null, uuid.v4());
        },
        s3: s3
    })
});
exports.api.post("/topics/:id", middleware_1.authorizeToken, upload.array("photo", 1), function (req, res) {
    new models_1.Image({
        _creator: req.authenticatedUser._id,
        _topic: req.params["id"],
        description: req.body["description"],
        url: req.files[0].location
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
