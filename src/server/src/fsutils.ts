import { promises as fs, readFileSync } from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const scriptsDir = path.join(__dirname, "..", "scripts");

const saveScript = async (name: string, content: string): Promise<boolean> => {
    try {
        await fs.writeFile(path.join(scriptsDir, name), content);
        return true;
    } catch (error) {
        console.error(error);
        return false;
    }
};

const deleteScript = async (name: string): Promise<boolean> => {
    try {
        await fs.rm(path.join(__dirname, "..", name));
        return true;
    } catch (error) {
        console.error(error);
        return false;
    }
};

const getScriptAddresses = async (): Promise<string[]> => {
    return await fs.readdir(scriptsDir);
};

const getHttpsCredential = (certificate: string): string => {
    return readFileSync(path.join(__dirname, "..", "certificates", certificate), "utf8");
};

const getApiKey = (): string => {
    return JSON.parse(getHttpsCredential("apikey.json")).api_key;
}

export default {
    scriptsDir,
    saveScript,
    deleteScript,
    getScriptAddresses,
    getHttpsCredential,
    getApiKey,
};
