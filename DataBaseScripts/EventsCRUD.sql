USE ControlViaticos;
GO

CREATE OR ALTER PROC addEvent
	@fecha				TFecha,
	@hora				TIME,
	@trabajo			VARCHAR(100),
	@duracion			TIME,
	@problemaReportado	VARCHAR(100),
	@problemaResuelto	BIT,
	@idSucursal			INT,
	@idCentroCosto		INT,
	@idLabor			INT,
	@idTipoSoporte		INT,
	@idMotivo			INT,
	@viaticos			ExpenseList READONLY
AS
BEGIN
	-- Si no existe la sucursal (código 1)
	IF NOT EXISTS(SELECT id FROM Sucursal WHERE id = @idSucursal)
		RETURN 1;

	-- Si no existe la centro de costo (código 2)
	IF NOT EXISTS(SELECT id FROM CentroCosto WHERE id = @idCentroCosto)
		RETURN 2;

	-- Si no existe la labor (código 3)
	IF NOT EXISTS(SELECT id FROM Labor WHERE id = @idLabor)
		RETURN 3;

	-- Si no existe el tipo de soporte (código 4)
	IF NOT EXISTS(SELECT id FROM TipoSoporte WHERE id = @idTipoSoporte)
		RETURN 4;

	-- Si no existe el centro de costo (código 5)
	IF NOT EXISTS(SELECT id FROM Motivo WHERE id = @idMotivo)
		RETURN 5;

	BEGIN TRANSACTION
		BEGIN TRY
			--Se guarda el id del evento creado
			DECLARE @eventIds TABLE (id INT);
			INSERT INTO Evento(fecha, hora, trabajo, duracion, problemaReportado, problemaResuelto,
								idSucursal, idCentroCosto, idLabor, idTipoSoporte, idMotivo)
			OUTPUT inserted.id INTO @eventIds
			VALUES (@fecha, @hora, @trabajo, @duracion, @problemaReportado, @problemaResuelto,
					@idSucursal, @idCentroCosto, @idLabor, @idTipoSoporte, @idMotivo);

			INSERT INTO Viatico(fecha, factura, monto, numPagos, notas, boleta, idTipoViatico, 
								idProveedor, idResponsable, idVehiculo, kmRecorridos, idEvento)
			SELECT fecha, factura, monto, numPagos, notas, boleta, idTipoViatico, 
					idProveedor, idResponsable, idVehiculo, kmRecorridos,
					(SELECT id FROM @eventIds)
			FROM @viaticos

			COMMIT;
			RETURN 0;
		END TRY

		BEGIN CATCH
			ROLLBACK TRANSACTION;

			-- No se puedo insertar rollback
			RETURN 9;
		END CATCH
END
GO

CREATE OR ALTER PROC updateEvent
	@idEvento			INT,
	@fecha				TFecha,
	@hora				TIME,
	@trabajo			VARCHAR(100),
	@duracion			TIME,
	@problemaReportado	VARCHAR(100),
	@problemaResuelto	BIT,
	@idSucursal			INT,
	@idCentroCosto		INT,
	@idLabor			INT,
	@idTipoSoporte		INT,
	@idMotivo			INT,
	@viaticos			ExpenseList READONLY
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			UPDATE Evento SET
				fecha				= ISNULL(@fecha, fecha),
				hora				= ISNULL(@hora, hora),
				trabajo				= ISNULL(@trabajo, trabajo),
				duracion			= ISNULL(@duracion, duracion),
				problemaReportado	= ISNULL(@problemaReportado, problemaReportado),
				problemaResuelto	= ISNULL(@problemaResuelto, problemaResuelto),
				idSucursal			= ISNULL(@idSucursal, idSucursal),
				idCentroCosto		= ISNULL(@idCentroCosto, idCentroCosto),
				idLabor				= ISNULL(@idLabor, idLabor),
				idTipoSoporte		= ISNULL(@idTipoSoporte, idTipoSoporte),
				idMotivo			= ISNULL(@idMotivo, idMotivo)
			WHERE id = @idEvento;

			MERGE Viatico V USING @viaticos VA
			ON V.id = VA.id
			WHEN MATCHED THEN 
				UPDATE SET
					fecha			= ISNULL(VA.fecha, V.fecha),
					factura			= VA.factura,
					monto			= ISNULL(VA.monto, V.monto),
					numPagos		= ISNULL(VA.numPagos, V.numPagos),
					notas			= ISNULL(VA.notas, V.notas),
					boleta			= ISNULL(VA.boleta, V.boleta),
					idTipoViatico	= ISNULL(VA.idTipoViatico, V.idTipoViatico),
					idProveedor		= VA.idProveedor,
					idResponsable	= ISNULL(VA.idResponsable, V.idResponsable),
					idVehiculo		= VA.idVehiculo,
					kmRecorridos	= VA.kmRecorridos
			WHEN NOT MATCHED BY TARGET THEN 
				INSERT (fecha, factura, monto, numPagos, notas, boleta, idTipoViatico, 
						idProveedor, idResponsable, idVehiculo, kmRecorridos, idEvento)
				VALUES (VA.fecha, VA.factura, VA.monto, VA.numPagos, VA.notas, VA.boleta, VA.idTipoViatico, 
						VA.idProveedor, VA.idResponsable, VA.idVehiculo, VA.kmRecorridos, @idEvento)
			WHEN NOT MATCHED BY SOURCE AND V.idEvento = @idEvento THEN
				DELETE;

			COMMIT;
			RETURN 0;
		END TRY

		BEGIN CATCH
			ROLLBACK TRANSACTION;

			-- No se puedo insertar rollback
			THROW;
		END CATCH
END
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
					idVehiculo, kmRecorridos
			FROM Viatico V
			WHERE idEvento = E.id
			FOR JSON PATH) AS viaticos
	FROM Evento E WHERE id = @eventId
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

	IF @@ROWCOUNT = 0
		RETURN 1; --El evento no existe

	RETURN 0; --Operación exitosa
END
GO

CREATE OR ALTER PROC deleteEvent
	@eventId INT
AS
BEGIN
	DELETE FROM Evento WHERE id = @eventId;

	IF @@ROWCOUNT = 0
		RETURN 1; --El evento no existe

	RETURN 0; --Operación exitosa
END
GO
