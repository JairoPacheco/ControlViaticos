USE ControlViaticos;
GO

--Temporary table to insert products
CREATE TYPE ExpenseList AS TABLE
(
	fecha			DATE			NOT NULL,
	factura			VARCHAR(50),
	monto			MONEY			NOT NULL,
	numPagos		INT				NOT NULL,
	notas			VARCHAR(512)	NOT NULL,
	boleta			CHAR(7)			NOT NULL,
	idTipoViatico	INT				NOT NULL,
	idProveedor		INT,
	idResponsable	INT				NOT NULL,
	kmRecorridos	FLOAT,
	idVehiculo		INT
);
GO
