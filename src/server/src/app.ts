import express from "express";
import https from "https";
import helmet from "helmet";
import { RateLimiterMemory } from "rate-limiter-flexible";
import fsutils from "./fsutils.js";

const app = express();

const httpsCredentials = {
    key: fsutils.getHttpsCredential("privkey.pem"),
    cert: fsutils.getHttpsCredential("cert.pem"),
}

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
app.use("/scripts", express.static(fsutils.getScriptsDirPath()));

app.get("/getscripts", async (req, res) => {
    res.send(
        (await fsutils.getScriptAddresses()).map(
            (script) => "https://new.vedat.xyz:3000/scripts/" + script
        )
    );
});

app.post("/savescript", (req, res) => {
    req.headers.authorization;
});

https.createServer(httpsCredentials, app).listen(3000, () => {
    console.log("Listening on port 3000.");
})
