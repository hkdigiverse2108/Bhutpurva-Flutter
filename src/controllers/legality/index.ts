import { apiResponse, STATUS_CODE } from "../../common";
import { legalityModel } from "../../database";
import { getFirstMatch, updateData } from "../../helper";
import { addUpdateLegalitySchema, getLegalitySchema } from "../../validation";

export const addUpdateLegality = async (req, res) => {
    try {
        const { error, value } = addUpdateLegalitySchema.validate(req.body);
        if (error)
            return res.status(STATUS_CODE.BAD_REQUEST).json(new apiResponse(STATUS_CODE.BAD_REQUEST, "Validation error", {}, error.details[0].message));

        const legality = await updateData(legalityModel, { type: value.type }, { $set: value }, { new: true, upsert: true });
        return res.status(STATUS_CODE.SUCCESS).json(new apiResponse(STATUS_CODE.SUCCESS, "Legality Updated successfully", legality, {}));
    } catch (error) {
        console.error(error);
        return res.status(STATUS_CODE.BAD_REQUEST).json(new apiResponse(STATUS_CODE.BAD_REQUEST, "Error updating legality", {}, error));
    }
};

export const getLegality = async (req, res) => {
    try {
        const { error, value } = getLegalitySchema.validate(req.query);
        if (error)
            return res.status(STATUS_CODE.BAD_REQUEST).json(new apiResponse(STATUS_CODE.BAD_REQUEST, "Validation error", {}, error.details[0].message));

        const legality = await getFirstMatch(legalityModel, { type: value.type }, {}, {});
        return res.status(STATUS_CODE.SUCCESS).json(new apiResponse(STATUS_CODE.SUCCESS, "Legality fetched successfully", legality, {}));
    } catch (error) {
        console.error(error);
        return res.status(STATUS_CODE.BAD_REQUEST).json(new apiResponse(STATUS_CODE.BAD_REQUEST, "Error fetching legality", {}, error));
    }
};