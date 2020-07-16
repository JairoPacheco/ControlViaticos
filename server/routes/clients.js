const express = require('express');
const router = express.Router();
const middleware = require('../middleware/middleware');
const consts = require('../config/constants');
const HttpStatus = require('http-status-codes');
const clientsController = require('../controllers/clients');

router.post('/AddClient', middleware.validateRequest([
    "razonSocial",
    "razonComercial"
], consts.IS_BODY_REQ), function (req, res) {
    clientsController.addClient(req.body)
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

router.get('/GetClients', function (req, res) {
    clientsController.getClients(req)
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

router.put('/UpdateClient', middleware.validateRequest([
    "clientId"
], consts.IS_BODY_REQ), function (req, res) {
    clientsController.updateClient(req.body)
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