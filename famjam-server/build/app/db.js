"use strict";
var mongoose = require("mongoose");
var mongoUri = (process.env.NODE_ENV || "mongodb://localhost/test");
mongoose.connect(mongoUri);
exports.db = mongoose.connection;
