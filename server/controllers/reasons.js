const { poolPromise, sql } = require('../database');

exports.addReason = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .execute('addReason');
    return result;
}

exports.getReasons = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getReasons');
    return result;
}

exports.updateReason = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('reasonId', sql.Int, req.reasonId)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('isActive', sql.Int, req.isActive)
        .execute('updateReason');
    return result;
}