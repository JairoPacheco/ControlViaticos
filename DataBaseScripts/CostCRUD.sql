USE ControlViaticos;
GO

--CRUD de centro de costo
CREATE OR ALTER PROC addCost
	@descripcion	VARCHAR(100)
AS
BEGIN
	--Ya existe un costo activo con la misma descripcion (codigo 1)
	IF EXISTS(SELECT * FROM CentroCosto WHERE (descripcion = @descripcion) 
				AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Hay un costo inactivo con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM CentroCosto WHERE (descripcion = @descripcion) 
				AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE CentroCosto SET isActive = 1 WHERE id = @idToActivate;
		--Operación exitosa
		RETURN 0;
	END

	--Se crea el costo si no se cumple ninguna de las anteriores
	INSERT INTO CentroCosto(descripcion) VALUES (@descripcion);

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getCosts
AS
BEGIN
	SELECT * FROM CentroCosto WHERE isActive = 1;

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC updateCost
	@costId			INT,
	@descripcion	VARCHAR(100) = NULL,
	@isActive		BIT	= NULL
AS
BEGIN
	--El costo a actualizar no existe (código 1)
	IF NOT EXISTS (SELECT * FROM CentroCosto WHERE id = @costId)
	BEGIN
		RETURN 1;
	END
	--Ya hay un costo con otro id que tiene esos datos (código 2)
	IF (@descripcion IS NOT NULL) 
		AND EXISTS(SELECT * FROM CentroCosto WHERE (descripcion = @descripcion) 
					AND (id != @costId))
	BEGIN
		RETURN 2;
	END

	UPDATE CentroCosto SET
		descripcion	= ISNULL(@descripcion, descripcion),
		isActive	= ISNULL(@isActive, isActive)
	WHERE id = @costId;

	--Operación exitosa
	RETURN 0;
END
GO