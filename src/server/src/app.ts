import express from "express";
import https from "https";
import helmet from "helmet";
import { RateLimiterMemory } from "rate-limiter-flexible";
import fsutils from "./fsutils.js";

const app = express();
const host = "new.vedat.xyz";
const port = 3000;
const apiKey = fsutils.getApiKey();

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
app.use(express.json());
app.use("/scripts", express.static(fsutils.getScriptsDirPath()));

app.get("/getscripts", async (req, res) => {
    res.send(
        (await fsutils.getScriptAddresses()).map(
            (script) => `https://${host}:${port}/scripts/${script}`
        )
    );
});

app.post("/savescript", (req, res) => {
    if (!req.headers.authorization) {
        res.status(401).send("Authentication Required");
    } else {
        const [type, credentials] = [...req.headers.authorization.split(" ")];

        if (type.toLowerCase() !== "basic" || credentials !== apiKey) {
            res.status(403).send("Forbidden");
            return;
        }

        if (req.body.name && req.body.content) {
            fsutils.saveScript(req.body.name, req.body.content);
            res.status(200).send(`https://${host}:${port}/scripts/${req.body.name}`);
        } else {
            res.status(400).send("Bad Request");
        }
    }
});

https.createServer(httpsCredentials, app).listen(port, () => {
    console.log(`Listening on port ${port}.`);
});
