import { promises as fs, readFileSync } from "fs";
import path from "path";

const saveScript = async (name: string, content: string): Promise<boolean> => {
    try {
        await fs.writeFile(path.join("..", "scripts", name), content);
        return true;
    } catch (error) {
        console.error(error);
        return false;
    }
};

const getScriptAddresses = async (): Promise<string[]> => {
    return await fs.readdir(path.join("..", "scripts"));
};

const getHttpsCredential = (certificate: string): string => {
    return readFileSync(path.join("..", "certificates", certificate), "utf8");
};

export default {
    saveScript,
    getScriptAddresses,
    getHttpsCredential,
};
