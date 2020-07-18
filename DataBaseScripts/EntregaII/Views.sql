USE ControlViaticos;
GO

/** 
 * Vista de cliente con sucursal
 * Descripción:
 *	Selecciona todos los clientes y todas las sucursales asociadas a cada uno de estos
 */
CREATE VIEW ClienteSucursal
AS
	SELECT id, razonSocial, razonComercial, id, sucursal 
	FROM Cliente C 
	INNER JOIN Sucursal S 
		ON C.id = S.idCliente;
GO

SELECT * FROM ClienteSucursal;
GO

/**
 * Vista de labor con tipo de labor
 * Descripción:
 *	Selecciona todas los tipos de labor y todas las labores asociadas a cada tipo
 */
CREATE VIEW LaborTipo
AS
	SELECT
		TL.id			AS idTipo,
		TL.descripcion	AS descripcionTipo,
		L.id			AS idLabor,
		L.descripcion	AS descripcionLabor
	FROM Labor L
	INNER JOIN TipoLabor TL
		ON L.idTipoLabor = TL.id;
GO

SELECT * FROM LaborTipo;
GO

/**
 * Vista de costo total de cada evento
 * Descripción:
 *	Selecciona todos los evento y calcula el costo de cada evento de manera individual
 */
CREATE VIEW CostoEventos
AS
	SELECT
		id,
		fecha,
		trabajo,
		tieneContrato,
		duracion,
		problemaReportado,
		problemaResuelto,
		(SELECT SUM(monto * numpagos) FROM Viatico V WHERE V.idEvento = E.id) AS costoTotal
	FROM Evento E;
GO

SELECT * FROM CostoEventos;
GO