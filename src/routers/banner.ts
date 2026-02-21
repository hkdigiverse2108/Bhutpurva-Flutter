import { Router } from "express";
import { bannerController } from "../controllers";
import { roleCheck } from "../helper";
import { ROLES } from "../common";

const router = Router();

router.post("/create", roleCheck([ROLES.ADMIN]), bannerController.createBanner);
router.get("/get", roleCheck([ROLES.ADMIN, ROLES.USER, ROLES.MONITOR, ROLES.LEADER]), bannerController.getAllBanners);
router.get("/get/:id", roleCheck([ROLES.ADMIN, ROLES.USER, ROLES.MONITOR, ROLES.LEADER]), bannerController.getBannerById);
router.put("/update", roleCheck([ROLES.ADMIN]), bannerController.updateBanner);
router.delete("/delete/:id", roleCheck([ROLES.ADMIN]), bannerController.deleteBanner);

export default router;
