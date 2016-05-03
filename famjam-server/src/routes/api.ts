import * as aws from "aws-sdk";
import * as bcrypt from "bcrypt";
import * as bodyParser from "body-parser";
import * as express from "express";
import * as jsonwebtoken from "jsonwebtoken";
import * as mongoose from "mongoose";
import * as multer from "multer";
import * as uuid from "node-uuid";

const multerS3 = require("multer-s3");

import { config } from "../app/config";
import { IFamily, IImage, ITopic, IUser } from "../app/interfaces";
import { authorizeToken } from "../middleware";
import { Family, Image, Topic, User } from "../models";

export const api = express();

// load JSON parsing middleware
api.use(bodyParser.json());

// set AWS region
aws.config.region = "us-west-2";

// Initialize S3 object
const s3 = new aws.S3();

api.post("/users", (req, res) => {
  const username = req.body.username;
  const attributes = {
    displayName: req.body.displayName
  };

  User.findOne({ username }, (err, user: IUser) => {
    if (user) return res.sendStatus(409);
    bcrypt.hash(req.body.password, 10, (err, password) => {
      new User({ username, password, attributes }).save((err, user: IUser) => {
        res.json(user);
      });
    });
  });
});

api.post("/authenticate", (req, res) => {
  const username = req.body.username;
  User.findOne({ username }, "password", (err, user: IUser) => {
    if (user !== null) {
      bcrypt.compare(req.body.password, user.password, (err, authenticated) => {
        if (authenticated) {
          const uid = user._id;
          jsonwebtoken.sign({ uid }, config.secret, {}, (token) => {
            return res.json(token);
          });
        }
      });
    } else {
      return res.sendStatus(401);
    }
  });
});

api.get("/users", authorizeToken, (req, res) => {
  User.find({}, (err, users) => {
    res.json(users);
  });
});

api.get("/me", authorizeToken, (req, res) => {
  const uid = (req.authenticatedUser as IUser)._id;
  User.findById(uid)
    .populate("families")
    .exec((err, user) => {
      if (err) return res.status(500).json(err);
      res.json(user);
    });
});

api.get("/families", authorizeToken, (req, res) => {
  Family.find({
    attributes: {
      displayName: req.query["displayName"]
    }
  }, (err, families) => {
    res.json(families);
  });
});

api.post("/families", authorizeToken, (req, res) => {
  const uid = (req.authenticatedUser as IUser)._id;
  new Family({
    attributes: {
      displayName: req.body["displayName"]
    },
    members: [uid]
  }).save((err, family: IFamily) => {
    User.findById(uid, (err, user: IUser) => {
      user.families.push(family._id);
      user.save(_ => res.json(family));
    });
  });
});

api.get("/families/:id", authorizeToken, (req, res) => {
  const uid = (req.authenticatedUser as IUser)._id;
  Family.findById(req.params["id"])
    .populate("_members")
    .exec((err, family) => {
      if (err) return res.status(500).json(err);
      return res.json(family)
    })
});

api.post("/families/:id/join", authorizeToken, (req, res) => {
  const uid = (req.authenticatedUser as IUser)._id;
  Family.findById(req.params["id"], (err, family: IFamily) => {
    if (err) return res.status(500).json(err);
    if (family.members.indexOf(uid) > 0) return res.status(200);
    family.members.push(uid);
    family.save(_ => {
      User.findById(uid, (err, user: IUser) => {
        if (err) return res.status(500).json(err);
        user.families.push(family._id);
        user.save(_ => res.sendStatus(200));
      });
    });
  });
});

api.get("/topics", authorizeToken, (req, res) => {
  const user = req.authenticatedUser as IUser;
  Topic.find({
    _family: {
      $in: user.families
    }
  }, (err, topics) => {
    if (err) res.status(500).json(err);
    res.json(topics);
  });
});

api.post("/topics", authorizeToken, (req, res) => {
  const user = req.authenticatedUser as IUser;
  new Topic({
    _creator: user._id,
    _family: user.families[0],
    active: true,
    locked: true,
    name: req.body["name"]
  }).save((err, topic) => {
    if (err) return res.status(500).json(err);
    else {
      res.json(topic);
    }
  });
});

api.get("/topics/:id", authorizeToken, (req, res) => {
  Topic.findById(req.params["id"])
    .populate("_creator")
    .populate("_family")
    .populate("images")
    .exec((err, topic) => {
      if (err) return res.status(500).json(err);
      res.json(topic);
    });
});

const upload = multer({
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

api.post("/topics/:id", authorizeToken, upload.array("photo", 1), (req, res) => {
  new Image({
    _creator: (req.authenticatedUser as IUser)._id,
    _topic: req.params["id"],
    description: req.body["description"],
    url: (req.files[0] as any).location
  }).save((err, image: IImage) => {
    Topic.findById(req.params["id"], (err, topic: ITopic) => {
      topic.images.push(image._id);
      topic.save((err) => {
        if (err) res.status(401).json(err);
        else {
          res.sendStatus(200);
        }
      });
    });
  });
});
