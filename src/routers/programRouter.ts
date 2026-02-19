import express from "express";
import { programController } from "../controllers";
import { roleCheck } from "../helper";
import { ROLES } from "../common";

const router = express.Router();

router.post("/create", roleCheck([ROLES.ADMIN, ROLES.LEADER]), programController.createProgram);
router.put("/update", roleCheck([ROLES.ADMIN, ROLES.LEADER]), programController.updateProgram);
router.get("/get", programController.getPrograms);
router.get("/:id", programController.getProgramById);
router.delete("/:id", roleCheck([ROLES.ADMIN, ROLES.LEADER]), programController.deleteProgram);

export default router;