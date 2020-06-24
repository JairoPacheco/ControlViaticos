USE ControlViaticos;
GO

/**
 * A�ade un nuevo evento a la base de datos validando que todos los datos de este existan.
 * En caso de que alguna validaci�n falle retorna un c�digo de error.
 *
 * Parametros:
 *	@fecha				- la fecha en que se cre� el evento
 *  @trabajo			- el trabajo que se realiz� en el evento
 *	@tieneContrato		- indica si el cliente tiene contrato
 *  @duracion			- el tiempo que dur� el evento
 *	@problemaReportado	- el problema que se report� en el evento
 *	@problemaResuelto	- indica si la visita resolvi� el problema,
 *	@idSucursal			- el id de la sucursal que se visit�
 *	@codigoCentroCosto	- el c�digo del centro de costo
 *	@idLabor			- id de la labor realizada,
 *	@idTipoSoporte		- id del tipo de soporte brindado,
 *	@idMotivo			- id del motivo de la visita,
 *	@idResponsable		- id del responsable del evento,
 *	@status				- parametro de salida que indica si la operaci�n fue exitosa o devuelve un c�digo de error
 */
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
	@status            TINYINT = 0 OUTPUT
AS
BEGIN
	-- Si no existe la sucursal (c�digo 1)
	IF NOT EXISTS(SELECT id FROM Sucursal WHERE id = @idSucursal)
	BEGIN
		SET @status = 1;
		SELECT @status AS statusCode;
		RETURN;
	END

	-- Si no existe la centro de costo (c�digo 2)
	IF NOT EXISTS(SELECT codigo FROM CentroCosto WHERE codigo = @codigoCentroCosto)
	BEGIN
		SET @status = 2;
		SELECT @status AS statusCode;
		RETURN;
	END

	-- Si no existe la labor (c�digo 3)
	IF NOT EXISTS(SELECT id FROM Labor WHERE id = @idLabor)
	BEGIN
		SET @status = 3;
		SELECT @status AS statusCode;
		RETURN;
	END

	-- Si no existe el tipo de soporte (c�digo 4)
	IF NOT EXISTS(SELECT id FROM TipoSoporte WHERE id = @idTipoSoporte)
	BEGIN
		SET @status = 4;
		SELECT @status AS statusCode;
		RETURN;
	END

	-- Si no existe la centro de costo (c�digo 5)
	IF NOT EXISTS(SELECT id FROM Motivo WHERE id = @idMotivo)
	BEGIN
		SET @status = 5;
		SELECT @status AS statusCode;
		RETURN;
	END

	-- Si no existe el responsable (c�digo 6)
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

	-- Operaci�n realizada exitosamente
	SET @status = 0;
	SELECT @status AS statusCode;
END
GO
-- Ejemplo de ejecuci�n
/*EXEC addEvent '2020/06/21', 'prueba', 1, '5:00', 'prueba', 1, 1, '01-01-01', 1, 1, 1, 3;
SELECT * FROM Evento;
GO*/

/**
 * A�ade un nuevo viatico a la base de datos validando que todos los datos de este existan.
 * En caso de que alguna validaci�n falle retorna un c�digo de error.
 *
 * Parametros:
 *	@fecha				- la fecha en que se cre� el viatico
 *	@factura			- la factura del viatico (opcional)
 *	@monto				- el costo del viatico
 *	@numPagos			- las veces que se paga el viatico
 *	@notas				- apuntes sobre el viatico
 *	@boleta				- el numero de boleta del viatico
 *	@idTipoViatico		- id del tipo de viatico
 *	@idProveedor		- id del proveedor del viatico
 *	@idResponsable		- id del responsable del viatico
 *	@idEvento			- id del evento asociado al viatico
 *	@status				- parametro de salida que indica si la operaci�n fue exitosa o devuelve un c�digo de error
 */
CREATE OR ALTER PROC addViatico
    @fecha             TFecha,
    @factura           VARCHAR(50) = NULL,
    @monto             TMonto,
    @numPagos          INT,
    @notas             VARCHAR(100),
    @boleta            TBoleta,
    @idTipoViatico     INT,
    @idProveedor       INT,
    @idResponsable     INT,
    @idEvento          INT,
    @status            TINYINT = 0 OUTPUT
AS
BEGIN
    -- Si no existe el tipo viatico (c�digo 1)
    IF NOT EXISTS (SELECT id FROM TipoViatico WHERE id = @idTipoViatico)
    BEGIN
        SET @status = 1;
        SELECT @status AS statusCode;
        RETURN;
    END

	-- Si no existe el proveedor (c�digo 2)
    IF NOT EXISTS (SELECT id FROM Proveedor WHERE id = @idProveedor)
    BEGIN
        SET @status = 2;
        SELECT @status AS statusCode;
        RETURN;
    END

	-- Si no existe el proveedor (c�digo 3)
    IF NOT EXISTS (SELECT id FROM Recurso WHERE id = @idResponsable)
    BEGIN
        SET @status = 3;
        SELECT @status AS statusCode;
        RETURN;
    END

	-- Si no existe el evento (c�digo 4)
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
-- Ejemplo de ejecuci�n
/*EXEC addViatico '2020/06/21', '123', 300, 1, 'prueba', 'PR-5321', 1, 1, 1, 1;
SELECT * FROM Viatico;
GO*/

/**
 * Permite eliminar un evento de la base de datos.
 * En caso de que el evento no exista retorna un codigo de error (1)
 *
 * Parametros:
 *	@id					- el id del evento a eliminar
 *	@status				- parametro de salida que indica si la operaci�n fue exitosa o devuelve un c�digo de error
 */
CREATE OR ALTER PROC removeEvento
	@id		int,
	@status TINYINT = 0 OUTPUT
AS
BEGIN
	-- Si se elimin� correctamente (codigo 0)
	IF EXISTS (SELECT id FROM Evento WHERE id=@id)
	BEGIN
		DELETE FROM Evento WHERE id=@id;
		SET @status = 0;
        SELECT @status AS statusCode;
        RETURN;
	END
	-- Si no existe (codigo 1)
	SET @status = 1;
    SELECT @status AS statusCode;
END
GO
-- Ejemplo de ejecuci�n
/*EXEC removeEvento 4;
SELECT * FROM Evento;
GO*/

/**
 * Permite eliminar un viatico de la base de datos.
 * En caso de que el viatico no exista retorna un codigo de error (1)
 *
 * Parametros:
 *	@id					- el id del viatico a eliminar
 *	@status				- parametro de salida que indica si la operaci�n fue exitosa o devuelve un c�digo de error
 */
CREATE OR ALTER PROC removeViatico
	@id		int,
	@status TINYINT = 0 OUTPUT
AS
BEGIN
	-- Si se elimin� correctamente (codigo 0)
	IF EXISTS (SELECT id FROM Viatico WHERE id=@id)
	BEGIN
		DELETE FROM Viatico WHERE id=@id;
		SET @status = 0;
        SELECT @status AS statusCode;
        RETURN;
	END
	-- Si no existe (codigo 1)
	SET @status = 1;
    SELECT @status AS statusCode;
END
GO 
-- Ejemplo de ejecuci�n
/*EXEC removeViatico 5;
SELECT * FROM Evento;
GO*/