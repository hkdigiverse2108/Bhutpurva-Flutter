import joi from "joi";
import { objectId } from "../common";
import { LIFE_LIGHT_TYPE } from "../common";

export const addLifeLightSchema = joi.object({
    userId: objectId().required(),
    lifeLight: joi.string().required(),
});

export const updateLifeLightSchema = joi.object({
    lifeLightId: objectId().required(),
    status: joi.string().valid(...Object.values(LIFE_LIGHT_TYPE)).required(),
});

export const getLifeLightSchema = joi.object({
    page: joi.number().optional().default(1),
    limit: joi.number().optional(),
    userFilter: objectId().optional(),
    statusFilter: joi.string().valid(...Object.values(LIFE_LIGHT_TYPE)).optional(),
});