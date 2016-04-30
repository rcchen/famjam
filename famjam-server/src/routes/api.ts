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
  bcrypt.hash(req.body.password, 10, (err, password) => {
    new User({ username, password, attributes }).save((err, user: IUser) => {
      res.json(user);
    });
  });
});

api.post("/authenticate", (req, res) => {
  const username = req.body.username;
  User.findOne({ username }, "password", (err, user: IUser) => {
    bcrypt.compare(req.body.password, user.password, (err, authenticated) => {
      if (authenticated) {
        const uid = user._id;
        jsonwebtoken.sign({ uid }, config.secret, {}, (token) => {
          res.json(token);
        });
      } else {
        res.sendStatus(401);
      }
    });
  });
});

api.get("/users", authorizeToken, (req, res) => {
  User.find({}, (err, users) => {
    res.json(users);
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

api.post("/families/:id/join", authorizeToken, (req, res) => {
  const uid = (req.authenticatedUser as IUser)._id;
  Family.findById(req.params["id"], (err, family: IFamily) => {
    family.members.push(uid);
    family.save(_ => {
      User.findById(uid, (err, user: IUser) => {
        user.families.push(family._id);
        user.save(_ => res.sendStatus(200));
      });
    });
  });
  return res.sendStatus(500);
});

api.get("/topics", authorizeToken, (req, res) => {
  const uid = (req.authenticatedUser as IUser)._id;
  Topic.find({
    $or: [
      { _creator: uid },
      { users: {
        $in: [ uid ]
      }}
    ]
  }, (err, topics) => {
    res.json(topics);
  });
});

api.post("/topics", authorizeToken, (req, res) => {
  const user = req.authenticatedUser as IUser;
  new Topic({
    _creator: user._id,
    name: req.body["name"],
    users: req.body["users"]
  }).save((err, topic) => {
    if (err) res.status(500).json(err);
    else {
      res.json(topic);
    }
  });
});

api.get("/topics/:id", authorizeToken, (req, res) => {
  Topic.findById(req.params["id"])
    .populate("_creator")
    .populate("images")
    .populate("users")
    .exec((err, topic) => {
      res.json({
        user: req.authenticatedUser,
        topic
      });
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

api.post("/get_signed_upload", authorizeToken, (req, res) => {
  const s3_params = {
    Bucket: "famjam",
    Key: uuid.v4(),
    ContentType: req.body["file_type"]
  };
  s3.getSignedUrl("putObject", s3_params, (err, data) => {
    if (err) res.status(500).json(err);
    else {
      res.json(data);
    }
  });
});
