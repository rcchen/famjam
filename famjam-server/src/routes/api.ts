import * as aws from "aws-sdk";
import * as bcrypt from "bcrypt";
import * as bodyParser from "body-parser";
import * as express from "express";
import * as jsonwebtoken from "jsonwebtoken";
import * as uuid from "node-uuid";

import { config } from "../app/config";
import { IUser } from "../app/interfaces";
import { authorizeToken } from "../middleware";
import { Image, Topic, User } from "../models";

export const api = express();

// load JSON parsing middleware
api.use(bodyParser.json());

// set AWS region
aws.config.region = "us-west-2";

api.post("/users", (req, res) => {
  const username = req.body.username;
  bcrypt.hash(req.body.password, 10, (err, password) => {
    new User({ username, password }).save((err, user: IUser) => {
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

api.get("/topics", authorizeToken, (req, res) => {
  const _creator = (req.authenticatedUser as IUser)._id;
  Topic.find({ _creator }, (err, topics) => {
    res.json(topics);
  });
});

api.post("/topics", authorizeToken, (req, res) => {
  new Topic({
    _creator: (req.authenticatedUser as IUser)._id,
    name: req.param("name"),
  }).save((err, topic) => {
    if (err) res.status(500).json(err);
    else {
      res.json(topic);
    }
  });
});

api.get("/topics/:id", authorizeToken, (req, res) => {
  Topic.findById(req.param("id"), (err, topic) => {
    res.json(topic);
  });
});

api.post("/topics/:id", (req, res) => {

});

api.post("/get_signed_upload", authorizeToken, (req, res) => {
  const s3 = new aws.S3();
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
