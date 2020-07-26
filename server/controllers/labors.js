const { poolPromise, sql } = require('../database');

exports.addLabor = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('idTipoLabor', sql.Int, req.idTipoLabor)
        .execute('addLabor');
    return result;
}

exports.getLabors = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getLabors');
    return result;
}

exports.updateLabor = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('laborId', sql.Int, req.laborId)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('idTipoLabor', sql.Int, req.idTipoLabor)
        .input('isActive', sql.Bit, req.isActive)
        .execute('updateLabor');
    return result;
}