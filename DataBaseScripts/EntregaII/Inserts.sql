USE ControlViaticos
GO

INSERT Cliente(razonSocial, razonComercial) 
VALUES ('NCQ', 'NCQ SOLUTIONS'),
	   ('Avantica', 'Avantica Software Development'),
	   ('Go-Labs', 'Go-Labs Software Development');
GO

INSERT Sucursal(sucursal, idCliente) 
VALUES ('NCQ Ciudad Quesada', 1),
	   ('NCQ San Jos�', 1),
	   ('Avantica Ciudad Quesada ', 2),
	   ('Go-Labs Ciudad Quesada', 3);
GO

INSERT TipoLabor(descripcion)
VALUES ('Labores administrativas'),
	   ('Labores sociales'),
	   ('Labores de software');
GO

INSERT Labor(descripcion,idTipoLabor) 
VALUES ('Administraci�n de la empresa', 1),
	   ('Contrataci�n de empleados', 2),
	   ('Quality Assurance', 3),
	   ('Gesti�n de requerimientos', 3);
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
       ('sebasrv', 'SEBASTI�N ROJAS VARGAS');
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

INSERT CentroCosto (descripcion)
VALUES ('Administracion'),
       ('Call Center'),
       ('Clientes');
GO

INSERT Evento (fecha, trabajo, tieneContrato, duracion, problemaReportado, problemaResuelto, idSucursal, 
                idCentroCosto, idLabor, idTipoSoporte, idMotivo, idResponsable)
VALUES ('2020-06-20', 'Visita a oficinas de NCQ', 0, '2:00:00', 'Visita a oficinas de NCQ', 1, 1, 1, 1, 1, 1, 1),
       ('2020-07-10', 'Visita al TEC', 0, '3:20:00', 'Visita al TEC', 1, 1, 2, 1, 1, 1, 2),
       ('2020-06-25', 'Entrega proyecto bases de datos 1', 0, '1:00:00', 'Entrega proyecto bases de datos 1', 1, 1, 3, 1, 1, 1, 3);
GO

INSERT INTO Proveedor(descripcion)
VALUES ('Panader�a Panchita'),
       ('Gasolinera Delta'),
       ('Dos Pinos');
GO


INSERT INTO Viatico(fecha, factura, monto, numPagos, notas, boleta, idTipoViatico, idProveedor, idResponsable, idEvento)
VALUES ('2020-06-20', NULL, 500, 1, 'Pago de kilometraje', 'KM-8492', 3, NULL, 1, 1),
	   ('2020-07-10', '5673554214', 10000, 1, 'Pago de gasolina', 'GA-5468', 2, 2, 2, 2),
	   ('2020-06-25', '4532134792', 5000, 1, 'Comida', 'CO-5341', 1, 1, 3, 3),
	   ('2020-06-25', '4532134793', 2000, 2, 'M�s comida', 'CO-5271', 1, 1, 3, 3);
GO

INSERT INTO Kilometraje(idViatico, kmRecorridos, idVehiculo)
VALUES (1, 50, 2);
GO

INSERT INTO Gasolina(idViatico, idVehiculo)
VALUES (2, 3);
GO