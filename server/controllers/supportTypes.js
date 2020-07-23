const { poolPromise, sql } = require('../database');

exports.addSupportType = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .execute('addSupportType');
    return result;
}

exports.getSupportTypes = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getSupportTypes');
    return result;
}

exports.updateSupportType = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('id', sql.Int, req.id)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('isActive', sql.Bit, req.isActive)
        .execute('updateSupportType');
    return result;
}