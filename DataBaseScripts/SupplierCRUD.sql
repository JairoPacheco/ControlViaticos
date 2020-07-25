USE ControlViaticos;
GO

--CRUD de proveedores
CREATE OR ALTER PROC addSupplier
	@descripcion	VARCHAR(100)
AS
BEGIN
	--Ya existe un proveedor activo con la misma descripcion (codigo 1)
	IF EXISTS(SELECT * FROM Proveedor WHERE (descripcion = @descripcion) 
				AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Hay un proveedor inactivo con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM Proveedor WHERE (descripcion = @descripcion) 
				AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE Proveedor SET isActive = 1 WHERE id = @idToActivate;
		--Operación exitosa
		RETURN 0;
	END

	--Se crea el proveedor si no se cumple ninguna de las anteriores
	INSERT INTO Proveedor(descripcion) VALUES (@descripcion);

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getSupplier
AS
BEGIN
	SELECT * FROM Proveedor WHERE isActive = 1;

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC updateSupplier
	@id		INT,
	@descripcion	VARCHAR(100) = NULL,
	@isActive		BIT	= NULL
AS
BEGIN
	--El tipo de viatico a actualizar no existe (código 1)
	IF NOT EXISTS (SELECT * FROM Proveedor WHERE id = @id)
	BEGIN
		RETURN 1;
	END
	--Ya hay un tipo de viatico con otro id que tiene esos datos (código 2)
	IF (@descripcion IS NOT NULL) 
		AND EXISTS(SELECT * FROM Proveedor WHERE (descripcion = @descripcion) 
					AND (id != @id))
	BEGIN
		RETURN 2;
	END

	UPDATE Proveedor SET
		descripcion	= ISNULL(@descripcion, descripcion),
		isActive	= ISNULL(@isActive, isActive)
	WHERE id = @id;

	--Operación exitosa
	RETURN 0;
END
GO