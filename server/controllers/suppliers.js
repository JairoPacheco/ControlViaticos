const { poolPromise, sql } = require('../database');

exports.addSupplier = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .execute('addSupplier');
    return result;
}

exports.getSuppliers = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getSuppliers');
    return result;
}

exports.updateSupplier = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('id', sql.Int, req.id)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('isActive', sql.Bit, req.isActive)
        .execute('updateSupplier');
    return result;
}