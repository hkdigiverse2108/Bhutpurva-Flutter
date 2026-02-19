import joi from "joi";
import { FAMILY_RELATIONSHIP } from "../common";

export const memberSchema = joi.object({
    memberId: joi.string().required(),
    relationship: joi.string().valid(...Object.values(FAMILY_RELATIONSHIP)).required(),
});

export const addFamilySchema = joi.object({
    userId: joi.string().required(),
    members: joi.array().items(memberSchema).optional(),
});

export const updateFamilySchema = joi.object({
    familyId: joi.string().required(),
    members: joi.array().items(memberSchema).optional(),
});