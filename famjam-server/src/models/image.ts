import { Schema, model } from "mongoose";

const imageSchema = new Schema({
  _id: Number,
  _owner: { type: Number, ref: "User" },
  description: String
});

export const Image = model("Image", imageSchema);
