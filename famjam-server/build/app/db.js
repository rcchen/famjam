"use strict";
var mongoose = require("mongoose");
mongoose.connect("mongodb://localhost/famjam");
exports.db = mongoose.connection;
