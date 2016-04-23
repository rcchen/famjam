import { Schema, model } from "mongoose";

const topicSchema = new Schema({
  _creator: { type: Schema.Types.ObjectId, ref: "User" },
  name: String,
  users: [{ type: Schema.Types.ObjectId, ref: "User" }],
  images: [{ type: Schema.Types.ObjectId, ref: "Image"}],
  created: { type: Date, default: Date.now }
});

export const Topic = model("Topic", topicSchema);
