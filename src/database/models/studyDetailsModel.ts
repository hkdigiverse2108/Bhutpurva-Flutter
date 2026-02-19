import mongoose from "mongoose";
import { studyDetailsModelName } from "../../common";

const classSchema = new mongoose.Schema({
    isStudied: { type: Boolean, default: false },
    branch: { type: String },
}, { _id: false })

const studyDetailsSchema = new mongoose.Schema({
    classes: { type: Map, of: classSchema, default: {} }
}, { timestamps: true, versionKey: false })

export const studyDetailsModel = mongoose.model(studyDetailsModelName, studyDetailsSchema);