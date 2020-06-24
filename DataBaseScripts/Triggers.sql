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
 * Trigger que valida que no se repita la boleta de un viático
 * Descripción:
 *	Cada vez que se ingresa o actualiza un viatico verifica que la boleta de ese viatico no se encuentre
 *	repetida, en caso de estar repetida rechaza los datos y hace un rollback.
 */
CREATE TRIGGER triggerBoleta ON Viatico
AFTER INSERT, UPDATE
AS
	DECLARE @boleta TBoleta
	SELECT @boleta = boleta FROM inserted
	IF EXISTS(SELECT id FROM Viatico WHERE boleta=@boleta)
	BEGIN
		PRINT 'Ya existe un viático con esta boleta'
		ROLLBACK TRANSACTION
	END
GO

-- Datos para probar
/*INSERT INTO Viatico(fecha, factura, monto, numPagos, notas, boleta, idTipoViatico, idProveedor, idResponsable, idEvento)
VALUES ('2020-06-26', '4532134792', 5000, 1, 'Comida', 'CO-5341', 1, 1, 3, 3)*/

