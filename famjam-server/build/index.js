"use strict";
var express = require("express");
var morgan = require("morgan");
var app_1 = require("./app");
var routes_1 = require("./routes");
var app = express();
app.use(morgan("dev"));
app.use("/api", routes_1.api);
app_1.db.on('error', console.error.bind(console, 'connection error:'));
app_1.db.once('open', function () {
    console.log("Connected to MongoDB");
});
app.set('port', (process.env.PORT || 3080));
app.listen(app.get('port'), function () {
    console.log('Node app is running on port', app.get('port'));
});
