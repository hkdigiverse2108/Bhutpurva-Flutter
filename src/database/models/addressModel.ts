import mongoose from "mongoose";
import { ADDRESS_TYPE, addressModelName } from "../../common";

const addressSchema: any = new mongoose.Schema({
    address: { type: String },
    type: { type: String, enum: Object.values(ADDRESS_TYPE), default: ADDRESS_TYPE.CURRENT },
    city: { type: String },
    district: { type: String },
    state: { type: String },
    country: { type: String },
    pincode: { type: String },
    isDeleted: { type: Boolean, default: false },
}, { timestamps: true, versionKey: false });

export const addressModel = mongoose.model(addressModelName, addressSchema);