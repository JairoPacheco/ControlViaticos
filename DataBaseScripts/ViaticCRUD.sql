USE ControlViaticos;
GO

--CRUD de viatico
CREATE OR ALTER PROC addViatic
	@fecha			TFecha,
	@factura		VARCHAR(50),
	@monto			TMonto, 
	@numPagos		INT, 
	@notas			VARCHAR(512),
	@boleta			TBoleta, --CA-9034
	@idTipoViatico	INT, --FK
	@idProveedor	INT, --FK
	@idResponsable	INT, --FK
	@idEvento		INT --FK
AS
BEGIN
	--Ya existe un viatico activo con los mismos datos (codigo 1)
	IF EXISTS(SELECT * FROM Viatico WHERE (factura = @factura) 
				AND (boleta = @boleta) AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Hay un viatico inactivo con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM Viatico WHERE (factura = @factura) 
				AND (boleta = @boleta) AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE Viatico SET isActive = 1 WHERE id = @idToActivate;
		--Operación exitosa
		RETURN 0;
	END

	--Se crea el viatico si no se cumple ninguna de las anteriores
	INSERT INTO Viatico(fecha, factura, monto, numPagos, notas, boleta, idTipoViatico, idProveedor, idResponsable, 
				idEvento) VALUES (@fecha, @factura, @monto, @numPagos, @notas, @boleta, @idTipoViatico, @idProveedor, 
				@idResponsable, @idEvento);

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getViatics
AS
BEGIN
	SELECT * FROM Viatico WHERE isActive = 1;

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC updateViatic
	@viaticId		INT,
	@fecha			TFecha = NULL,
	@factura		VARCHAR(50) = NULL,
	@monto			TMonto = NULL,
	@numPagos		INT = NULL,
	@notas			VARCHAR(512) = NULL,
	@boleta			TBoleta = NULL, --CA-9034
	@idTipoViatico	INT = NULL, --FK
	@idProveedor	INT = NULL, --FK
	@idResponsable	INT = NULL, --FK
	@idEvento		INT	= NULL, --FK
	@isActive		BIT	= NULL
AS
BEGIN
	--El viatico a actualizar no existe (código 1)
	IF NOT EXISTS (SELECT * FROM Viatico WHERE id = @ViaticId)
	BEGIN
		RETURN 1;
	END
	--Ya hay otro viatico con otro id con esos datos (código 2)
	IF (@factura IS NOT NULL AND @boleta IS NOT NULL) 
		AND EXISTS(SELECT * FROM viatico WHERE (factura = @factura) 
					AND (boleta = @boleta) AND (id != @viaticId))
	BEGIN
		RETURN 2;
	END

	UPDATE viatico SET
		fecha		= ISNULL(@fecha, fecha),
		factura		= ISNULL(@factura, factura),
		monto		= ISNULL(@monto, monto),
		numPagos	= ISNULL(@numPagos, numPagos),
		notas		= ISNULL(@notas, notas),
		boleta		= ISNULL(@boleta, boleta),
		idTipoViatico = ISNULL(@idTipoViatico, idTipoViatico),
		idProveedor = ISNULL(@idProveedor, idProveedor),
		idResponsable = ISNULL(@idResponsable, idResponsable),
		@idEvento	= ISNULL(@idEvento, @idEvento),
		isActive	= ISNULL(@isActive, isActive)
	WHERE id = @viaticId;

	--Operación exitosa
	RETURN 0;
END
GO