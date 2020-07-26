const { poolPromise, sql } = require('../database');

exports.addViatic = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('fecha', sql.Date, req.fecha)
        .input('factura', sql.VarChar(50), req.factura)
        .input('monto', sql.Money, req.monto)
        .input('numPagos', sql.Int, req.numPagos)
        .input('notas', sql.VarChar(512), req.notas)
        .input('boleta', sql.Char(7), req.boleta)
        .input('idTipoViatico', sql.Int, req.idTipoViatico)
        .input('idProveedor', sql.Int, req.idProveedor)
        .input('idResponsable', sql.Int, req.idResponsable)
        .input('idEvento', sql.Int, req.idEvento)
        .execute('addViatic');
    return result;
}

exports.getViatics = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getViatics');
    return result;
}

exports.updateViatic = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('viaticId', sql.Int, req.viaticId)
        .input('fecha', sql.Date, req.fecha)
        .input('factura', sql.VarChar(50), req.factura)
        .input('monto', sql.Money, req.monto)
        .input('numPagos', sql.Int, req.numPagos)
        .input('notas', sql.VarChar(512), req.notas)
        .input('boleta', sql.Char(7), req.boleta)
        .input('idTipoViatico', sql.Int, req.idTipoViatico)
        .input('idProveedor', sql.Int, req.idProveedor)
        .input('idResponsable', sql.Int, req.idResponsable)
        .input('idEvento', sql.Int, req.idEvento)
        .input('isActive', sql.Bit, req.isActive)
        .execute('updateViatic');
    return result;
}