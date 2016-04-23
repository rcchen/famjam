"use strict";
var mongoose = require("mongoose");
mongoose.connect(process.env.MONGODB_URI);
exports.db = mongoose.connection;
