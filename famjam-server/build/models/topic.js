"use strict";
var mongoose_1 = require("mongoose");
var topicSchema = new mongoose_1.Schema({
    _creator: { type: mongoose_1.Schema.Types.ObjectId, ref: "User" },
    _family: { type: mongoose_1.Schema.Types.ObjectId, ref: "Family" },
    active: Boolean,
    created: { type: Date, default: Date.now },
    images: [{ type: mongoose_1.Schema.Types.ObjectId, ref: "Image" }],
    locked: Boolean,
    name: String
});
exports.Topic = mongoose_1.model("Topic", topicSchema);
