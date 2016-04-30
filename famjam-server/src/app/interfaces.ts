import * as mongoose from "mongoose";

import { Image } from "../models";

export interface IFamily extends mongoose.Model<any> {
  _id: string;
  members: string[]; // stores _ids of members of family
  attributes: {
    displayName: string;
  };
}

export interface IImage extends mongoose.Model<any> {
  _creator: string;
  _id: string;
  _topic: string;
  description: string;
  url: string;
  created: Date
}

export interface ITopic extends mongoose.Model<any> {
  _creator: string;
  _family: string;
  _id: string;
  active: boolean;
  locked: boolean;
  name: string;
  images: string[];
  created: Date
}

export interface IUser extends mongoose.Model<any> {
  _id: string;
  username: string;
  password: string;
  attributes: {
    displayName: string;
    profileUrl: string;
  };
  families: string[]; // stores _ids of families that user is a part of
}
