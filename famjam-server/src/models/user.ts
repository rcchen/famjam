import { Schema, model } from "mongoose";

const userSchema = new Schema({
  username: String,
  password: String,
  topics: [{ type: Schema.Types.ObjectId, ref: "Topic" }]
});

export const User = model("User", userSchema);
