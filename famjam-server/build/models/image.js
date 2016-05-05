"use strict";
const mongoose_1 = require("mongoose");
const autopopulate = require("mongoose-autopopulate");
const imageSchema = new mongoose_1.Schema({
    _creator: { type: mongoose_1.Schema.Types.ObjectId, ref: "User", autopopulate: true },
    _topic: { type: mongoose_1.Schema.Types.ObjectId, ref: "Topic" },
    created: { type: Date, default: Date.now },
    description: String,
    url: String,
});
imageSchema.plugin(autopopulate);
exports.Image = mongoose_1.model("Image", imageSchema);
