const { poolPromise, sql } = require('../database');

exports.addViaticumType = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .execute('addExpenseType');
    return result;
}

exports.getViaticumType = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getExpenseType');
    return result;
}

exports.updateViaticumType = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('expenseTypeId', sql.Int, req.expenseTypeId)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('isActive', sql.Int, req.isActive)
        .execute('updateExpenseType');
    return result;
}