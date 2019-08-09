const models = require('../../models');
const Joi = require('@hapi/joi');

const create = async (req, res, next) => {
    try {
         const schema = Joi.schema({
             
         });
    } catch (error) {
        next(error);
    }
}