CREATE SCHEMA casa_de_musica;
USE casa_de_musica;

CREATE TABLE clientes (
  id_cliente int NOT NULL AUTO_INCREMENT,
  nombre varchar(45) DEFAULT NULL,
  cuit BIGINT UNIQUE,
  PRIMARY KEY (id_cliente)
);

CREATE TABLE auditoria_clientes (
	id_auditoria int NOT NULL AUTO_INCREMENT, 
    fecha DATE,
    creado_por varchar(45) NOT NULL,
    nombre varchar(45) DEFAULT NULL,
	cuit BIGINT DEFAULT NULL UNIQUE,
    PRIMARY KEY (id_auditoria)
);

-- Trigger para control de auditoría sobre qué usuario ingresó los datos de qué cliente y en qué momento se hizo.
-- El script cuenta con un Stored Procedure para ingresar un nuevo cliente y comprobar el funcionamiento del trigger.
DELIMITER $$
CREATE TRIGGER auditoria_clientes
AFTER INSERT ON clientes
FOR EACH ROW
INSERT INTO auditoria_clientes (fecha, creado_por, nombre, cuit)
VALUES (CURDATE(), USER(), NEW.nombre, NEW.cuit)$$
DELIMITER ;

-- Trigger para verificar que el cliente no tenga pedidos asociados antes de eliminarse y que a su vez, en caso de eliminarlo, el mismo también se elimine de la tabla ficha_clientes
-- Para comprobar el funcionamiento del siguiente trigger se propone ejecutar los siguientes comandos:
-- DELETE FROM clientes WHERE id_cliente = 2; se espera que este comando dispare el mensaje de error del trigger, ya que ese cliente cuenta con pedidos.
-- Por otro lado se propone ejecutar el SP para generar un nuevo cliente, comprobar la existencia del mismo en las tablas clientes y ficha_clientes para luego ejecutar DELETE del paso anterior pero con el nuevo número de ID generado. En este caso el cliente debiera de ser eliminado de las tablas clientes y ficha_clientes, dado que no cuenta con pedidos.  
DELIMITER $$
CREATE TRIGGER verificacion_eliminar_cliente
BEFORE DELETE ON clientes
FOR EACH ROW
BEGIN
    DECLARE num_pedidos INT;
    SELECT COUNT(*) INTO num_pedidos FROM pedidos WHERE id_cliente = OLD.id_cliente;
    
    IF num_pedidos = 0 THEN
        DELETE FROM ficha_clientes WHERE id_cliente = OLD.id_cliente;
    END IF;
END$$
DELIMITER ;

INSERT INTO clientes VALUES
(null, "Si, MiSol", 8524398159),
(null, "ProMúsica", 1522398755),
(null, "LaRocaSound", 1547898757),
(null, "FaMusic", 3232398445),
(null, "BlackMusic", 9552235614),
(null, "DMX", 3485967762),
(null, "Fusion", 6952398747),
(null, "BairesRocks", 3571597896),
(null, "MusicShaker", 4978631547),
(null, "TodoMúsica", 2589631472); 


CREATE TABLE proveedores (
  id_proveedores int NOT NULL AUTO_INCREMENT,
  nombre varchar(50) DEFAULT NULL,
  mail varchar(50) DEFAULT NULL,
  cuit BIGINT DEFAULT NULL UNIQUE,
  telefono BIGINT DEFAULT NULL,
  cbu BIGINT DEFAULT NULL UNIQUE,
  PRIMARY KEY (id_proveedores)
);

INSERT INTO proveedores VALUES
(null, "Fender", "uiusd@fender.com", 20330327252, 01265555, 4789856122),
(null, "Gibson", "gibsond@gibson.com", 22653279853, null, 0789447513),
(null, "Laney", "gdfgd@laney.com", 70359559752, 15678551, 0010000456),
(null, "Washburn", "khkhsdf@fasdd.com", 94325559843, 55587496, 0077537419),
(null, "Pearl", "koiiie@hkhjff.com", 94153496641, 13456789, 0796524755),
(null, "Venetian", "sdfef@venetian.com", 2552001156, null, 1404566648),
(null, "Moon", "sdfef@moon.com", 4767951356, null, 7515978965),
(null, "Parker", "sdfef@parker.com", 45698712332, null, 1239874561);

CREATE TABLE productos (
  id_producto int NOT NULL AUTO_INCREMENT,
  id_proveedor int NOT NULL,
  nombre varchar(45) DEFAULT NULL,
  descripcion varchar(100) DEFAULT NULL,
  precio decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (id_producto),
  FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedores)
);

INSERT INTO productos VALUES
(null, 1, "Stratocaster", "Guitarra Strato iojoivv lorem ljaasf", 1499575),
(null, 1, "Fender B12", "Amplificador iojoivv ddddsf sfasasdccaasdd asafqqwe", 551135),
(null, 2, "Les Paul", "Guitarra eléctrica mítica iojoivv lorem ljaasf", 2500000),
(null, 2, "Epiphone", "Guitarra eléctrica epiphone eevvferwr iojoivv lorem ljaasf", 1900000),
(null, 3, "Laney H13", "Kadjler jhkerrr lkjjff lorem sdkjjr jjilsjd", 500456),
(null, 3, "Ampli Laney", "kjhhewrr ljweio3lk ljlkjlej lkjlkwerop weeee", 789044),
(null, 3, "Laney Ec", "Ampli económico", 150000),
(null, 4, "Washburn Bresh", "Guitarra eléctrica Washburn iojoivv lorem ljaasf", 1256966),
(null, 4, "Stratocaster", "Guitarra Strato iojoivv lorem ljaasf", 1499575),
(null, 5, "Pearl Batería", "Batería 9 cuerpos iojoivv lorem ljaasf", 3000000);

CREATE TABLE ficha_clientes (
  id_ficha int NOT NULL AUTO_INCREMENT,
  id_cliente int NOT NULL UNIQUE,
  mail varchar(50) DEFAULT NULL,
  direccion varchar(50) DEFAULT NULL,
  telefono BIGINT DEFAULT NULL,
  cp int DEFAULT NULL,
  PRIMARY KEY (id_ficha), 
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

INSERT INTO ficha_clientes VALUES
(null, 1, "kjahkd@dd.com", "dasdda 125", 5491156447, 1425),
(null, 2, "sdff@ddffg.com", "wertt 777", 4566778944, 1419),
(null, 3, "bhjgjg@lll.com", "sdggs 1255", 4654787788, 1213),
(null, 4, "vghuy@pp.com", "dsffsd 1455", 8999556115, 1535),
(null, 5, "vvvhjjj@piyh.com", "hfghfh 7895", 6874596321, 1425),
(null, 6, "zdfjhg@lkjg.com", "cvbbrr 1478", 1596375326, 1313),
(null, 7, "huiuh@bjj.com", "hjkhjk 1597", 9874532145, 1756),
(null, 8, "poiuvhj@fff.com", "qwery 753", 4896575351, 1535),
(null, 9, "llkj@iiou.com", "zdff 1478", 79986145336, 1795),
(null, 10, "hjjjk@jhhh.com", "potrf 1563", 3356975346, 1756);

CREATE TABLE pedidos (
  id_pedido int NOT NULL AUTO_INCREMENT,
  id_cliente int NOT NULL,
  fecha datetime NOT NULL,
  estado varchar(30) NOT NULL,
  direccion_entrega varchar(50) NOT NULL,
  PRIMARY KEY (id_pedido),
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE auditoria_pedidos (
	id_auditoria int NOT NULL AUTO_INCREMENT, 
    fecha DATE,
    creado_por varchar(45) NOT NULL,
    id_pedido varchar(45) DEFAULT NULL,
	id_cliente varchar(45) DEFAULT NULL,
    PRIMARY KEY (id_auditoria)
);

-- Trigger para auditoría de pedidos.
-- Para comprobar el funcionamiento del siguiente trigger se propone ejecutar el siguiente comando:
-- INSERT INTO pedidos VALUES (null, 4, '2023-02-12 13:23:31', "Despachado", "hgas 157");
-- Con el comando anterior un nuevo pedido debiera de haberse incorporado a la tabla pedidos y, debido al trigger, también a la tabla de auditoría.
DELIMITER $$
CREATE TRIGGER auditoria_pedidos
AFTER INSERT ON pedidos
FOR EACH ROW
INSERT INTO auditoria_pedidos (fecha, creado_por, id_pedido, id_cliente)
VALUES (CURDATE(), USER(), NEW.id_pedido, NEW.id_cliente)$$
DELIMITER ;

-- Trigger para verificar que ningún pedido se realice sin dirección de entrega.
-- Para corroborar el funcionamiento se propone ejecutar el siguiente comando:
-- INSERT INTO pedidos VALUES (null, 4, '2023-02-12 13:23:31', "Entregado", "");
-- El mismo debiera de activar el mensaje de error del trigger.
DELIMITER $$
CREATE TRIGGER verificar_direccion_entrega
BEFORE INSERT ON pedidos
FOR EACH ROW
BEGIN
    IF NEW.direccion_entrega IS NULL OR NEW.direccion_entrega = "" THEN
        SIGNAL SQLSTATE "45000"
        SET MESSAGE_TEXT = "La dirección de entrega es requerida.";
    END IF;
END$$
DELIMITER ;

INSERT INTO pedidos VALUES
(null, 1, '2023-02-12 13:23:31', "Entregado", "Onjlkf 111"),
(null, 1, '2022-12-12 10:22:05', "Entregado", "Ljjdf 7894"),
(null, 2, '2023-10-31 16:15:16', "Despachado", "Pokdmn 333"),
(null, 2, '2023-09-21 13:23:53', "Entregado", "Innsd 448"),
(null, 2, '2023-10-27 14:03:20', "Despachado", "HGgkk 1456"),
(null, 3, '2023-04-28 11:03:46', "Devuelto", "Jkjhsd 4456"),
(null, 4, '2023-05-12 12:43:33', "Entregado", "Njdff 9512"),
(null, 4, '2022-10-10 09:03:47', "Entregado", "Onjlkf 111"),
(null, 5, '2022-12-13 14:40:02', "Entregado", "Kpoef 4744"),
(null, 5, '2022-02-12 13:45:45', "Entregado", "Ponss 15975"),
(null, 5, '2023-09-17 13:23:31', "Entregado", "Hakslr 1478"),
(null, 6, '2023-06-17 11:03:40', "Despachado", "Possf 778"),
(null, 7, '2023-07-11 09:00:43', "Entregado", "QWerr 7419"),
(null, 7, '2023-04-01 11:11:11', "Entregado", "Plser 1485"),
(null, 8, '2023-02-26 10:22:30', "Entregado", "Losd 987"),
(null, 9, '2023-10-12 12:20:00', "Despachado", "JHgsd 466"),
(null, 10, '2023-10-01 18:23:30', "Entregado", "Hsdd 379"),
(null, 10, '2023-08-16 08:49:07', "Entregado", "KJjhkjd 1111"),
(null, 10, '2023-10-25 12:24:53', "Despachado", "Jjhsfff 5641"),
(null, 10, '2023-01-20 13:23:31', "Entregado", "Kjsdd 159");

CREATE TABLE detalle_pedidos (
  id_pedido int NOT NULL,
  id_producto int NOT NULL,
  cantidad int NOT NULL,
  PRIMARY KEY (id_pedido, id_producto),
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

INSERT INTO detalle_pedidos VALUES
(1, 1, 1),
(1, 3, 1),
(1, 2, 2),
(2, 4, 2),
(2, 5, 1),
(3, 1, 1),
(3, 2, 4),
(4, 6, 1),
(5, 1, 2),
(5, 2, 1),
(5, 7, 1),
(6, 1, 10),
(8, 1, 5),
(8, 8, 10),
(9, 1, 10),
(10, 1, 10),
(10, 9, 1),
(10, 10, 1),
(11, 3, 2),
(12, 10, 3),
(12, 3, 1),
(13, 9, 1),
(13, 8, 7),
(14, 6, 1),
(14, 3, 1),
(15, 1, 1),
(16, 2, 2),
(17, 4, 10),
(18, 1, 10),
(18, 6, 1),
(19, 1, 1),
(20, 1, 10);


-- FUNCIONES
-- 1) La siguiente función calcula el monto total de un pedido determinado.
DELIMITER $$
CREATE FUNCTION MontoTotalPorPedido(id_pedido INT) RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SET total = 0;

    SELECT SUM(productos.precio * detalle_pedidos.cantidad)
    INTO total
    FROM detalle_pedidos
    JOIN productos ON detalle_pedidos.id_producto = productos.id_producto
    WHERE detalle_pedidos.id_pedido = id_pedido;

    RETURN total;
END$$
DELIMITER ;

-- 2) La siguiente función devuelve el monto total de los pedidos realizados por un cliente en un rango de tiempo determinado. 
-- Su uso se pensó para el caso de clientes con cuenta corriente, que realizan pagos donde se unifica el pago de varios pedidos de una vez.
-- La misma utiliza la función generada previamente para obtener el monto total de cada pedido. 
-- También incopora la función COALESCE de SQL para que en caso de que no hubiera pedidos en el período determinado, la función devuelva "0" y no "NULL" (por si la función se usa eventualmente en el futuro y se espera que devuelva un valor numérico).
DELIMITER $$
CREATE FUNCTION TotalDeUnCliente(id_cliente INT, fecha_inicio DATE, fecha_fin DATE) RETURNS DECIMAL(20, 2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(20, 2);

    SELECT COALESCE(SUM(MontoTotalPorPedido(id_pedido)), 0)
    INTO total
    FROM pedidos
    WHERE id_cliente = id_cliente
    AND fecha BETWEEN fecha_inicio AND fecha_fin;

    RETURN total;
END $$
DELIMITER ;


-- VISTAS
-- 1) Esta vista facilita una mirada rápida sobre la cantidad de pedidos realizada por cada cliente, el monto total de cada uno y la cantidad de productos incluídos en esos pedidos.  
CREATE VIEW ventas_por_cliente AS
	SELECT c.id_cliente, c.nombre, COUNT(p.id_pedido) AS total_pedidos, SUM(d.cantidad) AS total_productos, SUM(pt.precio * d.cantidad) AS total_ventas
	FROM clientes c
	LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
	LEFT JOIN detalle_pedidos d ON p.id_pedido = d.id_pedido
	LEFT JOIN productos pt ON d.id_producto = pt.id_producto
	GROUP BY c.id_cliente;

-- 2) La siguiente vista concentra en una sola tabla la información de cada cliente, obteniendo la información de la tabla "ficha_clientes" así como de la tabla "clientes".
CREATE VIEW vista_clientes AS
	SELECT c.id_cliente, c.nombre, c.cuit, fc.mail, fc.direccion, fc.telefono, fc.cp
	FROM clientes c
	LEFT JOIN ficha_clientes fc ON c.id_cliente = fc.id_cliente;

-- 3) La siguiente vista provee rápidamente un listado con los pedidos que aún no fueron entregados.
CREATE VIEW pedidos_pendientes AS
	SELECT p.id_pedido, p.fecha, p.estado, p.direccion_entrega, c.nombre AS nombre_cliente, c.cuit AS cuit, fc.telefono AS contacto
	FROM pedidos p
	JOIN clientes c ON p.id_cliente = c.id_cliente
    JOIN ficha_clientes fc ON p.id_cliente = fc.id_cliente
	WHERE p.estado <> 'Entregado'
	ORDER BY p.fecha;

-- 4) La siguiente vista devuelve un Top 3 de los productos más vendidos
CREATE VIEW productos_mas_vendidos AS
	SELECT p.nombre AS producto_mas_vendido, SUM(dp.cantidad) AS total_vendido, p.descripcion AS descripcion, pr.nombre AS proveedor
	FROM productos p
	JOIN detalle_pedidos dp ON p.id_producto = dp.id_producto
    JOIN proveedores pr ON p.id_proveedor = pr.id_proveedores
	GROUP BY p.id_producto
	ORDER BY total_vendido DESC
	LIMIT 3;

-- 5) La siguiente vista devuelve una lista detallada de los pedidos de todos los clientes.
CREATE VIEW pedidos_por_cliente AS
	SELECT
		p.id_pedido,
		c.nombre AS cliente,
		p.fecha,
		p.estado,
		p.direccion_entrega,
		prod.nombre AS producto_comprado,
        prod.descripcion AS descripcion_producto,
		dp.cantidad,
		(prod.precio * dp.cantidad) AS precio_pagado
	FROM
		pedidos p
	JOIN clientes c ON p.id_cliente = c.id_cliente
	JOIN detalle_pedidos dp ON p.id_pedido = dp.id_pedido
	JOIN productos prod ON dp.id_producto = prod.id_producto;


-- STORED PROCEDURES 
-- El siguiente SP permite modificar el estado de los pedidos a medida que vaya pasando por los estados: entregado, despachado, devuelto.
DELIMITER $$
CREATE PROCEDURE cambiar_estado_pedido(IN p_id_pedido INT, IN p_nuevo_estado VARCHAR(30))
BEGIN
    UPDATE pedidos
    SET estado = p_nuevo_estado
    WHERE id_pedido = p_id_pedido;
END$$
DELIMITER ;

-- El siguiente SP permite la creación de un nuevo cliente. Incorporando el mismo a la tabla clientes y generando su ficha correspondiente en la tabla ficha_clientes.
DELIMITER $$
CREATE PROCEDURE agregar_cliente(
IN sp_nombre VARCHAR(45), 
IN sp_cuit BIGINT, 
IN sp_mail VARCHAR(50), 
IN sp_direccion VARCHAR(50), 
IN sp_telefono BIGINT, 
IN sp_cp INT)
BEGIN
    DECLARE chequeo_cuit INT;
    SELECT COUNT(*) INTO chequeo_cuit FROM clientes WHERE cuit = sp_cuit;
    
    IF chequeo_cuit = 0 THEN
        INSERT INTO clientes(nombre, cuit) VALUES (sp_nombre, sp_cuit);
        SET @nuevo_id_cliente = LAST_INSERT_ID();  

        INSERT INTO ficha_clientes(id_cliente, mail, direccion, telefono, cp)
        VALUES (@nuevo_id_cliente, sp_mail, sp_direccion, sp_telefono, sp_cp);
    END IF;
END$$
DELIMITER ;


-- INFORMES

-- El gerente ejecutará la siguiente query (realizada a través de un Stored Procedure) periódicamente para conocer los clientes que más y menos pedidos han realizado en el período deseado. 
-- En la query se utilizará la vista creada anteriormente "vista_clientes", así como las tablas "pedidos", "detalle_pedidos" y "productos". El gerente simplemente asignará el rango de fechas y obtendrá la información deseada.
DELIMITER $$
CREATE PROCEDURE ranking_clientes(
    IN fecha_inicio DATE,
    IN fecha_fin DATE
)
BEGIN
    SELECT
        vc.id_cliente,
        vc.nombre AS nombre_cliente,
        vc.cuit,
        COUNT(DISTINCT p.id_pedido) AS total_pedidos,
        SUM(dp.cantidad) AS total_productos,
        SUM(pt.precio * dp.cantidad) AS total_ventas
    FROM
        vista_clientes vc
    LEFT JOIN pedidos p ON vc.id_cliente = p.id_cliente
    LEFT JOIN detalle_pedidos dp ON p.id_pedido = dp.id_pedido
    LEFT JOIN productos pt ON dp.id_producto = pt.id_producto
    WHERE
        p.fecha BETWEEN fecha_inicio AND fecha_fin
    GROUP BY
        vc.id_cliente, vc.nombre, vc.cuit;
END $$
DELIMITER ;

-- El gerente también podrá ejecutar la siguiente consulta (realizada también con un Stored Procedure) cuando quiera conocer el total de ventas de algún año agrupadas mes a mes.
-- Para dar respuesta a la query se combinan los datos de varias tablas, como "pedidos", "detalle_pedidos" y "productos" a través del uso de la sentencia JOIN
-- Luego se filtran los datos por año con el WHERE, se agrupan los mismos mes a mes con la sentencia GROUP BY y se ordenan por mes con ORDER BY.

DELIMITER $$
CREATE PROCEDURE ventas_anuales(
    IN año INT
)
BEGIN
    SELECT
        DATE_FORMAT(p.fecha, '%m-%Y') AS mes,
        SUM(pt.precio * dp.cantidad) AS total_ventas
    FROM
        pedidos p
    JOIN detalle_pedidos dp ON p.id_pedido = dp.id_pedido
    JOIN productos pt ON dp.id_producto = pt.id_producto
    WHERE
        YEAR(p.fecha) = año
    GROUP BY
        mes
    ORDER BY
        mes;
END $$
DELIMITER ;
