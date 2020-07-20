const express = require('express');
const router = express.Router();
const middleware = require('../middleware/middleware');
const consts = require('../config/constants');
const HttpStatus = require('http-status-codes');
const clientsController = require('../controllers/resources');

router.post('/AddResource', middleware.validateRequest([
    "responsable",
    "descripcion"
], consts.IS_BODY_REQ), function (req, res) {
    clientsController.addResource(req.body)
        .then(result => {
            if (result.returnValue == 0) {
                res.status(HttpStatus.NO_CONTENT).json({});
            } else {
                res.status(HttpStatus.BAD_REQUEST).json({ statusCode: result.returnValue });
            }
        })
        .catch(err => {
            res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({ error: err.message });
        });
});

router.get('/GetResources', function (req, res) {
    clientsController.getResources(req)
        .then(result => {
            if (result.returnValue == 0) {
                res.status(HttpStatus.OK).json(result.recordset);
            } else {
                res.status(HttpStatus.BAD_REQUEST).json({ statusCode: result.returnValue });
            }
        })
        .catch(err => {
            res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({ error: err.message });
        });
});

router.put('/UpdateResource', middleware.validateRequest([
    "id"
], consts.IS_BODY_REQ), function (req, res) {
    clientsController.updateResource(req.body)
        .then(result => {
            if (result.returnValue == 0) {
                res.status(HttpStatus.NO_CONTENT).json({});
            } else {
                res.status(HttpStatus.BAD_REQUEST).json({ statusCode: result.returnValue });
            }
        })
        .catch(err => {
            res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({ error: err.message });
        });
});

module.exports = router;