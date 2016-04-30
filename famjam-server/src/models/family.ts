import { Schema, model } from "mongoose";

const familySchema = new Schema({
  attributes: {
    displayName: String
  },
  members: [{ type: Schema.Types.ObjectId, ref: "User" }],
  name: String
});

export const family = model("Family", familySchema);
