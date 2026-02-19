import joi from "joi";
import { objectId } from "../common";

export const addAnubhutiSchema = joi.object({
    anubhuti: joi.string().required(),
});

export const updateAnubhutiSchema = joi.object({
    anubhuti: joi.string().required(),
    anubhutiId: objectId().required(),
});

export const getAnubhutiSchema = joi.object({
    page: joi.number().optional().default(1),
    limit: joi.number().optional(),
    userFilter: objectId().optional(),
});