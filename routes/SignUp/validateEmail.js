const models = require('../../models');
const Joi = require('@hapi/joi');

const validateEmail = async (req, res, next) => {
    try {
        const emailSchema = Joi.object().keys({
            email: Joi.string().email({ minDomainSegments: 2 })
        }).with('email');
        const isValid = emailSchema.validate({
            email: req.body.email,
        });
        if (isValid) {
            const isUnique = await models.User.findOne({
                email: req.body.email,
            });
            if (!isUnique) {
                return res.json({
                    succcess: true
                })
            }
            return res.json({
                error: `Email already taken.`,
            })
        } 
        throw new Error(`Invalid email format.`)

    } catch (error) {
        next(error);
    }
}

module.exports = exports = validateEmail;