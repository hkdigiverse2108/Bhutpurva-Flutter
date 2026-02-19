import express from "express";
import { feedbackController } from "../controllers";
import { ROLES } from "../common";
import { roleCheck } from "../helper";

const router = express.Router();

router.post("/add", feedbackController.addFeedback);
router.get("/get", roleCheck([ROLES.ADMIN]), feedbackController.getFeedback);
router.delete("/:id", roleCheck([ROLES.ADMIN]), feedbackController.deleteFeedback);

export default router;