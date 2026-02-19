"use strict"
import { Router } from "express";
import { verifyToken } from "../helper";
import authRouter from "./authRouter";
import userRouter from "./userRouter";
import batchRouter from "./batchRouter";
import groupRouter from "./groupRouter";
import programRouter from "./programRouter";
import attendanceRouter from "./attendanceRouter";
import anubhutiRouter from "./anubhutiRouter";
import deleteRequestRouter from "./deleteRequestRouter";
import familyRouter from "./familyRouter";
import feedbackRouter from "./feedbackRouter";
import legalityRouter from "./legalityRouter";
import lifeLightRouter from "./lifeLightRouter";
import uploadRouter from "./uploadRouter";
import settingRouter from "./settingRouter";
import tithiCalenderRouter from "./tithiCalenderRouter";
import bannerRouter from "./bannerRouter";


const router = Router();

// with out Token
router.use("/auth", authRouter);
router.use("/upload", uploadRouter);

// with Token
router.use(verifyToken);
router.use("/user", userRouter);
router.use("/batch", batchRouter);
router.use("/group", groupRouter);
router.use("/program", programRouter);
router.use("/attendance", attendanceRouter);
router.use("/anubhuti", anubhutiRouter);
router.use("/deleteRequest", deleteRequestRouter);
router.use("/family", familyRouter);
router.use("/feedback", feedbackRouter);
router.use("/legality", legalityRouter);
router.use("/lifeLight", lifeLightRouter);
router.use("/setting", settingRouter);
router.use("/tithiCalender", tithiCalenderRouter);
router.use("/banner", bannerRouter);


export { router };