USE ControlViaticos;
GO

--CRUD de sucursal
CREATE OR ALTER PROC addBranchOffice 
	@sucursal	VARCHAR(50), 
	@idCliente	INT
AS
BEGIN
	--El cliente no existe (c�digo 1)
	IF NOT EXISTS(SELECT * FROM Cliente WHERE id = @idCliente)
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Ya existe una sucursal activa con los mismos datos (codigo 2)
	IF EXISTS(SELECT * FROM Sucursal WHERE (sucursal = @sucursal) 
				AND (idCliente = @idCliente) AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 2;
	END
	--Hay una sucursal inactiva con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM Sucursal WHERE (sucursal = @sucursal) 
				AND (idCliente = @idCliente) AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE Sucursal SET isActive = 1 WHERE id = @idToActivate;
		--Operaci�n exitosa
		RETURN 0;
	END

	--Se crea la sucursal si no se cumple ninguna de las anteriores
	INSERT INTO Sucursal(sucursal, idCliente) VALUES (@sucursal, @idCliente);

	--Operaci�n exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getBranchOffices
AS
BEGIN
	SELECT 
			*,
			(SELECT razonSocial FROM Cliente WHERE id = idCliente) AS cliente
	FROM Sucursal
	WHERE isActive = 1;

	--Operaci�n exitosa
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
	--La sucursal a actualizar no existe (c�digo 1)
	IF NOT EXISTS (SELECT * FROM Sucursal WHERE id = @id)
	BEGIN
		RETURN 1;
	END
	--El cliente no existe (c�digo 2)
	IF (@idCliente IS NOT NULL) AND NOT EXISTS(SELECT * FROM Cliente WHERE id = @idCliente)
	BEGIN
		--Fallo
		RETURN 2;
	END
	--Ya hay otra sucursal que tiene otro id con esos datos (c�digo 3)
	IF (@sucursal IS NOT NULL AND @idCliente IS NOT NULL) 
		AND EXISTS(SELECT * FROM Sucursal WHERE (sucursal = @sucursal) 
					AND (idCliente = @idCliente) AND (id != @id))
	BEGIN
		RETURN 3;
	END

	UPDATE Sucursal SET
		sucursal	= ISNULL(@sucursal, sucursal),
		idCliente	= ISNULL(@idCliente, idCliente),
		isActive	= ISNULL(@isActive, isActive)
	WHERE id = @id;

	--Operaci�n exitosa
	RETURN 0;
END
GO