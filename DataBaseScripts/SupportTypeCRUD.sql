USE ControlViaticos;
GO

--CRUD de tipo soporte
CREATE OR ALTER PROC addSupportType 
	@descripcion	VARCHAR(100)
AS
BEGIN
	--Ya existe un tipo soporte activo con los mismos datos (codigo 1)
	IF EXISTS(SELECT * FROM TipoSoporte WHERE (descripcion = @descripcion) 
				AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Hay un tipo soporte inactivo con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM TipoSoporte WHERE (descripcion = @descripcion) 
				AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE TipoSoporte SET isActive = 1 WHERE id = @idToActivate;
		--Operaci�n exitosa
		RETURN 0;
	END

	--Se crea el tipo soporte si no se cumple ninguna de las anteriores
	INSERT INTO TipoSoporte(descripcion) VALUES (@descripcion);

	--Operaci�n exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getSupportTypes
AS
BEGIN
	SELECT * FROM TipoSoporte WHERE isActive = 1;

	--Operaci�n exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC updateSupportType
	@id		INT,
	@descripcion	VARCHAR(100) = NULL,
	@isActive		BIT	= NULL
AS
BEGIN
	--El tipo soporte a actualizar no existe (c�digo 1)
	IF NOT EXISTS (SELECT * FROM TipoSoporte WHERE id = @id)
	BEGIN
		RETURN 1;
	END
	--Ya hay otro tipo soporte que tiene otro id con esos datos (c�digo 2)
	IF (@descripcion IS NOT NULL) 
		AND EXISTS(SELECT * FROM TipoSoporte WHERE (descripcion = @descripcion) 
					AND (id != @id))
	BEGIN
		RETURN 2;
	END

	UPDATE TipoSoporte SET
		descripcion	= ISNULL(@descripcion, descripcion),
		isActive	= ISNULL(@isActive, isActive)
	WHERE id = @id;

	--Operaci�n exitosa
	RETURN 0;
END
GO