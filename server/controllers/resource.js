const { poolPromise, sql } = require('../database');

exports.addResource = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('responsable', sql.VarChar(50), req.responsable)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .execute('addResource');
    return result;
}

exports.getResouerce = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getResource');
    return result;
}

exports.updateResource = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('resourceId', sql.Int, req.resourceId)
        .input('responsable', sql.VarChar(50), req.responsable)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('isActive', sql.Int, req.isActive)
        .execute('updateResource');
    return result;
}