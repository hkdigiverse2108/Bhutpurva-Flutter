import joi from "joi";
import { LEGALITY_TYPE } from "../common";

export const addUpdateLegalitySchema = joi.object({
    type: joi.string().valid(...Object.values(LEGALITY_TYPE)).required(),
    content: joi.string().required(),
});

export const getLegalitySchema = joi.object({
    type: joi.string().valid(...Object.values(LEGALITY_TYPE)).required(),
});