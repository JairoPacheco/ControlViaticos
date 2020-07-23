USE ControlViaticos;
GO

--CRUD de Tipo labor
CREATE OR ALTER PROC addTaskType
	@descripcion	VARCHAR(100),
	@status	TINYINT	= 0 OUTPUT
AS
BEGIN
	--Ya existe un tipo de labor activo con la misma descripcion (codigo 1)
	IF EXISTS(SELECT * FROM TipoLabor WHERE (descripcion = @descripcion) 
				AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Hay un tipo de labor inactivo con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM TipoLabor WHERE (descripcion = @descripcion) 
				AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE TipoLabor SET isActive = 1 WHERE id = @idToActivate;
		--Operación exitosa
		RETURN 0;
	END

	--Se crea el tipo de labor si no se cumple ninguna de las anteriores
	INSERT INTO TipoLabor(descripcion) VALUES (@descripcion);

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getTaskType
AS
BEGIN
	SELECT * FROM TipoLabor WHERE isActive = 1;

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC updateTaskType
	@taskTypeId		INT,
	@descripcion	VARCHAR(100) = NULL,
	@isActive		BIT	= NULL
AS
BEGIN
	--El tipo de labor a actualizar no existe (código 1)
	IF NOT EXISTS (SELECT * FROM TipoLabor WHERE id = @taskTypeId)
	BEGIN
		RETURN 1;
	END
	--Ya hay otro tipo de labor con otro id con esos datos (código 2)
	IF (@descripcion IS NOT NULL) 
		AND EXISTS(SELECT * FROM TipoLabor WHERE (descripcion = @descripcion) 
					AND (id != @taskTypeId))
	BEGIN
		RETURN 2;
	END

	UPDATE TipoLabor SET
		descripcion		= ISNULL(@descripcion, descripcion),
		isActive		= ISNULL(@isActive, isActive)
	WHERE id = @taskTypeId;

	--Operación exitosa
	RETURN 0;
END
GO