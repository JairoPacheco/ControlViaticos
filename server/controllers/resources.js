const { poolPromise, sql } = require('../database');

exports.addResource = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('responsable', sql.VarChar(50), req.responsable)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .execute('addResource');
    return result;
}

exports.getResources = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getResources');
    return result;
}

exports.updateResource = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('id', sql.Int, req.id)
        .input('responsable', sql.VarChar(50), req.responsable)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('isActive', sql.Bit, req.isActive)
        .execute('updateResource');
    return result;
}