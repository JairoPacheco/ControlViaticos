const express = require('express');
const router = express.Router();
const middleware = require('../middleware/middleware');
const consts = require('../config/constants');
const HttpStatus = require('http-status-codes');
const taskTypesController = require('../controllers/taskTypes');

router.post('/AddTaskType', middleware.validateRequest([
    "descripcion"
], consts.IS_BODY_REQ), function (req, res) {
    taskTypesController.addTaskType(req.body)
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

router.get('/GetTaskTypes', function (req, res) {
    taskTypesController.getTaskTypes(req)
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

router.put('/UpdateTaskType', middleware.validateRequest([
    "taskTypeId"
], consts.IS_BODY_REQ), function (req, res) {
    taskTypesController.updateTaskType(req.body)
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