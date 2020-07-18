const HttpStatus = require('http-status-codes');

exports.validateRequest = (fields, bodyRequest) => {
    return (req, res, next) => {
        if (fields.length != 0) {
            let request = bodyRequest ? req.body : req.query;
            for (const field of fields) {
                if (!request[field] && request[field] != 0) {
                    res.status(HttpStatus.BAD_REQUEST).send({ error: `Paremeter ${field} is required!` });
                    return;
                }
            }
        }
        next();
    }
};