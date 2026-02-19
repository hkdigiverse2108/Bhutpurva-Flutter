import mongoose from "mongoose";
import { LEGALITY_TYPE, legalityModelName } from "../../common";

const legalitySchema = new mongoose.Schema({
    type: { type: String, enum: Object.values(LEGALITY_TYPE), default: LEGALITY_TYPE.PRIVACY_POLICY },
    content: { type: String },
}, { timestamps: true, versionKey: false });

export const legalityModel = mongoose.model(legalityModelName, legalitySchema);