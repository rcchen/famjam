import { Schema, model } from "mongoose";

const userSchema = new Schema({
  _id: Schema.Types.ObjectId,
  username: String,
  password: { type: String, select: false },
  topics: [{ type: Schema.Types.ObjectId, ref: "Topic" }]
});

export const User = model("User", userSchema);
