const { poolPromise, sql } = require('../database');

exports.addCost = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .execute('addCost');
    return result;
}

exports.getCosts = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getCosts');
    return result;
}

exports.updateCost = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('costId', sql.Int, req.costId)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('isActive', sql.Bit, req.isActive)
        .execute('updateCost');
    return result;
}