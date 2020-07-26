const express = require('express');
const router = express.Router();
const middleware = require('../middleware/middleware');
const consts = require('../config/constants');
const HttpStatus = require('http-status-codes');
const viaticsController = require('../controllers/viatics');

router.post('/AddViatic', middleware.validateRequest([
    "fecha",
    "factura",
    "monto",
    "numPagos",
    "notas",
    "boleta",
    "idTipoViatico",
    "idProveedor",
    "idResponsable",
    "idEvento"
], consts.IS_BODY_REQ), function (req, res) {
    viaticsController.addViatic(req.body)
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

router.get('/GetViatics', function (req, res) {
    viaticsController.getViatics(req)
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

router.put('/UpdateViatic', middleware.validateRequest([
    "viaticId"
], consts.IS_BODY_REQ), function (req, res) {
    viaticsController.updateViatic(req.body)
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