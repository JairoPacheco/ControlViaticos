USE ControlViaticos;

CREATE TABLE Cliente(
	id				INT IDENTITY(1,1)	NOT NULL,
	razonSocial		VARCHAR(50)			NOT NULL, -- NCQ
	razonComercial	VARCHAR(50)			NOT NULL  -- NCQ SOLUTIONS
);
ALTER TABLE Cliente ADD CONSTRAINT PK_Cliente PRIMARY KEY (id)

CREATE TABLE Sucursal(
	id				INT IDENTITY(1,1)	NOT NULL, 
	sucursal		VARCHAR(50)			NOT NULL, 
	idCliente		INT					NOT NULL
); 
ALTER TABLE Sucursal ADD CONSTRAINT PK_Sucursal PRIMARY KEY (id);
ALTER TABLE Sucursal ADD CONSTRAINT FK_Sucursal_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(id);

CREATE TABLE TipoLabor(
	id			INT IDENTITY(1,1)	NOT NULL, -- 001
	descripcion	VARCHAR(100)		NOT NULL  -- Labores administrativas
);
ALTER TABLE TipoLabor ADD CONSTRAINT PK_TipoLabor PRIMARY KEY (id);

CREATE TABLE Labor(
	id			INT IDENTITY(1,1)	NOT NULL, -- 001
	descripcion	VARCHAR(100)		NOT NULL, -- LABOR SIN PROYECTO
	idTipoLabor	INT					NOT NULL  --FK
);
ALTER TABLE Labor ADD CONSTRAINT PK_Labor PRIMARY KEY (id);
ALTER TABLE Labor ADD CONSTRAINT FK_Labor_TipoLabor FOREIGN KEY (idTipoLabor) REFERENCES TipoLabor(id);

CREATE TABLE Motivo(
	id			INT IDENTITY(1,1)	NOT NULL,
	descripcion	VARCHAR(100)		NOT NULL 
);
ALTER TABLE Motivo ADD CONSTRAINT PK_Motivo PRIMARY KEY (id);

CREATE TABLE TipoSoporte(
	id			INT IDENTITY(1,1)	NOT NULL, 
	descripcion VARCHAR(100)		NOT NULL
);
ALTER TABLE TipoSoporte ADD CONSTRAINT PK_TipoSoporte PRIMARY KEY (id);

CREATE TABLE CentroCosto(
	id			INT IDENTITY(1,1)	NOT NULL,
	descripcion	VARCHAR(100)		NOT NULL
);
ALTER TABLE CentroCosto ADD CONSTRAINT PK_CentroCosto PRIMARY KEY (id);

CREATE TABLE Recurso(
	id			INT IDENTITY(1,1)	NOT NULL, 
	responsable	VARCHAR(50)			NOT NULL, --USERNAME
	descripcion	VARCHAR(100)		NOT NULL  --NOMBRE
);
ALTER TABLE Recurso ADD CONSTRAINT PK_Recurso PRIMARY KEY (id);

CREATE TABLE Evento(
	id					INT IDENTITY(1,1)	NOT NULL, 
	fecha				TFecha				NOT NULL, 
	trabajo				VARCHAR(512)		NOT NULL, -- TRABAJO REALIZADO
	tieneContrato		BIT					NOT NULL, 
	duracion			TIME				NOT NULL, 
	problemaReportado	VARCHAR(512)		NOT NULL, 
	problemaResuelto	BIT					NOT NULL, 
	idSucursal			INT					NOT NULL, --FK
	idCentroCosto		INT					NOT NULL, --FK
	idLabor				INT					NOT NULL, --FK
	idTipoSoporte		INT					NOT NULL, --FK
	idMotivo			INT					NOT NULL, --FK
	idResponsable		INT					NOT NULL  --FK
);
ALTER TABLE Evento ADD CONSTRAINT PK_Evento PRIMARY KEY (id);
ALTER TABLE Evento ADD CONSTRAINT FK_Evento_Sucursal FOREIGN KEY (idSucursal) REFERENCES Sucursal(id);
ALTER TABLE Evento ADD CONSTRAINT FK_Evento_CentroCosto FOREIGN KEY (idCentroCosto) REFERENCES CentroCosto(id);
ALTER TABLE Evento ADD CONSTRAINT FK_Evento_Labor FOREIGN KEY (idLabor) REFERENCES Labor(id);
ALTER TABLE Evento ADD CONSTRAINT FK_Evento_TipoSoporte FOREIGN KEY (idTipoSoporte) REFERENCES TipoSoporte(id);
ALTER TABLE Evento ADD CONSTRAINT FK_Evento_Motivo FOREIGN KEY (idMotivo) REFERENCES Motivo(id);
ALTER TABLE Evento ADD CONSTRAINT FK_Evento_Recurso FOREIGN KEY (idResponsable) REFERENCES Recurso(id);

CREATE TABLE TipoViatico(
	id			INT IDENTITY(1,1)	NOT NULL, 
	descripcion VARCHAR(100)		NOT NULL
);
ALTER TABLE TipoViatico ADD CONSTRAINT PK_TipoViatico PRIMARY KEY (id);

CREATE TABLE Proveedor(
	id			INT IDENTITY(1,1)	NOT NULL, 
	descripcion	VARCHAR(100)		NOT NULL
);
ALTER TABLE Proveedor ADD CONSTRAINT PK_Proveedor PRIMARY KEY (id);

CREATE TABLE Vehiculo(
	id				INT IDENTITY(1,1)	NOT NULL, 
	descripcion		VARCHAR(100)		NOT NULL, 
	montoKm			TMonto				NOT NULL,
	idResponsable	INT					NOT NULL
);
ALTER TABLE Vehiculo ADD CONSTRAINT PK_Vehiculo PRIMARY KEY (id);
ALTER TABLE Vehiculo ADD CONSTRAINT FK_Vehiculo_Recurso FOREIGN KEY (idResponsable) REFERENCES Recurso(id);

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
	idEvento		INT					NOT NULL  --FK
);
ALTER TABLE Viatico ADD CONSTRAINT PK_Viatico PRIMARY KEY (id);
ALTER TABLE Viatico ADD CONSTRAINT FK_Viatico_TipoViatico FOREIGN KEY (idTipoViatico) REFERENCES TipoViatico(id);
ALTER TABLE Viatico ADD CONSTRAINT FK_Viatico_Proveedor FOREIGN KEY (idProveedor) REFERENCES Proveedor(id);
ALTER TABLE Viatico ADD CONSTRAINT FK_Viatico_Recurso FOREIGN KEY (idResponsable) REFERENCES Recurso(id);
ALTER TABLE Viatico ADD CONSTRAINT FK_Viatico_Evento FOREIGN KEY (idEvento) REFERENCES Evento(id);

CREATE TABLE Gasolina(
	idViatico	INT	NOT NULL,
	idVehiculo	INT	NOT NULL
);
ALTER TABLE Gasolina ADD CONSTRAINT PK_Gasolina PRIMARY KEY (idViatico);
ALTER TABLE Gasolina ADD CONSTRAINT FK_Gasolina_Viatico FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(id);

CREATE TABLE Kilometraje(
	idViatico		INT			NOT NULL,
	kmRecorridos	TKilometros	NOT NULL,
	idVehiculo		INT			NOT NULL
);
ALTER TABLE Kilometraje ADD CONSTRAINT PK_Kilometraje PRIMARY KEY (idViatico);
ALTER TABLE Kilometraje ADD CONSTRAINT FK_Kilometraje_Viatico FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(id);