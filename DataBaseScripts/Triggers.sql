USE ControlViaticos;
GO

/**
 * Trigger que calcula el monto del viatico para el kilometraje
 * Descripción:
 *	Cada vez que se ingresa un nuevo viatico de kilometraje este trigger toma los datos
 *	los kilometros recorridos y el costo por kilometro del vehiculo para calcular el 
 *	monto del viatico.
 */
CREATE TRIGGER triggerKilometraje ON Kilometraje
AFTER INSERT 
AS
	DECLARE @idViatico INT
	DECLARE @kmRecorridos TKilometros
	DECLARE @idVehiculo INT
	SELECT @idViatico=idViatico, @kmRecorridos=kmRecorridos, @idVehiculo=idVehiculo FROM inserted
	UPDATE Viatico SET monto= @kmRecorridos * (SELECT montoKm FROM Vehiculo WHERE id=@idVehiculo)
	WHERE id=@idViatico
GO

-- Datos para probar
/*INSERT INTO Viatico(fecha, factura, monto, numPagos, notas, boleta, idTipoViatico, idProveedor, idResponsable, idEvento)
VALUES ('2020-06-23', null, 0, 1, 'Pago de kilometraje2', 'KM-8493', 3, NULL, 2, 1)
GO
INSERT INTO Kilometraje(idViatico, kmRecorridos, idVehiculo)
VALUES (5, 30, 1);
GO
SELECT * FROM Viatico;
GO
SELECT * FROM Vehiculo;
GO*/

/**
 * Trigger que valida que la fecha que se inserta no sea mayor a la fecha actual
 * Descripción:
 *    Cada vez que se ingresa o actualiza un viatico verifica que la fecha sea mayor a la 
 *    fecha actual, en caso de que la fecha sea mayor a la fecha actual rechaza los datos y hace un rollback.
 */
CREATE TRIGGER triggerFechaViatico ON Viatico
AFTER INSERT , UPDATE
AS
    DECLARE @fecha TFecha
    SELECT @fecha = fecha FROM inserted

    IF(@fecha > GETDATE())
    BEGIN
		PRINT 'No se puede insertar una fecha superior a la actual'
		ROLLBACK TRANSACTION
    END
GO

-- Datos para probar
/*INSERT INTO Viatico(fecha, factura, monto, numPagos, notas, boleta, idTipoViatico, idProveedor, idResponsable, idEvento)
VALUES ('2020-06-24', '4532134792', 5000, 1, 'Comida', 'CO-5341', 1, 1, 3, 3)*/

/**
 * Trigger que valida que la fecha que se inserta no sea mayor a la fecha actual
 * Descripción:
 *    Cada vez que se ingresa o actualiza un Evento verifica que la fecha sea mayor a la 
 *    fecha actual, en caso de que la fecha sea mayor a la fecha actual rechaza los datos y hace un rollback.
 */
CREATE TRIGGER triggerFechaEvento ON Evento
AFTER INSERT , UPDATE
AS
    DECLARE @fecha TFecha
    SELECT @fecha = fecha FROM inserted

    IF(@fecha > GETDATE())
    BEGIN
		PRINT 'No se puede insertar una fecha superior a la actual'
		ROLLBACK TRANSACTION
    END
GO

---- Datos para probar
/*INSERT Evento (fecha, trabajo, tieneContrato, duracion, problemaReportado, problemaResuelto, idSucursal, 
                idCentroCosto, idLabor, idTipoSoporte, idMotivo, idResponsable)
VALUES ('2005-06-20', 'Visita a oficinas de NCQ', 0, '2:00:00', 'Visita a oficinas de NCQ', 1, 1, 1, 1, 1, 1, 1)*/