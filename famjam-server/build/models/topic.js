"use strict";
var mongoose_1 = require("mongoose");
var topicSchema = new mongoose_1.Schema({
    _creator: { type: mongoose_1.Schema.Types.ObjectId, ref: "User" },
    name: String,
    users: [{ type: mongoose_1.Schema.Types.ObjectId, ref: "User" }],
    images: [{ type: mongoose_1.Schema.Types.ObjectId, ref: "Image" }],
    created: { type: Date, default: Date.now }
});
exports.Topic = mongoose_1.model("Topic", topicSchema);
