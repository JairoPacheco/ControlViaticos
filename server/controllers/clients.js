const { poolPromise, sql } = require('../database');

exports.addClient = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('razonSocial', sql.VarChar(50), req.razonSocial)
        .input('razonComercial', sql.VarChar(50), req.razonComercial)
        .execute('addClient');
    return result;
}

exports.getClients = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getClients');
    return result;
}

exports.updateClient = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('clientId', sql.Int, req.clientId)
        .input('razonSocial', sql.VarChar(50), req.razonSocial)
        .input('razonComercial', sql.VarChar(50), req.razonComercial)
        .input('isActive', sql.Int, req.isActive)
        .execute('updateClient');
    return result;
}