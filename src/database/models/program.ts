import mongoose from "mongoose";
import { batchModelName, programModelName } from "../../common";

const programSchema = new mongoose.Schema({
    name: { type: String },
    batchId: { type: mongoose.Schema.Types.ObjectId, ref: batchModelName },
    description: { type: String },
    date: { type: Date },
    isDeleted: { type: Boolean, default: false }
}, { timestamps: true, versionKey: false })

export const programModel = mongoose.model(programModelName, programSchema);