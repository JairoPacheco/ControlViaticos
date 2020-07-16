USE ControlViaticos;
GO

-- Obtiene todas las labores del tipo 'Labores administrativas'
SELECT L.id, L.descripcion FROM Labor L INNER JOIN TipoLabor TL ON L.idTipoLabor = TL.id WHERE TL.descripcion = 'Labores administrativas';
GO

-- Obtiene todos los eventos creados a partir del 22/06/2020 ordenados por fecha
SELECT * FROM Evento WHERE fecha >= '2020/06/22' ORDER BY fecha ASC;
GO

-- Los viaticos con un costo superior a 1000
SELECT * FROM Viatico WHERE monto > 1000;
GO

-- El viatico más caro
SELECT TOP 1 * FROM Viatico ORDER BY monto DESC;
GO

-- Seleccionar los viaticos donde la boleta empiece por KM o GA
SELECT * FROM Viatico WHERE boleta LIKE 'KM%' OR boleta LIKE 'GA%';
GO