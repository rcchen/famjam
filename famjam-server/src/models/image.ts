import { Schema, model } from "mongoose";
const autopopulate = require("mongoose-autopopulate");

const imageSchema = new Schema({
  _creator: { type: Schema.Types.ObjectId, ref: "User", autopopulate: true },
  _topic: { type: Schema.Types.ObjectId, ref: "Topic" },
  created: { type: Date, default: Date.now },
  description: String,
  url: String,
});

imageSchema.plugin(autopopulate);

export const Image = model("Image", imageSchema);
