USE ControlViaticos;
GO

/**
 * Este cursor imprime el nombre del cliente y debajo de usando otro subcursor
 * imprime todas las sucursales del cliente.
 */
PRINT 'Cursor 1'
DECLARE cursor_cliente CURSOR FOR 
SELECT codigo, razonComercial FROM Cliente
DECLARE @codigo TCodCliente
DECLARE @razonC VARCHAR(30)
OPEN cursor_cliente --Abrimos el cursor para iniciar el recorrido del mismo
FETCH NEXT FROM cursor_cliente INTO @codigo, @razonC
WHILE @@fetch_status = 0
BEGIN
	PRINT 'La razón comercial es ' + @razonC
    DECLARE cursor_sucursal CURSOR FOR
    SELECT sucursal FROM Sucursal WHERE codigoCliente = @codigo
    DECLARE @sucursal VARCHAR(20)
    OPEN cursor_sucursal
    FETCH NEXT FROM cursor_sucursal INTO @sucursal
    WHILE @@fetch_status = 0
    BEGIN
        PRINT '    La sucursal es ' + @sucursal
        FETCH NEXT FROM cursor_sucursal INTO @sucursal
    END
	PRINT'---------------------------------------------'
    CLOSE cursor_sucursal --Cierra el cursor.
    DEALLOCATE cursor_sucursal
	FETCH NEXT FROM cursor_cliente into @codigo, @razonC
END
CLOSE cursor_cliente --Cierra el cursor.
DEALLOCATE cursor_cliente --Lo libera de la memoria y lo destruye.
GO

/**
 * Este cursor se utiliza para imprimir los datos de cada uno de los
 * recursos (responsables).
 */
PRINT ''
PRINT 'Cursor 2'
-- 2. cursor que imprime el username y nombre de los recursos (responsables)
DECLARE cursor_recurso CURSOR FOR 
SELECT responsable, descripcion FROM Recurso
DECLARE @responsable VARCHAR(20)
DECLARE @descripción VARCHAR(100)
OPEN cursor_recurso --Abrimos el cursor para iniciar el recorrido del mismo
FETCH NEXT FROM cursor_recurso INTO @responsable, @descripción
WHILE @@fetch_status = 0
BEGIN
	PRINT 'Username: ' + @responsable + '    Nombre: ' + @descripción
	FETCH NEXT FROM cursor_recurso INTO @responsable, @descripción
END
CLOSE cursor_recurso --Cierra el cursor.
DEALLOCATE cursor_recurso --Lo libera de la memoria y lo destruye.
GO
