import express from "express";
import https from "https";
// import WebSocket from "ws";
import cors from "cors";
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
    ca: fsutils.getHttpsCredential("chain.pem"),
};

const rateLimiter = new RateLimiterMemory({
    keyPrefix: "middleware",
    points: 10,
    duration: 1,
});

app.use(helmet());
app.use(cors());
app.use((req, res, next) => {
    console.log("Received request from " + req.ip);
    next();
});
app.use((req, res, next) => {
    rateLimiter
        .consume(req.ip)
        .then(() => {
            next();
        })
        .catch(() => {
            res.status(429).send("Too Many Requests");
            console.log("-> Too many requests from " + req.ip);
        });
});
app.use(express.json());
app.use("/scripts", express.static(fsutils.scriptsDir));
app.use("/scripts", (req, res, next) => {
    if (req.method == "PUT" || req.method == "DELETE") {
        if (!req.headers.authorization) {
            res.status(401).send("Authentication Required");
        } else {
            const [type, credentials] = [...req.headers.authorization.split(" ")];
    
            if (type.toLowerCase() !== "bearer" || credentials !== apiKey) {
                res.status(403).send("Forbidden");
            } else {
                next();
            }
        }
    } else {
        next();
    }
});

app.get("/scripts", async (req, res) => {
    res.send(
        (await fsutils.getScriptAddresses()).reduce(
            (acc, cur) => ({
                ...acc,
                [cur]: `https://${host}:${port}/scripts/${cur}`,
            }),
            {}
        )
    );
});

app.put("/scripts", (req, res) => {
    if (req.body.name && req.body.content) {
        fsutils.saveScript(req.body.name, req.body.content);
        res.status(200).send(
            `https://${host}:${port}/scripts/${req.body.name}`
        );
    } else {
        res.status(400).send("Bad Request");
    }
});

app.delete("/scripts", (req, res) => {
    if (req.body.name) {
        fsutils.deleteScript(req.body.name);
        res.status(200).send("Deleted " + req.body.name);
    } else {
        res.status(400).send("Bad Request");
    }
});

const server = https.createServer(httpsCredentials, app)
/*
const wss = new WebSocket.Server({ server })

wss.on("connection", (ws, req) => {
    
    let interval: NodeJS.Timeout;
    
    ws.on("message", message => {
        
        console.log(message)
        
    });
    
    if (req.headers["X-Is-CC-Computer"] === "true") {
        
        interval = setInterval(() => {
            ws.send("get_data")
        }, 5000);
        
    }
    
    ws.on("close", () => {
        if (interval) clearInterval(interval);
    });
    
});
*/
server.listen(port, () => {
    console.log(`Listening on port ${port}.`);
});
