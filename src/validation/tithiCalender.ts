import joi from "joi";
import { MONTH } from "../common";

export const calenderSchema = joi.object({
    month: joi.string().valid(...Object.values(MONTH)).required(),
    image: joi.string().required(),
});

export const tithiCalenderSchema = joi.object({
    year: joi.number().required(),
    calender: joi.array().items(calenderSchema).required(),
});

export const addUpdateMonthSchema = joi.object({
    tithiCalenderId: joi.string().required(),
    month: joi.string().valid(...Object.values(MONTH)).required(),
    image: joi.string().required(),
});