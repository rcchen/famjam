import * as express from "express";
import * as jwt from "jsonwebtoken";

import { config } from "../app/config";
import { IUser } from "../app/interfaces";
import { User } from "../models";

export const authorizeToken = (req: express.Request, res: express.Response, next: express.NextFunction) => {
  const authorizationHeader = req.header("Authorization");
  if (authorizationHeader === undefined) res.sendStatus(401);
  else {
    const token = authorizationHeader.split(" ")[1];
    jwt.verify(token, config.secret, (err, decoded: { uid: string }) => {
      if (err) res.sendStatus(401);
      else {
        User.findById(decoded.uid, (err, user: IUser) => {
          if (err) res.sendStatus(401);
          req.authenticatedUser = user;
          next();
        });        
      }
    });
  }
}
