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

CREATE OR ALTER PROC getEvent
	@eventId INT
AS
BEGIN
	SELECT id, fecha, hora, trabajo, duracion,
			problemaReportado, problemaResuelto, idSucursal,
			(SELECT idCliente FROM Sucursal WHERE id = idSucursal) AS idCliente,
			idCentroCosto, idLabor,
			(SELECT idTipoLabor FROM Labor WHERE id = idLabor) AS idTipoLabor,
			idTipoSoporte, idMotivo,
			(SELECT V.id, fecha, factura, monto, numPagos, notas,
					boleta,	idTipoViatico, idProveedor, V.idResponsable,
					G.idVehiculo AS idVehiculoG, kmRecorridos,
					K.idVehiculo AS idVehiculoK
			FROM Viatico V
				LEFT JOIN Gasolina G ON V.id = G.idViatico
				LEFT JOIN Kilometraje K ON V.id = K.idViatico 
			WHERE idEvento = E.id
			FOR JSON PATH) AS viaticos
	FROM Evento E WHERE id = @eventId
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

	IF @@ROWCOUNT = 0
		RETURN 1; --El evento no existe

	RETURN 0; --Operación exitosa
END
GO
