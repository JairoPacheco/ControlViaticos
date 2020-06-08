USE ControlViaticos;
GO

CREATE OR ALTER PROC addEvent
	@fecha             DATETIME,
	@trabajo           VARCHAR(100),
	@tieneContrato     BIT,
	@duracion          TIME,
	@problemaReportado VARCHAR(100),
	@problemaResuelto  BIT,
	@idSucursal        INT,
	@codigoCentroCosto TCodCentro,
	@idLabor           INT,
	@idTipoSoporte     INT,
	@idMotivo          INT,
	@status            TINYINT OUTPUT
AS
BEGIN
	-- Si no existe la sucursal (código 1)
	IF NOT EXISTS(SELECT id FROM Sucursal WHERE id = @idSucursal)
	BEGIN
		SET @status = 1;
		SELECT @status AS statusCode;
		RETURN;
	END

	-- Si no existe la centro de costo (código 2)
	IF NOT EXISTS(SELECT codigo FROM CentroCosto WHERE codigo = @codigoCentroCosto)
	BEGIN
		SET @status = 2;
		SELECT @status AS statusCode;
		RETURN;
	END

	-- Si no existe la labor (código 3)
	IF NOT EXISTS(SELECT id FROM Labor WHERE id = @idLabor)
	BEGIN
		SET @status = 3;
		SELECT @status AS statusCode;
		RETURN;
	END

	-- Si no existe el tipo de soporte (código 4)
	IF NOT EXISTS(SELECT id FROM TipoSoporte WHERE id = @idTipoSoporte)
	BEGIN
		SET @status = 4;
		SELECT @status AS statusCode;
		RETURN;
	END

	-- Si no existe la centro de costo (código 5)
	IF NOT EXISTS(SELECT id FROM Motivo WHERE id = @idMotivo)
	BEGIN
		SET @status = 5;
		SELECT @status AS statusCode;
		RETURN;
	END

	INSERT INTO Evento(fecha, trabajo, tieneContrato, duracion, problemaReportado, problemaResuelto,
						idSucursal, codigoCentroCosto, idLabor, idTipoSoporte, idMotivo)
	VALUES (@fecha, @trabajo, @tieneContrato, @duracion, @problemaReportado, @problemaResuelto,
			@idSucursal, @tieneContrato, @duracion, @problemaReportado, @problemaResuelto);

	-- Operación realizada exitosamente
	SET @status = 0;
	SELECT @status AS statusCode;
END
GO