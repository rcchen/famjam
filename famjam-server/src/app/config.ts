interface IConfig {
  secret: string;
}

export const config: IConfig = {
  secret: process.env.FAMJAM_SECRET || "DEV_SECRET"
};
