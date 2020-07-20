USE ControlViaticos;
GO

--CRUD de sucursal
CREATE OR ALTER PROC addBranchOffice 
	@sucursal	VARCHAR(50), 
	@idCliente	INT
AS
BEGIN
	--Ya existe un sucursal activo con los mismos datos (codigo 1)
	IF EXISTS(SELECT * FROM Sucursal WHERE (sucursal = @sucursal) 
				AND (idCliente = @idCliente) AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Hay un sucursal inactivo con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM Sucursal WHERE (sucursal = @sucursal) 
				AND (idCliente = @idCliente) AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE Sucursal SET isActive = 1 WHERE id = @idToActivate;
		--Operación exitosa
		RETURN 0;
	END

	--Se crea el sucursal si no se cumple ninguna de las anteriores
	INSERT INTO Sucursal(sucursal, idCliente) VALUES (@sucursal, @idCliente);

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getBranchOffices
AS
BEGIN
	SELECT * FROM Sucursal WHERE isActive = 1;

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC updateBranchOffice
	@id			INT,
	@sucursal	VARCHAR(50) = NULL, 
	@idCliente	INT = NULL,
	@isActive	BIT	= NULL
AS
BEGIN
	--El sucursal a actualizar no existe (código 1)
	IF NOT EXISTS (SELECT * FROM Sucursal WHERE id = @id)
	BEGIN
		RETURN 1;
	END
	--Ya hay otro sucursal con otro id con esos datos (código 2)
	IF (@sucursal IS NOT NULL AND @idCliente IS NOT NULL) 
		AND EXISTS(SELECT * FROM Sucursal WHERE (sucursal = @sucursal) 
					AND (idCliente = @idCliente) AND (id != @id))
	BEGIN
		RETURN 2;
	END

	UPDATE Sucursal SET
		sucursal		= ISNULL(@sucursal, sucursal),
		idCliente		= ISNULL(@idCliente, idCliente),
		isActive		= ISNULL(@isActive, isActive)
	WHERE id = @id;

	--Operación exitosa
	RETURN 0;
END
GO