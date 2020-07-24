const { poolPromise, sql } = require('../database');

exports.addVehicle = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('montoKm', sql.Money, req.montoKm)
        .input('idResponsable', sql.Int, req.idResponsable)
        .execute('addVehicle');
    return result;
}

exports.getVehicles = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getVehicles');
    return result;
}

exports.updateVehicle = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('id', sql.Int, req.id)
        .input('descripcion', sql.VarChar(100), req.descripcion)
        .input('montoKm', sql.Money, req.montoKm)
        .input('idResponsable', sql.Int, req.idResponsable)
        .input('isActive', sql.Bit, req.isActive)
        .execute('updateVehicle');
    return result;
}