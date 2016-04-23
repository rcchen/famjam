import { Schema, model } from "mongoose";

const imageSchema = new Schema({
  _creator: { type: Schema.Types.ObjectId, ref: "User" },
  _topic: { type: Schema.Types.ObjectId, ref: "Topic" },
  description: String,
  url: String
});

export const Image = model("Image", imageSchema);
