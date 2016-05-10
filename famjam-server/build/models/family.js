"use strict";
const mongoose_1 = require("mongoose");
const autopopulate = require("mongoose-autopopulate");
const familySchema = new mongoose_1.Schema({
    attributes: {
        displayName: String
    },
    members: [{ type: mongoose_1.Schema.Types.ObjectId, ref: "User", autopopulate: true }],
    name: String
});
familySchema.plugin(autopopulate);
exports.Family = mongoose_1.model("Family", familySchema);
