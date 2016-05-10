import { Schema, model } from "mongoose";
const autopopulate = require("mongoose-autopopulate");

const familySchema = new Schema({
  attributes: {
    displayName: String
  },
  members: [{ type: Schema.Types.ObjectId, ref: "User", autopopulate: true }],
  name: String
});
familySchema.plugin(autopopulate);

export const Family = model("Family", familySchema);
