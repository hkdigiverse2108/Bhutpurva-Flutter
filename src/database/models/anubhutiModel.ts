import mongoose from "mongoose";
import { anubhutiModelName, userModelName } from "../../common";

const anubhutiSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: userModelName },
    anubhuti: { type: String },
    isDeleted: { type: Boolean, default: false },
}, { timestamps: true, versionKey: false });

export const anubhutiModel = mongoose.model(anubhutiModelName, anubhutiSchema);