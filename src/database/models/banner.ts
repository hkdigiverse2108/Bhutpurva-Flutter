import mongoose from "mongoose";
import { bannerModelName } from "../../common";

const bannerSchema = new mongoose.Schema({
    image: { type: String, required: true },
    title: { type: String },
    subtitle: { type: String },
    link: { type: String },
    isActive: { type: Boolean, default: true },
    isDeleted: { type: Boolean, default: false },
}, { timestamps: true, versionKey: false });

export const bannerModel = mongoose.model(bannerModelName, bannerSchema);
