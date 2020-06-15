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
	@idResponsable	   INT,
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

	-- Si no existe el responsable (código 6)
	IF NOT EXISTS(SELECT id FROM Motivo WHERE id = @idMotivo)
	BEGIN
		SET @status = 5;
		SELECT @status AS statusCode;
		RETURN;
	END

	INSERT INTO Evento(fecha, trabajo, tieneContrato, duracion, problemaReportado, problemaResuelto,
						idSucursal, codigoCentroCosto, idLabor, idTipoSoporte, idMotivo, idResponsable)
	VALUES (@fecha, @trabajo, @tieneContrato, @duracion, @problemaReportado, @problemaResuelto,
			@idSucursal, @codigoCentroCosto, @idLabor, @idTipoSoporte, @idMotivo, @idResponsable);

	-- Operación realizada exitosamente
	SET @status = 0;
	SELECT @status AS statusCode;
END
GO

CREATE OR ALTER PROC addViatico
    @fecha             TFecha,
    @factura           VARCHAR(50),
    @monto             TMonto,
    @numPagos          INT,
    @notas             VARCHAR(100),
    @boleta            TBoleta,
    @idTipoViatico     INT,
    @idProveedor       INT,
    @idResponsable     INT,
    @idEvento          INT,
    @status            TINYINT OUTPUT
AS
BEGIN
    -- Si no existe el tipo viatico (código 1)
    IF NOT EXISTS (SELECT id FROM TipoViatico WHERE id = @idTipoViatico)
    BEGIN
        SET @status = 1;
        SELECT @status AS statusCode;
        RETURN;
    END

	-- Si no existe el proveedor (código 2)
    IF NOT EXISTS (SELECT id FROM Proveedor WHERE id = @idProveedor)
    BEGIN
        SET @status = 2;
        SELECT @status AS statusCode;
        RETURN;
    END

	-- Si no existe el proveedor (código 3)
    IF NOT EXISTS (SELECT id FROM Recurso WHERE id = @idResponsable)
    BEGIN
        SET @status = 3;
        SELECT @status AS statusCode;
        RETURN;
    END

	-- Si no existe el evento (código 4)
    IF NOT EXISTS (SELECT id FROM Evento WHERE id = @idEvento)
    BEGIN
        SET @status = 4;
        SELECT @status AS statusCode;
        RETURN;
    END

    INSERT INTO Viatico(fecha, factura, monto, numPagos, notas, boleta, idTipoViatico, idProveedor, idResponsable, idEvento)
    VALUES (@fecha, @factura, @monto, @numPagos, @notas, @boleta, @idTipoViatico, @idProveedor, @idResponsable, @idEvento)

    SET @status = 0;
    SELECT @status AS statusCode;
    RETURN;

END
GO

CREATE OR ALTER PROC removeEvento
	@id		int,
	@status TINYINT OUTPUT
AS
BEGIN
	-- si se eliminó correctamente (codigo 0)
	IF EXISTS (SELECT id FROM Evento WHERE id=@id)
	BEGIN
		DELETE FROM Evento WHERE id=@id;
		SET @status = 0;
        SELECT @status AS statusCode;
        RETURN;
	END
	-- si no existe (codigo 1)
	SET @status = 1;
    SELECT @status AS statusCode;
END
GO

CREATE OR ALTER PROC removeViatico
	@id		int,
	@status TINYINT OUTPUT
AS
BEGIN
	-- si se eliminó correctamente (codigo 0)
	IF EXISTS (SELECT id FROM Viatico WHERE id=@id)
	BEGIN
		DELETE FROM Viatico WHERE id=@id;
		SET @status = 0;
        SELECT @status AS statusCode;
        RETURN;
	END
	-- si no existe (codigo 1)
	SET @status = 1;
    SELECT @status AS statusCode;
END
GO 
