import { Schema, model } from "mongoose";

const userSchema = new Schema({
  _id: Schema.Types.ObjectId,
  attributes: {
    displayName: String,
    profileUrl: String
  },
  families: [{ type: Schema.Types.ObjectId, ref: "Family" }],
  password: { type: String, select: false },
  username: String
});

export const User = model("User", userSchema);
