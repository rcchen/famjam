import * as mongoose from "mongoose";

import { Image } from "../models";

export interface IImage extends mongoose.Model<any> {
  _id: string;
  url: string;
}

export interface ITopic extends mongoose.Model<any> {
  _id: string;
  images: string[];
}

export interface IUser extends mongoose.Model<any> {
  _id: string;
  username: string;
  password: string;
}
