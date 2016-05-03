"use strict";
const aws = require("aws-sdk");
const bcrypt = require("bcrypt");
const bodyParser = require("body-parser");
const express = require("express");
const jsonwebtoken = require("jsonwebtoken");
const multer = require("multer");
const uuid = require("node-uuid");
const multerS3 = require("multer-s3");
const config_1 = require("../app/config");
const middleware_1 = require("../middleware");
const models_1 = require("../models");
exports.api = express();
aws.config.region = "us-west-2";
const s3 = new aws.S3();
exports.api.post("/users", (req, res) => {
    const username = req.body.username;
    const attributes = {
        displayName: req.body.displayName
    };
    models_1.User.findOne({ username }, (err, user) => {
        if (user)
            return res.sendStatus(409);
        bcrypt.hash(req.body.password, 10, (err, password) => {
            new models_1.User({ username, password, attributes }).save((err, user) => {
                res.json(user);
            });
        });
    });
});
exports.api.post("/authenticate", bodyParser.json(), (req, res) => {
    const username = req.body.username;
    models_1.User.findOne({ username }, "password", (err, user) => {
        if (user !== null) {
            bcrypt.compare(req.body.password, user.password, (err, authenticated) => {
                if (authenticated) {
                    const uid = user._id;
                    jsonwebtoken.sign({ uid }, config_1.config.secret, {}, (token) => {
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
exports.api.get("/users", middleware_1.authorizeToken, (req, res) => {
    models_1.User.find({}, (err, users) => {
        res.json(users);
    });
});
exports.api.get("/users/:id", middleware_1.authorizeToken, (req, res) => {
    models_1.User.findById(req.params["id"], (err, user) => {
        res.json(user);
    });
});
exports.api.get("/me", middleware_1.authorizeToken, (req, res) => {
    const uid = req.authenticatedUser._id;
    models_1.User.findById(uid)
        .populate("families")
        .exec((err, user) => {
        if (err)
            return res.status(500).json(err);
        res.json(user);
    });
});
exports.api.get("/families", middleware_1.authorizeToken, (req, res) => {
    models_1.Family.find({
        attributes: {
            displayName: req.query["displayName"]
        }
    }, (err, families) => {
        res.json(families);
    });
});
exports.api.post("/families", bodyParser.json(), middleware_1.authorizeToken, (req, res) => {
    const uid = req.authenticatedUser._id;
    new models_1.Family({
        attributes: {
            displayName: req.body["displayName"]
        },
        members: [uid]
    }).save((err, family) => {
        models_1.User.findById(uid, (err, user) => {
            user.families.push(family._id);
            user.save(_ => res.json(family));
        });
    });
});
exports.api.get("/families/:id", middleware_1.authorizeToken, (req, res) => {
    const uid = req.authenticatedUser._id;
    models_1.Family.findById(req.params["id"])
        .populate("members")
        .exec((err, family) => {
        if (err)
            return res.status(500).json(err);
        return res.json(family);
    });
});
exports.api.post("/families/:id/join", bodyParser.json(), middleware_1.authorizeToken, (req, res) => {
    const uid = req.authenticatedUser._id;
    models_1.Family.findById(req.params["id"], (err, family) => {
        if (err)
            return res.status(500).json(err);
        if (family.members.indexOf(uid) > 0)
            return res.status(200);
        family.members.push(uid);
        family.save(_ => {
            models_1.User.findById(uid, (err, user) => {
                if (err)
                    return res.status(500).json(err);
                user.families.push(family._id);
                user.save(_ => res.sendStatus(200));
            });
        });
    });
});
exports.api.get("/topics", middleware_1.authorizeToken, (req, res) => {
    const user = req.authenticatedUser;
    console.log(req.query["active"]);
    let filter = {
        _family: {
            $in: user.families
        }
    };
    if (req.query["active"] !== undefined) {
        filter["active"] = req.query["active"] == "true";
    }
    models_1.Topic.find(filter, (err, topics) => {
        if (err)
            res.status(500).json(err);
        res.json(topics);
    });
});
exports.api.post("/topics", bodyParser.json(), middleware_1.authorizeToken, (req, res) => {
    const user = req.authenticatedUser;
    new models_1.Topic({
        _creator: user._id,
        _family: user.families[0],
        active: true,
        locked: true,
        name: req.body["name"]
    }).save((err, topic) => {
        if (err)
            return res.status(500).json(err);
        else {
            res.json(topic);
        }
    });
});
exports.api.get("/topics/:id", middleware_1.authorizeToken, (req, res) => {
    models_1.Topic.findById(req.params["id"])
        .populate("_creator")
        .populate("_family")
        .populate("images")
        .exec((err, topic) => {
        if (err)
            return res.status(500).json(err);
        res.json(topic);
    });
});
exports.api.put("/topics/:id", bodyParser.json(), middleware_1.authorizeToken, (req, res) => {
    let setOptions = {};
    if (req.body["active"] !== undefined) {
        setOptions["active"] = req.body["active"];
    }
    if (req.body["locked"] !== undefined) {
        setOptions["locked"] = req.body["locked"];
    }
    models_1.Topic.findOneAndUpdate({ _id: req.params["id"] }, {
        $set: setOptions
    }, { new: true })
        .exec((err, topic) => {
        if (err)
            return res.status(500).json(err);
        res.json(topic);
    });
});
exports.api.get("/topics/:id/participants", middleware_1.authorizeToken, (req, res) => {
    const topicId = req.params["id"];
    models_1.Topic.findById(topicId)
        .exec((err, topic) => {
        models_1.Family.findById(topic._family)
            .exec((err, family) => {
            const userIds = family.members;
            models_1.Image.find({ _topic: topicId })
                .exec((err, images) => {
                const submittedUserIds = images.map((image) => image._creator.toString());
                const unsubmittedUserIds = userIds.filter((userId) => {
                    return submittedUserIds.indexOf(userId.toString()) < 0;
                });
                const submittedUsers = models_1.User.find({ _id: { $in: submittedUserIds } }).exec();
                const unsubmittedUsers = models_1.User.find({ _id: { $in: unsubmittedUserIds } }).exec();
                Promise.all([
                    submittedUsers, unsubmittedUsers
                ]).then((responses) => {
                    res.json({
                        submitted: responses[0],
                        not_submitted: responses[1]
                    });
                });
            });
        });
    });
});
const upload = multer({
    limits: {
        fileSize: 1000000
    },
    storage: multerS3({
        acl: "public-read",
        bucket: "famjam",
        contentType: (req, file, cb) => {
            cb(null, "image/jpeg");
        },
        key: (req, file, cb) => {
            cb(null, uuid.v4());
        },
        s3: s3
    })
});
exports.api.post("/topics/:id", middleware_1.authorizeToken, upload.single("photo"), (req, res) => {
    new models_1.Image({
        _creator: req.authenticatedUser._id,
        _topic: req.params["id"],
        description: req.body["description"],
        url: req.file.location
    }).save((err, image) => {
        models_1.Topic.findById(req.params["id"], (err, topic) => {
            topic.images.push(image._id);
            topic.save((err) => {
                if (err)
                    res.status(401).json(err);
                else {
                    res.sendStatus(200);
                }
            });
        });
    });
});
