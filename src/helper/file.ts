import fs from "fs";
import path from "path";

export const deleteFile = (filePath: string) => {
    try {
        if (!filePath) return;

        // Extract filename from URL or path
        const filename = path.basename(filePath);

        // Construct absolute path
        const absolutePath = path.join(process.cwd(), "uploads", filename);

        if (fs.existsSync(absolutePath)) {
            fs.unlinkSync(absolutePath);
            console.log(`Deleted file: ${absolutePath}`);
        }
    } catch (error) {
        console.error(`Error deleting file: ${error.message}`);
    }
};
