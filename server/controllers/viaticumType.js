const { poolPromise, sql } = require('../database');

exports.addViaticumType = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .execute('addViaticumType');
    return result;
}

exports.getViaticumType = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getViaticumType');
    return result;
}

exports.updateViaticumType = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('ViaticumTypeId', sql.Int, req.ViaticumTypeId)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('isActive', sql.Int, req.isActive)
        .execute('updateViaticumType');
    return result;
}