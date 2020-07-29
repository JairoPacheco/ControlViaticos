USE ControlViaticos;
GO

--Temporary table to insert or modify expenses
CREATE TYPE ExpenseList AS TABLE(
	id				INT,
	fecha			DATE,
	factura			VARCHAR(50),
	monto			MONEY,
	numPagos		INT,
	notas			VARCHAR(512),
	boleta			CHAR(7),
	idTipoViatico	INT,
	idProveedor		INT,
	idResponsable	INT,
	idVehiculo		INT,
	kmRecorridos	FLOAT
);
GO
