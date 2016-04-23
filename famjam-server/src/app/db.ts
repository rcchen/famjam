import * as mongoose from "mongoose";

mongoose.connect(process.env.MONGODB_URI);

export const db = mongoose.connection;
