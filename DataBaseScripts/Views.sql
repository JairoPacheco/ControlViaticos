USE ControlViaticos;
GO

-- Vista de cliente con sucursal
CREATE VIEW ClienteSucursal
AS
	SELECT codigo, razonSocial, razonComercial, id, sucursal 
	FROM Cliente C 
	INNER JOIN Sucursal S 
		ON C.codigo = S.codigoCliente;
GO

SELECT * FROM ClienteSucursal;
GO

-- Vista de labor con tipo de labor
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

-- Vista de costo total de cada evento
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