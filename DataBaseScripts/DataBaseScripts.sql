--CREATE DATABASE ControlViaticos;

USE ControlViaticos;

CREATE TABLE Cliente (
	codigo VARCHAR(7) NOT NULL, --CLI0000
	razonSocial VARCHAR (30) NOT NULL, -- NCQ
	razonComercial VARCHAR (30) NOT NULL) -- NCQ SOLUTIONS
ALTER TABLE Cliente ADD CONSTRAINT PK_Cliente PRIMARY KEY (codigo)

CREATE TABLE Sucursal (
	id INT IDENTITY(1,1) NOT NULL, 
	sucursal VARCHAR(20) NOT NULL, 
	codigoCliente VARCHAR(7)
); 

ALTER TABLE Sucursal ADD CONSTRAINT PK_Sucursal PRIMARY KEY (id);

ALTER TABLE Sucursal ADD CONSTRAINT FK_Sucursal_Cliente FOREIGN KEY (codigoCliente) REFERENCES Cliente(codigo);

CREATE TABLE TipoLabor (
	codigo INT IDENTITY(1,1) NOT NULL,  --001
	descripcion VARCHAR(100) NOT NULL); -- Labores administrativas
ALTER TABLE TipoLabor ADD CONSTRAINT PK_TipoLabor PRIMARY KEY (codigo)

CREATE TABLE Labor (
	codigo INT IDENTITY(1,1) NOT NULL, -- 001
	descripción VARCHAR(100) NOT NULL, -- LABOR SIN PROYECTO
	codigoTipoLabor INT NOT NULL) --FK
ALTER TABLE Labor ADD CONSTRAINT PK_Labor PRIMARY KEY (codigo)
ALTER TABLE Labor ADD CONSTRAINT FK_Labor_TipoLabor FOREIGN KEY (codigoTipoLabor) REFERENCES TipoLabor(codigo)

CREATE TABLE Motivo (
	descripcion VARCHAR (100) NOT NULL, 
	tipoEvento INT IDENTITY(1,1) NOT NULL)
ALTER TABLE Motivo ADD CONSTRAINT PK_Motivo PRIMARY KEY (tipoEvento)

CREATE TABLE TipoSoporte (
	codigo INT IDENTITY(1,1) NOT NULL, 
	descripción VARCHAR (100) NOT NULL)
ALTER TABLE TipoSoporte ADD CONSTRAINT PK_TipoSoporte PRIMARY KEY (codigo)

CREATE TABLE CentroCosto (
	codigo VARCHAR(8) NOT NULL, -- 01-01-01
	id INT IDENTITY (1,1) NOT NULL, 
	descripcion VARCHAR(100) NOT NULL)
ALTER TABLE CentroCosto ADD CONSTRAINT PK_CentroCosto PRIMARY KEY (id)

CREATE TABLE Evento (
	id INT IDENTITY(1,1) NOT NULL, 
	fecha DATETIME NOT NULL, 
	trabajo VARCHAR(100) NOT NULL, -- TRABAJO REALIZADO
	tieneContrato BIT NOT NULL, 
	duración TIME NOT NULL, 
	problemaReportado VARCHAR(100) NOT NULL, 
	ProblemaResuelto BIT NOT NULL, 
	sucursal INT NOT NULL, --FK
	codigoCentroCosto INT NOT NULL, --FK
	codigoLabor INT NOT NULL, --FK
	codigoTipoSoporte INT NOT NULL, --FK
	codigoMotivo INT NOT NULL) --FK
ALTER TABLE Evento ADD CONSTRAINT PK_Evento PRIMARY KEY (id)

ALTER TABLE Evento ADD CONSTRAINT FK_Evento_Sucursal FOREIGN KEY (sucursal) REFERENCES Sucursal(id)
ALTER TABLE Evento ADD CONSTRAINT FK_Evento_centroCosto FOREIGN KEY (codigoCentroCosto) REFERENCES CentroCosto(id)
ALTER TABLE Evento ADD CONSTRAINT FK_Evento_Labor FOREIGN KEY (codigoLabor) REFERENCES Labor(codigo)
ALTER TABLE Evento ADD CONSTRAINT FK_Evento_TipoSoporte FOREIGN KEY (codigoTipoSoporte) REFERENCES TipoSoporte(codigo)
ALTER TABLE Evento ADD CONSTRAINT FK_Evento_Motivo FOREIGN KEY (codigoMotivo) REFERENCES Motivo(tipoEvento)

CREATE TABLE TipoViatico (
	codigo INT IDENTITY(1,1) NOT NULL, 
	descripcion VARCHAR(100) NOT NULL)
ALTER TABLE TipoViatico ADD CONSTRAINT PK_TipoViatico PRIMARY KEY (codigo)

CREATE TABLE Vehiculo (
	id INT IDENTITY(1,1) NOT NULL, 
	descripcion VARCHAR(100) NOT NULL, 
	montoKm INT NOT NULL)
ALTER TABLE Vehiculo ADD CONSTRAINT PK_Vehiculo PRIMARY KEY (id)

CREATE TABLE Proveedor (
	id INT IDENTITY(1,1) NOT NULL, 
	descripcion VARCHAR(100) NOT NULL)
ALTER TABLE Proveedor ADD CONSTRAINT PK_Proveedor PRIMARY KEY (id)

CREATE TABLE Recurso (
	id INT IDENTITY(1,1) NOT NULL, 
	responsable VARCHAR(20) NOT NULL, --USERNAME
	descripción VARCHAR(100) NOT NULL) --NOMBRE
ALTER TABLE Recurso ADD CONSTRAINT PK_Recurso PRIMARY KEY (id)

CREATE TABLE Viatico (
	id INT NOT NULL, 
	fecha DATETIME NOT NULL,
	factura INT NOT NULL,
	monto FLOAT NOT NULL, 
	numPagos INT NOT NULL, 
	notas VARCHAR(100) NOT NULL,
	boleta INT NOT NULL, 
	codigoTipoViatico INT, --FK
	idProveedor INT NOT NULL, --FK
	idResponsable INT NOT NULL, --FK
	IDEvento INT NOT NULL); --FK
ALTER TABLE Viatico ADD CONSTRAINT PK_Viatico PRIMARY KEY (id);
ALTER TABLE Viatico ADD CONSTRAINT FK_Viatico_TipoViatico FOREIGN KEY (codigoTipoViatico) REFERENCES TipoViatico(codigo)
ALTER TABLE Viatico ADD CONSTRAINT FK_Viatico_Proveedor FOREIGN KEY (idProveedor) REFERENCES Proveedor(id)
ALTER TABLE Viatico ADD CONSTRAINT FK_Viatico_Recurso FOREIGN KEY (idResponsable) REFERENCES Recurso(id)
ALTER TABLE Viatico ADD CONSTRAINT FK_Viatico_Evento FOREIGN KEY (IDEvento) REFERENCES Evento(id)

CREATE TABLE Gasolina(
	idViatico INT NOT NULL,
	idVehiculo INT NOT NULL
);
ALTER TABLE Gasolina ADD CONSTRAINT PK_Gasolina PRIMARY KEY (idViatico);
ALTER TABLE Gasolina ADD CONSTRAINT FK_Gasolina_Viatico FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(id);

CREATE TABLE Kilometraje(
	idViatico INT NOT NULL,
	montoKm FLOAT NOT NULL,
	idVehiculo INT NOT NULL
);
ALTER TABLE Kilometraje ADD CONSTRAINT PK_Kilometraje PRIMARY KEY (idViatico);
ALTER TABLE Kilometraje ADD CONSTRAINT FK_Kilometraje_Viatico FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(id);