const { poolPromise, sql } = require('../database');

exports.getTableEvents = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .execute('getTableEvents');
    return result;
}
