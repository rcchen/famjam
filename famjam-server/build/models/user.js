"use strict";
var mongoose_1 = require("mongoose");
var userSchema = new mongoose_1.Schema({
    _id: mongoose_1.Schema.Types.ObjectId,
    username: String,
    password: { type: String, select: false },
    topics: [{ type: mongoose_1.Schema.Types.ObjectId, ref: "Topic" }]
});
exports.User = mongoose_1.model("User", userSchema);
