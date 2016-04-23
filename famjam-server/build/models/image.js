"use strict";
var mongoose_1 = require("mongoose");
var imageSchema = new mongoose_1.Schema({
    _id: Number,
    _owner: { type: Number, ref: "User" },
    description: String
});
exports.Image = mongoose_1.model("Image", imageSchema);
