USE ControlViaticos;
GO

-- 1. Trigger que calcula el monto del viatico para el kilometraje
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

--selects
--SELECT * FROM Viatico
--SELECT * FROM Vehiculo
INSERT INTO Viatico(fecha, factura, monto, numPagos, notas, boleta, idTipoViatico, idProveedor, idResponsable, idEvento)
VALUES ('2020-06-23', null, 0, 1, 'Pago de kilometraje2', 'KM-8493', 3, NULL, 2, 1)
GO

INSERT INTO Kilometraje(idViatico, kmRecorridos, idVehiculo)
VALUES (5, 30, 1);
GO

-- 2. Trigger que valida que no se repita la boleta de un viático
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

INSERT INTO Viatico(fecha, factura, monto, numPagos, notas, boleta, idTipoViatico, idProveedor, idResponsable, idEvento)
VALUES ('2020-06-26', '4532134792', 5000, 1, 'Comida', 'CO-5341', 1, 1, 3, 3)

