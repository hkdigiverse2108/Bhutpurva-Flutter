import express from "express";
import { ROLES } from "../common";
import { legalityController } from "../controllers";
import { roleCheck } from "../helper";

const router = express.Router();

router.post("/add-update", roleCheck([ROLES.ADMIN]), legalityController.addUpdateLegality);
router.get("/get", roleCheck([ROLES.ADMIN, ROLES.USER, ROLES.MONITOR, ROLES.LEADER]), legalityController.getLegality);

export default router;