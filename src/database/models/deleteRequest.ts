import mongoose from "mongoose";
import { DELETE_REQUEST_STATUS, deleteRequestModelName } from "../../common";

const deleteRequestSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
    status: { type: String, enum: Object.values(DELETE_REQUEST_STATUS), default: DELETE_REQUEST_STATUS.PENDING },
}, { timestamps: true, versionKey: false });

export const deleteRequestModel = mongoose.model(deleteRequestModelName, deleteRequestSchema);
