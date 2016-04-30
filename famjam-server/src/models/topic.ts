import { Schema, model } from "mongoose";

const topicSchema = new Schema({
  _creator: { type: Schema.Types.ObjectId, ref: "User" },
  _family: { type: Schema.Types.ObjectId, ref: "Family" },
  active: Boolean,
  created: { type: Date, default: Date.now },
  images: [{ type: Schema.Types.ObjectId, ref: "Image"}],
  locked: Boolean,
  name: String
});

export const Topic = model("Topic", topicSchema);
