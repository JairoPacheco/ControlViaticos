USE ControlViaticos;
GO

/**
 * Trigger que calcula el monto del viatico para el kilometraje
 * Descripción:
 *	Cada vez que se ingresa un nuevo viatico de kilometraje este trigger toma los datos
 *	los kilometros recorridos y el costo por kilometro del vehiculo para calcular el 
 *	monto del viatico.
 */
CREATE OR ALTER TRIGGER TriggerKilometraje ON Viatico
AFTER INSERT, UPDATE
AS
	UPDATE Viatico SET 
		monto = inserted.kmRecorridos * (SELECT montoKm FROM Vehiculo WHERE id = inserted.idVehiculo)
	FROM inserted
		INNER JOIN Viatico ON Viatico.id = inserted.id
	WHERE inserted.idTipoViatico = 3;
GO
