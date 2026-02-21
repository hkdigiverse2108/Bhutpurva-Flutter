import mongoose from "mongoose";
import { MONTH, tithiCalenderModelName } from "../../common";

const calenderSchema = new mongoose.Schema({
    month: { type: String, enum: Object.values(MONTH) },
    image: { type: String },
}, { _id: false });

const tithiCalenderSchema = new mongoose.Schema({
    year: { type: Number },
    calender: { type: [calenderSchema] },
    isDeleted: { type: Boolean, default: false },
}, { timestamps: true, versionKey: false });

export const TithiCalender = mongoose.model(tithiCalenderModelName, tithiCalenderSchema);
