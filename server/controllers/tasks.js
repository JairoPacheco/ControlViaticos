const { poolPromise, sql } = require('../database');

exports.addTask = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('idTipoLabor', sql.Int, req.idTipoLabor)
        .execute('addTask');
    return result;
}

exports.getTasks = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getTasks');
    return result;
}

exports.updateTask = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('laborId', sql.Int, req.laborId)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('idTipoLabor', sql.Int, req.idTipoLabor)
        .input('isActive', sql.Bit, req.isActive)
        .execute('updateTask');
    return result;
}