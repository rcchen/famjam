import * as mongoose from "mongoose";

mongoose.connect("mongodb://localhost/famjam");

export const db = mongoose.connection;
