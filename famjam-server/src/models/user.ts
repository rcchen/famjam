import { Schema, model } from "mongoose";

const userSchema = new Schema({
  username: String,
  password: { type: String, select: false },
  topics: [{ type: Schema.Types.ObjectId, ref: "Topic" }]
});

export const User = model("User", userSchema);
