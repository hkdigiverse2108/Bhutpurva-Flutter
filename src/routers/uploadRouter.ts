import { Router } from "express";
import { upload, handleUploadError } from "../middleware";
import { uploadController } from "../controllers";
import { roleCheck, verifyToken } from "../helper";
import { ROLES } from "../common";

const router = Router();

router.post("/", upload.array("files"), handleUploadError, uploadController.uploadImages);
router.get("/", uploadController.getImages);
router.delete("/delete", verifyToken, roleCheck([ROLES.ADMIN]), uploadController.deleteImage);

export default router;
