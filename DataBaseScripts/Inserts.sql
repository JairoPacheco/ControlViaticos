USE ControlViaticos
GO

INSERT Cliente(codigo,razonSocial,razonComercial) 
VALUES ('CLI0000','NCQ','NCQ SOLUTIONS'),
	   ('CLI0001','NCQ','NCQ SOLUTIONS'),
	   ('CLI0002','NCQ','NCQ SOLUTIONS');
GO

INSERT Sucursal(sucursal,codigoCliente) 
VALUES ('Sucursal1','CLI0000'),
	   ('Sucursal2','CLI0001'),
	   ('Sucursal3','CLI0002');
GO

INSERT TipoLabor(descripcion)
VALUES ('Labores administrativas'),
	   ('Labores Sociales'),
	   ('Labores administrativas2');
GO

INSERT Labor(descripcion,idTipoLabor) 
VALUES ('LABOR SIN PROYECTO',1),
	   ('LABOR SIN PROYECTO',2),
	   ('LABOR SIN PROYECTO',3);
GO

INSERT Motivo(descripcion) 
VALUES ('Reparaciones'),
	   ('Reunion'),
	   ('Nuevo cliente');
GO

INSERT TipoViatico (descripcion)
VALUES ('Desayuno'),
	   ('Gasolina'),
	   ('Kilometraje');
GO

INSERT INTO Recurso(responsable, descripcion)
VALUES ('frsoto', 'FRANCISCO SOTO QUESADA'),
       ('jairopc', 'JAIRO PACHECO CAMPOS'),
       ('sebasrv', 'SEBASTIÁN ROJAS VARGAS');
GO

INSERT Vehiculo (descripcion, montoKm, idResponsable)
VALUES ('Toyota', 5, 1),
	   ('BMW', 10, 2),
	   ('Tesla', 10, 3);
GO

INSERT TipoSoporte(descripcion)
VALUES ('Sin contrato'),
       ('Feriado'),
       ('Contrato de soporte');
GO

INSERT CentroCosto (descripcion, codigo)
VALUES ('Administracion', '01-01-01'),
       ('Call Center', '01-02-01'),
       ('Clientes', '01-03-01');
GO

INSERT Evento (fecha, trabajo, tieneContrato, duracion, problemaReportado, problemaResuelto, idSucursal, 
                codigoCentroCosto, idLabor, idTipoSoporte, idMotivo, idResponsable)
VALUES ('2020-06-20', 'Visita a oficinas de NCQ', 0, '2:00:00', 'Visita a oficinas de NCQ', 1, 1, '01-01-01', 1, 1, 1, 1),
       ('2020-07-10', 'Visita al TEC', 0, '3:20:00', 'Visita al TEC', 1, 1, '01-01-01', 1, 1, 1, 2),
       ('2020-06-25', 'Entrega proyecto bases de datos 1', 0, '1:00:00', 'Entrega proyecto bases de datos 1', 1, 1, '01-01-01', 1, 1, 1, 3)
    --('', '', 0, '', '', , 1, 1, 1, 1, 1, 1)
GO

INSERT INTO Proveedor(descripcion)
VALUES ('Panadería Panchita'),
       ('Gasolinera Delta'),
       ('Dos Pinos');
GO


INSERT INTO Viatico(fecha, factura, monto, numPagos, notas, boleta, idTipoViatico, idProveedor, idResponsable, idEvento)
VALUES ('2020-06-20', NULL, 500, 1, 'Pago de kilometraje', 'KM-8492', 3, NULL, 1, 1),
	   ('2020-07-10', '5673554214', 10000, 1, 'Pago de gasolina', 'GA-5468', 2, 2, 2, 2),
	   ('2020-06-25', '4532134792', 5000, 1, 'Comida', 'CO-5341', 1, 1, 3, 3),
	   ('2020-06-25', '4532134793', 2000, 2, 'Más comida', 'CO-5271', 1, 1, 3, 3);
GO

INSERT INTO Kilometraje(idViatico, kmRecorridos, idVehiculo)
VALUES (1, 50, 2);
GO

INSERT INTO Gasolina(idViatico, idVehiculo)
VALUES (2, 3);
GO