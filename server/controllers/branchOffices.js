const { poolPromise, sql } = require('../database');

exports.addBranchOffice = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('sucursal', sql.VarChar(50), req.sucursal)
        .input('idCliente', sql.Int, req.idCliente)
        .execute('addBranchOffice');
    return result;
}

exports.getBranchOffices = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getBranchOffices');
    return result;
}

exports.updateBranchOffice = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('id', sql.Int, req.id)
        .input('sucursal', sql.VarChar(50), req.sucursal)
        .input('idCliente', sql.Int, req.idCliente)
        .input('isActive', sql.Bit, req.isActive)
        .execute('updateBranchOffice');
    return result;
}