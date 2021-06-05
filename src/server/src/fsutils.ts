import { promises as fs, readFileSync } from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const saveScript = async (name: string, content: string): Promise<boolean> => {
    try {
        await fs.writeFile(path.join(__dirname, "..", "scripts", name), content);
        return true;
    } catch (error) {
        console.error(error);
        return false;
    }
};

const getScriptAddresses = async (): Promise<string[]> => {
    return await fs.readdir(path.join(__dirname, "..", "scripts"));
};

const getHttpsCredential = (certificate: string): string => {
    return readFileSync(path.join(__dirname, "..", "certificates", certificate), "utf8");
};

const getScriptsDirPath = (): string => {
    return path.join(__dirname, "..", "scripts");
}

const getApiKey = (): string => {
    return JSON.parse(readFileSync(path.join(__dirname, "apikey.json"), "utf8")).api_key;
}

export default {
    saveScript,
    getScriptAddresses,
    getHttpsCredential,
    getScriptsDirPath,
    getApiKey,
};
