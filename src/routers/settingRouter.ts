import express from 'express';
import { settingController } from '../controllers';
import { ROLES } from '../common';
import { roleCheck } from '../helper';

const router = express.Router();

router.post('/add-update', roleCheck([ROLES.ADMIN]), settingController.addUpdateSetting);
router.get('/get', settingController.getSetting);
router.get('/get-sgis-pdf', settingController.getSgisPdf);

export default router;