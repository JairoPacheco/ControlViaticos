USE ControlViaticos;
GO

--CRUD de vehiculos
CREATE OR ALTER PROC addVehicle
	@descripcion	VARCHAR(100), 
	@montoKm		TMonto,
	@idResponsable	INT,
	@isActive		BIT,
	@status	TINYINT	= 0 OUTPUT
AS
BEGIN
	--Ya existe un vehiculo activo con los mismos datos (codigo 1)
	IF EXISTS(SELECT * FROM Vehiculo WHERE (descripcion = @descripcion) 
				AND (idResponsable = @idResponsable) AND (isActive = 1))
	BEGIN
		--Fallo
		RETURN 1;
	END
	--Hay un vehiculo inactivo con los mismos datos, se habilita
	DECLARE @idToActivate INT;
	SELECT @idToActivate = id FROM Vehiculo WHERE (descripcion = @descripcion) 
				AND (idResponsable = @idResponsable) AND (isActive = 0)
	IF @idToActivate IS NOT NULL
	BEGIN
		UPDATE Vehiculo SET isActive = 1 WHERE id = @idToActivate;
		--Operación exitosa
		RETURN 0;
	END

	--Se crea el vehiculo si no se cumple ninguna de las anteriores
	INSERT INTO Vehiculo(descripcion, montoKm, idResponsable) VALUES (@descripcion, @montoKm, @idResponsable);

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC getVehicles
AS
BEGIN
	SELECT * FROM Vehiculo WHERE isActive = 1;

	--Operación exitosa
	RETURN 0;
END
GO

CREATE OR ALTER PROC updateVehicle
	@id				INT,
	@descripcion	VARCHAR(100) = NULL, 
	@montoKm		TMonto = NULL,
	@idResponsable	INT = NULL,
	@isActive		BIT = NULL
AS
BEGIN
	--El vehiculo a actualizar no existe (código 1)
	IF NOT EXISTS (SELECT * FROM Vehiculo WHERE id = @id)
	BEGIN
		RETURN 1;
	END
	--Ya hay otro vehiculo con otro id con esos datos (código 2)
	IF (@descripcion IS NOT NULL AND @montoKm IS NOT NULL AND @idResponsable IS NOT NULL AND @isActive IS NOT NULL) 
		AND EXISTS(SELECT * FROM Vehiculo WHERE (descripcion = @descripcion) 
					AND (montoKm = @montoKm) AND (idResponsable = @idResponsable) AND (id != @id))
	BEGIN
		RETURN 2;
	END

	UPDATE Vehiculo SET
		descripcion		= ISNULL(@descripcion, descripcion),
		montoKm			= ISNULL(@montoKm, montoKm),
		idResponsable   = ISNULL(@idResponsable, idResponsable),
		isActive		= ISNULL(@isActive, isActive)
	WHERE id = @id;

	--Operación exitosa
	RETURN 0;
END
GO