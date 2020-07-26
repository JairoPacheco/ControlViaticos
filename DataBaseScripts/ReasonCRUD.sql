USE ControlViaticos;
GO

--CRUD de motivo
CREATE OR ALTER PROC addReason
	@descripcion	VARCHAR(100)
AS
BEGIN
	--Ya existe un motivo activo con la misma descripcion (codigo 1)
	IF EXISTS(SELECT * FROM Motivo WHERE (descripcion = @descripcion) 
				AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Hay un motivo inactivo con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM Motivo WHERE (descripcion = @descripcion) 
				AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE Motivo SET isActive = 1 WHERE id = @idToActivate;
		--Operación exitosa
		RETURN 0;
	END

	--Se crea el motivo si no se cumple ninguna de las anteriores
	INSERT INTO Motivo(descripcion) VALUES (@descripcion);

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getReasons
AS
BEGIN
	SELECT * FROM Motivo WHERE isActive = 1;

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC updateReason
	@reasonId		INT,
	@descripcion	VARCHAR(100) = NULL,
	@isActive		BIT	= NULL
AS
BEGIN
	--El motivo a actualizar no existe (código 1)
	IF NOT EXISTS (SELECT * FROM Motivo WHERE id = @reasonId)
	BEGIN
		RETURN 1;
	END
	--Ya hay un motivo con otro id que tiene esos datos (código 2)
	IF (@descripcion IS NOT NULL) 
		AND EXISTS(SELECT * FROM Motivo WHERE (descripcion = @descripcion) 
					AND (id != @reasonId))
	BEGIN
		RETURN 2;
	END

	UPDATE Motivo SET
		descripcion	= ISNULL(@descripcion, descripcion),
		isActive	= ISNULL(@isActive, isActive)
	WHERE id = @reasonId;

	--Operación exitosa
	RETURN 0;
END
GO