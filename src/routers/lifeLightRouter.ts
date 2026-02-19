import express from "express";
import { ROLES } from "../common";
import { lifeLightController } from "../controllers";
import { roleCheck } from "../helper";

const router = express.Router();

router.post("/add", lifeLightController.addLifeLight);
router.put("/update", lifeLightController.updateLifeLight);
router.get("/get", roleCheck([ROLES.ADMIN]), lifeLightController.getLifeLight);
router.get("/user/:id", lifeLightController.getByUserId);
router.get("/get/:id", lifeLightController.getById);
router.delete("/delete/:id", lifeLightController.deleteLifeLight);

export default router;