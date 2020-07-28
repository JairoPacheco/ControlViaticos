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

CREATE TABLE Cliente(
	id				INT IDENTITY(1,1)	NOT NULL,
	razonSocial		VARCHAR(50)			NOT NULL, -- NCQ
	razonComercial	VARCHAR(50)			NOT NULL, -- NCQ SOLUTIONS
	isActive		BIT	DEFAULT 1		NOT NULL,
	CONSTRAINT PK_Cliente PRIMARY KEY (id)
);

CREATE TABLE Sucursal(
	id				INT IDENTITY(1,1)	NOT NULL, 
	sucursal		VARCHAR(50)			NOT NULL, 
	idCliente		INT					NOT NULL,
	isActive		BIT	DEFAULT 1		NOT NULL,
	CONSTRAINT PK_Sucursal PRIMARY KEY (id),
	CONSTRAINT FK_Sucursal_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(id)
);

CREATE TABLE TipoLabor(
	id			INT IDENTITY(1,1)	NOT NULL, -- 001
	descripcion	VARCHAR(100)		NOT NULL, -- Labores administrativas
	isActive	BIT	DEFAULT 1		NOT NULL,
	CONSTRAINT PK_TipoLabor PRIMARY KEY (id)
);

CREATE TABLE Labor(
	id			INT IDENTITY(1,1)	NOT NULL, -- 001
	descripcion	VARCHAR(100)		NOT NULL, -- LABOR SIN PROYECTO
	idTipoLabor	INT					NOT NULL, --FK
	isActive	BIT	DEFAULT 1		NOT NULL,
	CONSTRAINT PK_Labor PRIMARY KEY (id),
	CONSTRAINT FK_Labor_TipoLabor FOREIGN KEY (idTipoLabor) REFERENCES TipoLabor(id)
);

CREATE TABLE Motivo(
	id			INT IDENTITY(1,1)	NOT NULL,
	descripcion	VARCHAR(100)		NOT NULL,
	isActive	BIT	DEFAULT 1		NOT NULL,
	CONSTRAINT PK_Motivo PRIMARY KEY (id)
);

CREATE TABLE TipoSoporte(
	id			INT IDENTITY(1,1)	NOT NULL, 
	descripcion VARCHAR(100)		NOT NULL,
	isActive	BIT	DEFAULT 1		NOT NULL,
	CONSTRAINT PK_TipoSoporte PRIMARY KEY (id)
);

CREATE TABLE CentroCosto(
	id			INT IDENTITY(1,1)	NOT NULL,
	descripcion	VARCHAR(100)		NOT NULL,
	isActive	BIT	DEFAULT 1		NOT NULL,
	CONSTRAINT PK_CentroCosto PRIMARY KEY (id)
);

CREATE TABLE Recurso(
	id			INT IDENTITY(1,1)	NOT NULL, 
	responsable	VARCHAR(50)			NOT NULL, --USERNAME
	descripcion	VARCHAR(100)		NOT NULL, --NOMBRE
	isActive	BIT	DEFAULT 1		NOT NULL,
	CONSTRAINT PK_Recurso PRIMARY KEY (id)
);

CREATE TABLE Evento(
	id					INT IDENTITY(1,1)	NOT NULL,
	fecha				TFecha				NOT NULL,
	hora				TIME				NOT NULL,
	trabajo				VARCHAR(512)		NOT NULL, -- TRABAJO REALIZADO
	duracion			TIME				NOT NULL,
	problemaReportado	VARCHAR(512)		NOT NULL,
	problemaResuelto	BIT					NOT NULL,
	idSucursal			INT					NOT NULL, --FK
	idCentroCosto		INT					NOT NULL, --FK
	idLabor				INT					NOT NULL, --FK
	idTipoSoporte		INT					NOT NULL, --FK
	idMotivo			INT					NOT NULL, --FK
	CONSTRAINT PK_Evento PRIMARY KEY (id),
	CONSTRAINT FK_Evento_Sucursal FOREIGN KEY (idSucursal) REFERENCES Sucursal(id),
	CONSTRAINT FK_Evento_CentroCosto FOREIGN KEY (idCentroCosto) REFERENCES CentroCosto(id),
	CONSTRAINT FK_Evento_Labor FOREIGN KEY (idLabor) REFERENCES Labor(id),
	CONSTRAINT FK_Evento_TipoSoporte FOREIGN KEY (idTipoSoporte) REFERENCES TipoSoporte(id),
	CONSTRAINT FK_Evento_Motivo FOREIGN KEY (idMotivo) REFERENCES Motivo(id),
);

CREATE TABLE TipoViatico(
	id			INT IDENTITY(1,1)	NOT NULL, 
	descripcion VARCHAR(100)		NOT NULL,
	isActive	BIT	DEFAULT 1		NOT NULL,
	CONSTRAINT PK_TipoViatico PRIMARY KEY (id)
);

CREATE TABLE Proveedor(
	id			INT IDENTITY(1,1)	NOT NULL, 
	descripcion	VARCHAR(100)		NOT NULL,
	isActive	BIT	DEFAULT 1		NOT NULL,
	CONSTRAINT PK_Proveedor PRIMARY KEY (id)
);

CREATE TABLE Vehiculo(
	id				INT IDENTITY(1,1)	NOT NULL, 
	descripcion		VARCHAR(100)		NOT NULL, 
	montoKm			TMonto				NOT NULL,
	idResponsable	INT					NOT NULL,
	isActive		BIT	DEFAULT 1		NOT NULL,
	CONSTRAINT PK_Vehiculo PRIMARY KEY (id),
	CONSTRAINT FK_Vehiculo_Recurso FOREIGN KEY (idResponsable) REFERENCES Recurso(id)
);

CREATE TABLE Viatico(
	id				INT IDENTITY(1,1)	NOT NULL, 
	fecha			TFecha				NOT NULL,
	factura			VARCHAR(50),
	monto			TMonto				NOT NULL, 
	numPagos		INT					NOT NULL, 
	notas			VARCHAR(512)		NOT NULL,
	boleta			TBoleta				NOT NULL, --CA-9034
	idTipoViatico	INT					NOT NULL, --FK
	idProveedor		INT,                          --FK
	idResponsable	INT					NOT NULL, --FK
	idEvento		INT					NOT NULL, --FK
	CONSTRAINT PK_Viatico PRIMARY KEY (id),
	CONSTRAINT FK_Viatico_TipoViatico FOREIGN KEY (idTipoViatico) REFERENCES TipoViatico(id),
	CONSTRAINT FK_Viatico_Proveedor FOREIGN KEY (idProveedor) REFERENCES Proveedor(id),
	CONSTRAINT FK_Viatico_Recurso FOREIGN KEY (idResponsable) REFERENCES Recurso(id),
	CONSTRAINT FK_Viatico_Evento FOREIGN KEY (idEvento) REFERENCES Evento(id) ON DELETE CASCADE
);

CREATE TABLE Gasolina(
	idViatico	INT	NOT NULL,
	idVehiculo	INT	NOT NULL,
	CONSTRAINT FK_Gasolina_Viatico FOREIGN KEY (idViatico) REFERENCES Viatico(id) ON DELETE CASCADE,
	CONSTRAINT FK_Gasolina_Vehiculo FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(id)
);

CREATE TABLE Kilometraje(
	idViatico		INT			NOT NULL,
	kmRecorridos	TKilometros	NOT NULL,
	idVehiculo		INT			NOT NULL,
	CONSTRAINT FK_Kilometraje_Viatico FOREIGN KEY (idViatico) REFERENCES Viatico(id) ON DELETE CASCADE,
	CONSTRAINT FK_Kilometraje_Vehiculo FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(id)
);