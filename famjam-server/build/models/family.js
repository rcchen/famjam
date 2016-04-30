"use strict";
var mongoose_1 = require("mongoose");
var familySchema = new mongoose_1.Schema({
    attributes: {
        displayName: String
    },
    members: [{ type: mongoose_1.Schema.Types.ObjectId, ref: "User" }],
    name: String
});
exports.family = mongoose_1.model("Family", familySchema);
