import express from "express";
import { familyController } from "../controllers";

const router = express.Router();

router.get("/get", familyController.getFamily);
router.post("/add", familyController.addFamily);
router.put("/update", familyController.updateFamily);

export default router;