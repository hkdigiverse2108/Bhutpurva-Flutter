import Joi from "joi";

export const createBannerSchema = Joi.object({
    image: Joi.string().required(),
    title: Joi.string().allow("", null),
    subtitle: Joi.string().allow("", null),
    link: Joi.string().allow("", null),
    isActive: Joi.boolean().default(true),
});

export const updateBannerSchema = Joi.object({
    id: Joi.string().required(),
    image: Joi.string().allow("", null),
    title: Joi.string().allow("", null),
    subtitle: Joi.string().allow("", null),
    link: Joi.string().allow("", null),
    isActive: Joi.boolean(),
});

export const getBannerByIdSchema = Joi.object({
    id: Joi.string().required(),
});
