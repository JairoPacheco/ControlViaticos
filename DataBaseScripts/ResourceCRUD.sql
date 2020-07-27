USE ControlViaticos;
GO

--CRUD de recursos
CREATE OR ALTER PROC addResource
	@responsable	VARCHAR(50),
	@descripcion	VARCHAR(100)
AS
BEGIN
	--Ya existe un recurso activo con los mismos datos (codigo 1)
	IF EXISTS(SELECT * FROM Recurso WHERE (responsable = @responsable) 
				AND (descripcion = @descripcion) AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Hay un recurso inactivo con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM Recurso WHERE (responsable = @responsable) 
				AND (descripcion = @descripcion) AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE Recurso SET isActive = 1 WHERE id = @idToActivate;
		--Operación exitosa
		RETURN 0;
	END

	--Se crea el recurso si no se cumple ninguna de las anteriores
	INSERT INTO Recurso(responsable, descripcion) VALUES (@responsable, @descripcion);

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getResources
AS
BEGIN
	SELECT * FROM Recurso WHERE isActive = 1;

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC updateResource
	@resourceId		INT,
	@responsable	VARCHAR(50) = NULL,
	@descripcion	VARCHAR(100) = NULL,
	@isActive		BIT	= NULL
AS
BEGIN
	--El recurso a actualizar no existe (código 1)
	IF NOT EXISTS (SELECT * FROM Recurso WHERE id = @resourceId)
	BEGIN
		RETURN 1;
	END
	--Ya hay otro recurso que tiene otro id con esos datos (código 2)
	IF (@responsable IS NOT NULL AND @descripcion IS NOT NULL) 
		AND EXISTS(SELECT * FROM Recurso WHERE (responsable = @responsable) 
					AND (descripcion = @descripcion) AND (id != @resourceId))
	BEGIN
		RETURN 2;
	END

	UPDATE Recurso SET
		responsable	= ISNULL(@responsable, responsable),
		descripcion	= ISNULL(@descripcion, descripcion),
		isActive	= ISNULL(@isActive, isActive)
	WHERE id = @resourceId;

	--Operación exitosa
	RETURN 0;
END
GO