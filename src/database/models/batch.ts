import mongoose from "mongoose";
import { batchModelName, groupModelName, userModelName } from "../../common";

const batchSchema = new mongoose.Schema({
    name: { type: String },
    groupId: { type: mongoose.Schema.Types.ObjectId, ref: groupModelName },
    monitorIds: [{ type: mongoose.Schema.Types.ObjectId, ref: userModelName }],
    isDeleted: { type: Boolean, default: false },
}, { timestamps: true, versionKey: false })

export const batchModel = mongoose.model(batchModelName, batchSchema);