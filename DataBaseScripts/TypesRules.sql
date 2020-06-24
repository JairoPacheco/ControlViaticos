CREATE DATABASE ControlViaticos;
GO

USE ControlViaticos;
GO

--Reglas y tipos por defecto

-- 1. Valor por defecto para las fechas
CREATE DEFAULT DFecha AS GETDATE();
GO
EXEC sp_addtype		'TFecha', 'Date', 'not null'
GO
EXEC sp_bindefault	'DFecha','TFecha'
GO

--2. Valor por defecto para los montos
CREATE DEFAULT DMonto AS 0;
GO

--3. Valor por defecto para los kilometros
CREATE DEFAULT DKilometros AS 0;
GO

-- 1. Regla para los montos
CREATE RULE RMonto AS (@Monto >= 0)
GO
EXEC sp_addtype		'TMonto', 'MONEY', 'not null'
GO
EXEC sp_bindrule	'RMonto','TMonto'
GO
EXEC sp_bindefault	'DMonto','TMonto'
GO

-- 2. Regla para los kilometros
CREATE RULE RKilometros AS (@Kilometros >= 0)
GO
EXEC sp_addtype		'TKilometros', 'FLOAT', 'not null'
GO
EXEC sp_bindrule	'RKilometros','TKilometros'
GO
EXEC sp_bindefault	'DKilometros','TKilometros'
GO

-- 3. Regla para el número de boleta
CREATE RULE RBoleta AS (@Boleta like '[a-Z][a-Z]-[0-9][0-9][0-9][0-9]') -- Ex: CA-9034
GO
EXEC sp_addtype		'TBoleta','char (7)', 'not null'
GO
EXEC sp_bindrule	'RBoleta','TBoleta'
GO