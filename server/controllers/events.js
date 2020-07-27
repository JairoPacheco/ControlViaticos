const { poolPromise, sql } = require('../database');

exports.getTableEvents = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getTableEvents');
    return result;
}

exports.getEvent = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('eventId', sql.Int, req.eventId)
        .execute('getEvent');
    return result;
}
