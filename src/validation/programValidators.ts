import joi from "joi";
import { objectId } from "../common";

export const createProgramSchema = joi.object({
    name: joi.string().required(),
    batchId: objectId().required(),
    description: joi.string().optional(),
    date: joi.date().optional(),
});

export const updateProgramSchema = joi.object({
    programId: objectId().required(),
    name: joi.string().optional(),
    batchId: objectId().optional(),
    description: joi.string().optional(),
    date: joi.date().optional(),
});

export const getProgramsSchema = joi.object({
    page: joi.number().optional().default(1),
    limit: joi.number().optional(),
    search: joi.string().allow("", null).optional(),
    batchFilter: objectId().optional(),
});