const { poolPromise, sql } = require('../database');

exports.addTaskType = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .execute('addTaskType');
    return result;
}

exports.getTaskType = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getTaskType');
    return result;
}

exports.updateTaskType = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('taskTypeId', sql.Int, req.taskTypeId)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('isActive', sql.Int, req.isActive)
        .execute('updateTaskType');
    return result;
}