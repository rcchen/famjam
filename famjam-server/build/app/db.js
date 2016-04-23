"use strict";
var mongoose = require("mongoose");
var mongoUri = process.env.MONGODB_URI;
mongoose.connect(mongoUri);
exports.db = mongoose.connection;
