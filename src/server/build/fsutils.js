var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import { promises as fs, readFileSync } from "fs";
import path from "path";
const saveScript = (name, content) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        yield fs.writeFile(path.join("..", "scripts", name), content);
        return true;
    }
    catch (error) {
        console.error(error);
        return false;
    }
});
const getScriptAddresses = () => __awaiter(void 0, void 0, void 0, function* () {
    return yield fs.readdir(path.join("..", "scripts"));
});
const getHttpsCredential = (certificate) => {
    return readFileSync(path.join("..", "certificates", certificate), "utf8");
};
export default {
    saveScript,
    getScriptAddresses,
    getHttpsCredential,
};
