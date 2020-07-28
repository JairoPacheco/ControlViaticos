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

	-- Si no existe la centro de costo (código 5)
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

			DECLARE @fechaV TFecha, @factura VARCHAR(50), @monto MONEY, @numPagos INT, @notas VARCHAR(512),
					@boleta CHAR(7), @idTipoViatico INT, @idProveedor INT, @idResponsable INT, @kmRecorridos FLOAT,
					@idVehiculo INT;
			DECLARE cursor_viaticos CURSOR
			FOR SELECT * FROM @viaticos

			OPEN cursor_viaticos

			FETCH NEXT FROM cursor_viaticos INTO 
				@fechaV, @factura, @monto, @numPagos, @notas, @boleta,
				@idTipoViatico, @idProveedor, @idResponsable, @kmRecorridos, @idVehiculo;

			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO Viatico(fecha, factura, monto, numPagos, notas, boleta,
									idTipoViatico, idProveedor, idResponsable, idEvento)
				VALUES (@fechaV, @factura, @monto, @numPagos, @notas, @boleta, 
						@idTipoViatico, @idProveedor, @idResponsable, (SELECT id FROM @eventIds));

				--Es kilometraje
				IF @idVehiculo IS NOT NULL AND @kmRecorridos IS NOT NULL
					BEGIN
						INSERT INTO Kilometraje(idViatico, idVehiculo, kmRecorridos)
						VALUES (SCOPE_IDENTITY(), @idVehiculo, @kmRecorridos)
					END
				--Es gasolina
				ELSE IF @idVehiculo IS NOT NULL
					BEGIN
						INSERT INTO Gasolina(idViatico, idVehiculo)
						VALUES (SCOPE_IDENTITY(), @idVehiculo)
					END

				FETCH NEXT FROM cursor_viaticos INTO 
							@fechaV, @factura, @monto, @numPagos, @notas, @boleta,
							@idTipoViatico, @idProveedor, @idResponsable, @kmRecorridos, @idVehiculo;
			END

			CLOSE cursor_viaticos;
			DEALLOCATE cursor_viaticos;

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
