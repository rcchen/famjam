"use strict";
var mongoose_1 = require("mongoose");
var userSchema = new mongoose_1.Schema({
    _id: mongoose_1.Schema.Types.ObjectId,
    attributes: {
        displayName: String,
        profileUrl: String
    },
    families: [{ type: mongoose_1.Schema.Types.ObjectId, ref: "Family" }],
    password: { type: String, select: false },
    username: String
});
exports.User = mongoose_1.model("User", userSchema);
