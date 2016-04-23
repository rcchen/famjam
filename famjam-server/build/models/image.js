"use strict";
var mongoose_1 = require("mongoose");
var imageSchema = new mongoose_1.Schema({
    _creator: { type: mongoose_1.Schema.Types.ObjectId, ref: "User" },
    _topic: { type: mongoose_1.Schema.Types.ObjectId, ref: "Topic" },
    description: String,
    url: String
});
exports.Image = mongoose_1.model("Image", imageSchema);
