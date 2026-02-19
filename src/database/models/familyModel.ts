import mongoose from "mongoose";
import { FAMILY_RELATIONSHIP, familyModelName, userModelName } from "../../common";

const memberSchema = new mongoose.Schema({
    memberId: { type: mongoose.Schema.Types.ObjectId, ref: userModelName },
    relationship: { type: String, enum: Object.values(FAMILY_RELATIONSHIP) },
}, { _id: false });

const familySchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: userModelName },
    members: [memberSchema],
    isDeleted: { type: Boolean, default: false },
}, { timestamps: true, versionKey: false });

export const familyModel = mongoose.model(familyModelName, familySchema);