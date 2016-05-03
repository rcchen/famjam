import * as mongoose from "mongoose";

const mongoUri = process.env.MONGODB_URI;

mongoose.connect(mongoUri);
// HACKHACK: Override with native ES6 promises
(mongoose as any).Promise = global.Promise;

export const db = mongoose.connection;
