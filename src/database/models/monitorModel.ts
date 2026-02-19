import mongoose from "mongoose";
import { batchModelName, monitorModelName, STATUS, userModelName } from "../../common";


const monitorSchema = new mongoose.Schema({
    batchId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: batchModelName,
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: userModelName,
    },
    devoteeIds: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: userModelName,
        },
    ],
    status: {
        type: String,
        enum: Object.values(STATUS),
        default: STATUS.ACTIVE,
    },
    isDeleted: {
        type: Boolean,
        default: false,
    }
}, { timestamps: true, versionKey: false });

export const monitorModel = mongoose.model(monitorModelName, monitorSchema);