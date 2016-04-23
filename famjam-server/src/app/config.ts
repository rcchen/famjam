interface IConfig {
  secret: string;
}

export const config: IConfig = require("../../config.json");
