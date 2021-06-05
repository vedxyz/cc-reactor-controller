var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import express from "express";
import https from "https";
import helmet from "helmet";
import { RateLimiterMemory } from "rate-limiter-flexible";
import path from "path";
import fsutils from "./fsutils.js";
const app = express();
const httpsCredentials = {
    key: fsutils.getHttpsCredential("privkey.pem"),
    cert: fsutils.getHttpsCredential("cert.pem"),
};
const rateLimiter = new RateLimiterMemory({
    keyPrefix: "middleware",
    points: 10,
    duration: 1,
});
app.use(helmet());
app.use((req, res, next) => {
    rateLimiter
        .consume(req.ip)
        .then(() => {
        next();
    })
        .catch(() => {
        res.status(429).send("Too Many Requests");
    });
});
app.use("/scripts", express.static(path.join("..", "scripts")));
app.get("/getscripts", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    res.send((yield fsutils.getScriptAddresses()).map((script) => "https://new.vedat.xyz:3000/scripts/" + script));
}));
app.post("/savescript", (req, res) => {
    req.headers.authorization;
});
https.createServer(httpsCredentials, app).listen(3000, () => {
    console.log("Listening on port 3000.");
});
