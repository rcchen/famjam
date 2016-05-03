"use strict";
var mongoose = require("mongoose");
var mongoUri = process.env.MONGODB_URI;
mongoose.connect(mongoUri);
mongoose.Promise = global.Promise;
exports.db = mongoose.connection;
