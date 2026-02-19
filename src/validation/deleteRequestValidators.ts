import joi from "joi";
import { DELETE_REQUEST_STATUS } from "../common";

export const getDeleteRequestSchema = joi.object({
    page: joi.number().optional().default(1),
    limit: joi.number().optional(),
    status: joi.string().optional().default(DELETE_REQUEST_STATUS.PENDING),
});

export const updateDeleteRequestSchema = joi.object({
    id: joi.string().required(),
    status: joi.string().required().valid(DELETE_REQUEST_STATUS.APPROVED, DELETE_REQUEST_STATUS.REJECTED),
});
