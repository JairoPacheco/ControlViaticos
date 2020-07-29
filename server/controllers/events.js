const { poolPromise, sql } = require('../database');

exports.addEvent = async (req) => {
    const expenseList = req.viaticos;
    const expenseTable = new sql.Table('ExpenseList');
    expenseTable.columns.add('id', sql.Int);
    expenseTable.columns.add('fecha', sql.VarChar);
    expenseTable.columns.add('factura', sql.VarChar(50));
    expenseTable.columns.add('monto', sql.Money);
    expenseTable.columns.add('numPagos', sql.Int);
    expenseTable.columns.add('notas', sql.VarChar(512));
    expenseTable.columns.add('boleta', sql.Char(7));
    expenseTable.columns.add('idTipoViatico', sql.Int);
    expenseTable.columns.add('idProveedor', sql.Int);
    expenseTable.columns.add('idResponsable', sql.Int);
    expenseTable.columns.add('idVehiculo', sql.Int);
    expenseTable.columns.add('kmRecorridos', sql.Float);
    if (expenseList != undefined) {
        for (i = 0; i < expenseList.length; i++) {
            let expense = expenseList[i];
            expenseTable.rows.add(null, expense.fecha, expense.factura, expense.monto,
                expense.numPagos, expense.notas, expense.boleta, expense.idTipoViatico,
                expense.idProveedor, expense.idResponsable, expense.idVehiculo,
                expense.kmRecorridos);
        }
    }

    const pool = await poolPromise;
    const result = await pool.request()
        .input('fecha', sql.Date, req.fecha)
        .input('hora', sql.VarChar(8), req.hora)
        .input('trabajo', sql.VarChar(512), req.trabajo)
        .input('duracion', sql.VarChar(8), req.duracion)
        .input('problemaReportado', sql.VarChar(512), req.problemaReportado)
        .input('problemaResuelto', sql.Bit, req.problemaResuelto)
        .input('idSucursal', sql.Int, req.idSucursal)
        .input('idCentroCosto', sql.Int, req.idCentroCosto)
        .input('idLabor', sql.Int, req.idLabor)
        .input('idTipoSoporte', sql.Int, req.idTipoSoporte)
        .input('idMotivo', sql.Int, req.idMotivo)
        .input('viaticos', expenseTable)
        .execute('addEvent');
    return result;
}

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

exports.updateEvent = async (req) => {
    const expenses = req.viaticos;
    const expenseTable = new sql.Table('ExpenseList');
    expenseTable.columns.add('id', sql.Int);
    expenseTable.columns.add('fecha', sql.VarChar);
    expenseTable.columns.add('factura', sql.VarChar(50));
    expenseTable.columns.add('monto', sql.Money);
    expenseTable.columns.add('numPagos', sql.Int);
    expenseTable.columns.add('notas', sql.VarChar(512));
    expenseTable.columns.add('boleta', sql.Char(7));
    expenseTable.columns.add('idTipoViatico', sql.Int);
    expenseTable.columns.add('idProveedor', sql.Int);
    expenseTable.columns.add('idResponsable', sql.Int);
    expenseTable.columns.add('idVehiculo', sql.Int);
    expenseTable.columns.add('kmRecorridos', sql.Float);
    if (expenses != undefined) {
        for (i = 0; i < expenses.length; i++) {
            let expense = expenses[i];
            expenseTable.rows.add(expense.id, expense.fecha, expense.factura, expense.monto,
                expense.numPagos, expense.notas, expense.boleta, expense.idTipoViatico,
                expense.idProveedor, expense.idResponsable, expense.idVehiculo,
                expense.kmRecorridos);
        }
    }

    const pool = await poolPromise;
    const result = await pool.request()
        .input('idEvento', sql.Int, req.idEvento)
        .input('fecha', sql.Date, req.fecha)
        .input('hora', sql.VarChar(8), req.hora)
        .input('trabajo', sql.VarChar(512), req.trabajo)
        .input('duracion', sql.VarChar(8), req.duracion)
        .input('problemaReportado', sql.VarChar(512), req.problemaReportado)
        .input('problemaResuelto', sql.Bit, req.problemaResuelto)
        .input('idSucursal', sql.Int, req.idSucursal)
        .input('idCentroCosto', sql.Int, req.idCentroCosto)
        .input('idLabor', sql.Int, req.idLabor)
        .input('idTipoSoporte', sql.Int, req.idTipoSoporte)
        .input('idMotivo', sql.Int, req.idMotivo)
        .input('viaticos', expenseTable)
        .execute('updateEvent');
    return result;
}

exports.deleteEvent = async (req) => {
    const pool = await poolPromise;
    const result = await pool.request()
        .input('eventId', sql.Int, req.eventId)
        .execute('deleteEvent');
    return result;
}
