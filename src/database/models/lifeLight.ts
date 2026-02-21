import mongoose from "mongoose";
import { LIFE_LIGHT_TYPE, userModelName, lifeLightModelName } from "../../common";

const lifeLightSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: userModelName },
    lifeLight: { type: String },
    status: { type: String, enum: Object.values(LIFE_LIGHT_TYPE), default: LIFE_LIGHT_TYPE.PENDING },
    isDeleted: { type: Boolean, default: false },
}, { timestamps: true, versionKey: false });

export const lifeLightModel = mongoose.model(lifeLightModelName, lifeLightSchema);