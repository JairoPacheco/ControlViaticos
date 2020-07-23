USE ControlViaticos;
GO

--CRUD de tipo viatico
CREATE OR ALTER PROC addViaticumType
	@descripcion	VARCHAR(100)
AS
BEGIN
	--Ya existe un tipo de viatico activo con la misma descripcion (codigo 1)
	IF EXISTS(SELECT * FROM TipoViatico WHERE (descripcion = @descripcion) 
				AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Hay un tipo de viatico inactivo con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM TipoViatico WHERE (descripcion = @descripcion) 
				AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE TipoViatico SET isActive = 1 WHERE id = @idToActivate;
		--Operación exitosa
		RETURN 0;
	END

	--Se crea el tipo de viatico si no se cumple ninguna de las anteriores
	INSERT INTO TipoViatico(descripcion) VALUES (@descripcion);

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getViaticumType
AS
BEGIN
	SELECT * FROM TipoViatico WHERE isActive = 1;

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC updateViaticumType
	@ViaticumTypeId		INT,
	@descripcion	VARCHAR(100) = NULL,
	@isActive		BIT	= NULL
AS
BEGIN
	--El tipo de viatico a actualizar no existe (código 1)
	IF NOT EXISTS (SELECT * FROM TipoViatico WHERE id = @ViaticumTypeId)
	BEGIN
		RETURN 1;
	END
	--Ya hay otro tipo de viatico con otro id con esos datos (código 2)
	IF (@descripcion IS NOT NULL) 
		AND EXISTS(SELECT * FROM TipoViatico WHERE (descripcion = @descripcion) 
					AND (id != @ViaticumTypeId))
	BEGIN
		RETURN 2;
	END

	UPDATE TipoViatico SET
		descripcion		= ISNULL(@descripcion, descripcion),
		isActive		= ISNULL(@isActive, isActive)
	WHERE id = @ViaticumTypeId;

	--Operación exitosa
	RETURN 0;
END
GO