import * as express from "express";
import * as morgan from "morgan";

import { db } from "./app";
import { User } from "./models";
import { api } from "./routes";

const app = express();

app.use(morgan("dev"));
app.use("/api", api);

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
  // we're connected!
  console.log("connected");
});

app.listen(3080);
