import mongoose from "mongoose";
import { feedbackModelName, userModelName } from "../../common";

const feedbackSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: userModelName },
    feedback: { type: String },
    isDeleted: { type: Boolean, default: false },
}, { timestamps: true, versionKey: false });

export const feedbackModel = mongoose.model(feedbackModelName, feedbackSchema);