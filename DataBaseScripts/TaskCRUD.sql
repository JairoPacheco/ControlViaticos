USE ControlViaticos;
GO

--CRUD de labor
CREATE OR ALTER PROC addTask
	@descripcion	VARCHAR(100), 
	@idTipoLabor	INT
AS
BEGIN
	--El tipo de labor no existe (c�digo 1)
	IF NOT EXISTS(SELECT * FROM TipoLabor WHERE id = @idTipoLabor)
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Ya existe una labor con los mismos datos (c�digo 2)
	IF EXISTS(SELECT * FROM Labor WHERE (descripcion = @descripcion) 
				AND (idTipoLabor = @idTipoLabor) AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 2;
	END
	--Hay una labor con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM Labor WHERE (descripcion = @descripcion) 
				AND (idTipoLabor = @idTipoLabor) AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE Labor SET isActive = 1 WHERE id = @idToActivate;
		--Operaci�n exitosa
		RETURN 0;
	END

	--Se crea la labor si no se cumple ninguna de las anteriores
	INSERT INTO Labor(descripcion, idTipoLabor) VALUES (@descripcion, @idTipoLabor);

	--Operaci�n exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getTasks
AS
BEGIN
	SELECT 
			*,
			(SELECT descripcion FROM TipoLabor WHERE id = idTipoLabor) AS tipoLabor
	FROM Labor 
	WHERE isActive = 1;

	--Operaci�n exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC updateTask
	@laborId		INT,
	@descripcion	VARCHAR(100) = NULL, 
	@idTipoLabor	INT = NULL,
	@isActive		BIT	= NULL
AS
BEGIN
	--La labor a actualizar no existe (c�digo 1)
	IF NOT EXISTS (SELECT * FROM Labor WHERE id = @laborId)
	BEGIN
		RETURN 1;
	END
	--El tipo de labor no existe (c�digo 2)
	IF (@idTipoLabor IS NOT NULL) AND NOT EXISTS(SELECT * FROM TipoLabor WHERE id = @idTipoLabor)
	BEGIN
		--Fallo
		RETURN 2;
	END
	--Ya hay otra labor que tiene otro id con esos datos (c�digo 3)
	IF (@descripcion IS NOT NULL AND @idTipoLabor IS NOT NULL) 
		AND EXISTS(SELECT * FROM Labor WHERE (descripcion = @descripcion) 
					AND (idTipoLabor = @idTipoLabor) AND (id != @laborId))
	BEGIN
		RETURN 3;
	END

	UPDATE Labor SET
		descripcion	= ISNULL(@descripcion, descripcion),
		idTipoLabor	= ISNULL(@idTipoLabor, idTipoLabor),
		isActive	= ISNULL(@isActive, isActive)
	WHERE id = @laborId;

	--Operaci�n exitosa
	RETURN 0;
END
GO