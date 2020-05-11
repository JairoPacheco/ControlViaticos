USE ControlViaticos;
GO

--Reglas y tipos por defecto

--Patrón para el código del cliente
CREATE RULE RCodCliente AS (@Cliente like 'CLI[0-9][0-9][0-9][0-9]') -- Ex: CLI1234
GO
EXEC sp_addtype        'TCodCliente','char (7)', 'not null'
GO
EXEC sp_bindrule    'RCodCliente','TCodCliente'
GO

--Patrón para el código del centro de costo
CREATE RULE RCodCentro AS (@CentroCosto like '[0-9][0-9]-[0-9][0-9]-[0-9][0-9]') -- Ex: 01-02-03
GO
EXEC sp_addtype        'TCodCentro','char (8)', 'not null'
GO
EXEC sp_bindrule    'RCodCentro','TCodCentro'
GO

--Patrón para el número de boleta
CREATE RULE RBoleta AS (@Boleta like '[a-Z][a-Z]-[0-9][0-9][0-9][0-9]') -- Ex: CA-9034
GO
EXEC sp_addtype        'TBoleta','char (7)', 'not null'
GO
EXEC sp_bindrule    'RBoleta','TBoleta'
GO

--Valores por defecto
CREATE DEFAULT DFecha AS GETDATE();
GO
EXEC sp_addtype		'TFecha', 'Date', 'not null'
GO
EXEC sp_bindefault	'DFecha','TFecha'
GO

CREATE DEFAULT DMonto AS 0;
GO
EXEC sp_addtype		'TMonto', 'MONEY', 'not null'
GO
EXEC sp_bindefault	'DMonto','TMonto'
GO

CREATE DEFAULT DKilometros AS 0;
GO
EXEC sp_addtype		'TKilometros', 'FLOAT', 'not null'
GO
EXEC sp_bindefault	'DKilometros','TKilometros'
GO