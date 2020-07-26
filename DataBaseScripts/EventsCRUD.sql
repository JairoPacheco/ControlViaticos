USE ControlViaticos;
GO

CREATE OR ALTER PROC getTableEvents
AS
BEGIN
	SELECT
			id,
			fecha,
			(SELECT sucursal FROM Sucursal WHERE id = idSucursal) AS sucursal,
			(SELECT descripcion FROM Labor WHERE id = idLabor) AS labor,
			(SELECT descripcion FROM Motivo WHERE id = idMotivo) AS motivo
	FROM Evento;

	--Operación exitosa
	RETURN 0;
END
GO