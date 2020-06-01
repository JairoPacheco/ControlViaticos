USE ControlViaticos
go

INSERT Cliente(codigo,razonSocial,razonComercial) 
VALUES ('CLI0000','NCQ','NCQ SOLUTIONS'),
	   ('CLI0001','NCQ','NCQ SOLUTIONS'),
	   ('CLI0002','NCQ','NCQ SOLUTIONS')
go

INSERT Sucursal(sucursal,codigoCliente) 
VALUES ('Sucursal1','CLI0000'),
	   ('Sucursal2','CLI0001'),
	   ('Sucursal3','CLI0002')
go

INSERT TipoLabor(descripcion) --Este se inserta primero que el Labor
VALUES ('Labores administrativas'),
	   ('Labores Sociales'),
	   ('Labores administrativas2')
go

INSERT Labor(descripcion,idTipoLabor) 
VALUES ('LABOR SIN PROYECTO',1),
	   ('LABOR SIN PROYECTO',2),
	   ('LABOR SIN PROYECTO',3)
go

INSERT Motivo(descripcion) 
VALUES ('Reparaciones'),
	   ('Reunion'),
	   ('Nuevo cliente')
go

INSERT TipoViatico (descripcion)
VALUES ('Desayuno')
GO

INSERT Vehiculo (descripcion, montoKm, idResponsable)
VALUES ('Toyota', 5, 1),
	   ('BMW',10, 2),
	   ('Tesla',10, 3),
GO

INSERT TipoSoporte(descripción)
VALUES ('Sin contrato'),
    ('Feriado'),
    ('Contrato de soporte')
GO

INSERT CentroCosto (descripcion, codigo)
VALUES ('Administracion', '01-01-01'),
    ('Call Center', '01-02-01'),
    ('Clientes', '01-03-01')
GO

INSERT Evento (fecha, trabajo, tieneContrato, duración, problemaReportado, problemaResuelto, idSucursal, 
                idCentroCosto, idLabor, idTipoSoporte, idMotivo)
VALUES ('2020-06-20', 'Visita a oficinas de NCQ', 0, '2:00:00', 'Visita a oficinas de NCQ', 1, 1, 1, 1, 1, 1),
    ('2020-07-10', 'Visita al TEC', 0, '3:20:00', 'Visita al TEC', 1, 1, 1, 1, 1, 1),
    ('2020-06-25', 'Entrega proyecto bases de datos 1', 0, '1:00:00', 'Entrega proyecto bases de datos 1', 1, 1, 1, 1, 1, 1)
    --('', '', 0, '', '', , 1, 1, 1, 1, 1, 1)
GO

INSERT INTO Proveedor(descripcion) VALUES
    ('Panadería Panchita'),
    ('Gasolinera Delta'),
    ('Dos Pinos');
GO

INSERT INTO Recurso(responsable, descripción) VALUES
    ('frsoto', 'FRANCISCO SOTO QUESADA'),
    ('jairopc', 'JAIRO PACHECO CAMPOS'),
    ('sebasrv', 'SEBASTIÁN ROJAS VARGAS');
GO

--Faltan 3 de croki