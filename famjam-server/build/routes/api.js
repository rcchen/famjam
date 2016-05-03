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
    var attributes = {
        displayName: req.body.displayName
    };
    models_1.User.findOne({ username: username }, function (err, user) {
        if (user)
            return res.sendStatus(409);
        bcrypt.hash(req.body.password, 10, function (err, password) {
            new models_1.User({ username: username, password: password, attributes: attributes }).save(function (err, user) {
                res.json(user);
            });
        });
    });
});
exports.api.post("/authenticate", function (req, res) {
    var username = req.body.username;
    models_1.User.findOne({ username: username }, "password", function (err, user) {
        if (user !== null) {
            bcrypt.compare(req.body.password, user.password, function (err, authenticated) {
                if (authenticated) {
                    var uid = user._id;
                    jsonwebtoken.sign({ uid: uid }, config_1.config.secret, {}, function (token) {
                        return res.json(token);
                    });
                }
            });
        }
        else {
            return res.sendStatus(401);
        }
    });
});
exports.api.get("/users", middleware_1.authorizeToken, function (req, res) {
    models_1.User.find({}, function (err, users) {
        res.json(users);
    });
});
exports.api.get("/me", middleware_1.authorizeToken, function (req, res) {
    var uid = req.authenticatedUser._id;
    models_1.User.findById(uid)
        .populate("families")
        .exec(function (err, user) {
        if (err)
            return res.status(500).json(err);
        res.json(user);
    });
});
exports.api.get("/families", middleware_1.authorizeToken, function (req, res) {
    models_1.Family.find({
        attributes: {
            displayName: req.query["displayName"]
        }
    }, function (err, families) {
        res.json(families);
    });
});
exports.api.post("/families", middleware_1.authorizeToken, function (req, res) {
    var uid = req.authenticatedUser._id;
    new models_1.Family({
        attributes: {
            displayName: req.body["displayName"]
        },
        members: [uid]
    }).save(function (err, family) {
        models_1.User.findById(uid, function (err, user) {
            user.families.push(family._id);
            user.save(function (_) { return res.json(family); });
        });
    });
});
exports.api.get("/families/:id", middleware_1.authorizeToken, function (req, res) {
    var uid = req.authenticatedUser._id;
    models_1.Family.findById(req.params["id"])
        .populate("_members")
        .exec(function (err, family) {
        if (err)
            return res.status(500).json(err);
        return res.json(family);
    });
});
exports.api.post("/families/:id/join", middleware_1.authorizeToken, function (req, res) {
    var uid = req.authenticatedUser._id;
    models_1.Family.findById(req.params["id"], function (err, family) {
        if (err)
            return res.status(500).json(err);
        if (family.members.indexOf(uid) > 0)
            return res.status(200);
        family.members.push(uid);
        family.save(function (_) {
            models_1.User.findById(uid, function (err, user) {
                if (err)
                    return res.status(500).json(err);
                user.families.push(family._id);
                user.save(function (_) { return res.sendStatus(200); });
            });
        });
    });
});
exports.api.get("/topics", middleware_1.authorizeToken, function (req, res) {
    var user = req.authenticatedUser;
    models_1.Topic.find({
        _family: {
            $in: user.families
        }
    }, function (err, topics) {
        if (err)
            res.status(500).json(err);
        res.json(topics);
    });
});
exports.api.post("/topics", middleware_1.authorizeToken, function (req, res) {
    var user = req.authenticatedUser;
    new models_1.Topic({
        _creator: user._id,
        _family: user.families[0],
        active: true,
        locked: true,
        name: req.body["name"]
    }).save(function (err, topic) {
        if (err)
            return res.status(500).json(err);
        else {
            res.json(topic);
        }
    });
});
exports.api.get("/topics/:id", middleware_1.authorizeToken, function (req, res) {
    models_1.Topic.findById(req.params["id"])
        .populate("_creator")
        .populate("_family")
        .populate("images")
        .exec(function (err, topic) {
        if (err)
            return res.status(500).json(err);
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
