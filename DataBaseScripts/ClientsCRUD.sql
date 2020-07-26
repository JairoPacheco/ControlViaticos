USE ControlViaticos;
GO

--CRUD de clientes
CREATE OR ALTER PROC addClient
	@razonSocial	VARCHAR(50),
	@razonComercial	VARCHAR(50)
AS
BEGIN
	--Ya existe un cliente activo con los mismos datos (codigo 1)
	IF EXISTS(SELECT * FROM Cliente WHERE (razonSocial = @razonSocial) 
				AND (razonComercial = @razonComercial) AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Hay un cliente inactivo con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM Cliente WHERE (razonSocial = @razonSocial) 
				AND (razonComercial = @razonComercial) AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE Cliente SET isActive = 1 WHERE id = @idToActivate;
		--Operación exitosa
		RETURN 0;
	END

	--Se crea el cliente si no se cumple ninguna de las anteriores
	INSERT INTO Cliente(razonSocial, razonComercial) VALUES (@razonSocial, @razonComercial);

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getClients
AS
BEGIN
	SELECT * FROM Cliente WHERE isActive = 1;

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC updateClient
	@clientId		INT,
	@razonSocial	VARCHAR(50) = NULL,
	@razonComercial	VARCHAR(50) = NULL,
	@isActive		BIT	= NULL
AS
BEGIN
	--El cliente a actualizar no existe (código 1)
	IF NOT EXISTS (SELECT * FROM Cliente WHERE id = @clientId)
	BEGIN
		RETURN 1;
	END
	--Ya hay otro cliente con otro id con esos datos (código 2)
	IF (@razonSocial IS NOT NULL AND @razonComercial IS NOT NULL) 
		AND EXISTS(SELECT * FROM Cliente WHERE (razonSocial = @razonSocial) 
					AND (razonComercial = @razonComercial) AND (id != @clientId))
	BEGIN
		RETURN 2;
	END

	UPDATE Cliente SET
		razonSocial		= ISNULL(@razonSocial, razonSocial),
		razonComercial	= ISNULL(@razonComercial, razonComercial),
		isActive		= ISNULL(@isActive, isActive)
	WHERE id = @clientId;

	--Operación exitosa
	RETURN 0;
END
GO