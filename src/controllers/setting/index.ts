import { apiResponse, STATUS_CODE } from "../../common";
import { Setting } from "../../database";
import { getFirstMatch, reqInfo, updateData } from "../../helper";
import { settingSchema } from "../../validation";

export const addUpdateSetting = async (req, res) => {
    reqInfo(req)
    try {
        const { error, value } = settingSchema.validate(req.body);
        if (error) {
            return res.status(STATUS_CODE.BAD_REQUEST).json(new apiResponse(STATUS_CODE.BAD_REQUEST, error.details[0].message, {}, {}));
        }

        const setting = await updateData(Setting, {}, value, { upsert: true, new: true });
        return res.status(STATUS_CODE.SUCCESS).json(new apiResponse(STATUS_CODE.SUCCESS, "Setting updated successfully.", { setting }, {}));
    } catch (error) {
        console.log(error)
        return res.status(STATUS_CODE.INTERNAL_SERVER_ERROR).json(new apiResponse(STATUS_CODE.INTERNAL_SERVER_ERROR, error.message, {}, error));
    }
};

export const getSetting = async (req, res) => {
    reqInfo(req)
    try {
        const setting = await getFirstMatch(Setting, {}, {}, {});
        if (!setting) return res.status(STATUS_CODE.NOT_FOUND).json(new apiResponse(STATUS_CODE.NOT_FOUND, "Setting not found.", {}, {}));
        return res.status(STATUS_CODE.SUCCESS).json(new apiResponse(STATUS_CODE.SUCCESS, "Setting fetched successfully.", { setting }, {}));
    } catch (error) {
        console.log(error)
        return res.status(STATUS_CODE.INTERNAL_SERVER_ERROR).json(new apiResponse(STATUS_CODE.INTERNAL_SERVER_ERROR, error.message, {}, error));
    }
};

export const getSgisPdf = async (req, res) => {
    reqInfo(req)
    try {
        const setting = await getFirstMatch(Setting, {}, {}, {});
        if (!setting) return res.status(STATUS_CODE.NOT_FOUND).json(new apiResponse(STATUS_CODE.NOT_FOUND, "Setting not found.", {}, {}));
        return res.status(STATUS_CODE.SUCCESS).json(new apiResponse(STATUS_CODE.SUCCESS, "Setting fetched successfully.", { sgisPdf: setting.sgsiPdf }, {}));
    } catch (error) {
        console.log(error)
        return res.status(STATUS_CODE.INTERNAL_SERVER_ERROR).json(new apiResponse(STATUS_CODE.INTERNAL_SERVER_ERROR, error.message, {}, error));
    }
};