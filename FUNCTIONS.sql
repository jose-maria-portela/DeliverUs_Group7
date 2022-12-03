-- FUNCIONES

-- RECIBE UN RESTAURANTE Y UNA HORA Y DEVUELVE SI EL RESTAURANTE ESTÁ ABIERTO
DELIMITER //
CREATE OR REPLACE FUNCTION funcRestaurantsOpen(resName VARCHAR(100),consult TIME) returns VARCHAR(100)
	BEGIN 
		DECLARE c VARCHAR(100);
		DECLARE hO TIME;
		DECLARE hC TIME;
		
		SET c='CLOSED';
		SET hO=(SELECT opening FROM restaurants WHERE restaurants.name=resName);
		SET hC=(SELECT closing FROM restaurants WHERE restaurants.name=resName);
		IF(hO<=consult AND consult<=hC) THEN
			SET c='OPEN';
		END IF;
		RETURN c;
	END //
DELIMITER ;

-- HORA MEDIA EN LA QUE INICIA PEDIDOS UN REPARTIDOR
DELIMITER //
CREATE OR REPLACE FUNCTION funcAvgOrders(nombreRepartidor VARCHAR(100)) RETURNS DOUBLE 
	BEGIN 
		DECLARE avgHour DOUBLE;
		SET avgHour=(SELECT AVG(hour(orders.creationDate)) FROM orders JOIN users 
		ON(users.userId=orders.userIdD));
		RETURN avgHour;
	END //
DELIMITER ;

-- OBTENER NUMERO DE PEDIDOS DE UN RESTAURANTE HECHOS EN UN MES
DELIMITER //
CREATE OR REPLACE FUNCTION funcAmountOrdersPerMonth(url VARCHAR(100), m INT) RETURNS INT 
   BEGIN
      DECLARE ordersPerMonth INT;
      SET ordersPerMonth= (SELECT COUNT(*) FROM orders JOIN
      							restaurants ON (orders.restaurantId=restaurants.restaurantId)
                           WHERE(restaurants.url=url AND MONTH(orders.deliveryDate)=m));
      RETURN ordersPerMonth;
    END //
DELIMITER ;

/*AYUDA AL REPARTIDOR A CONOCER DIRECCIONES DE RECOGIDA Y ENTREGA DE UN DETERMINADO
PEDIDO A PARTIR DE SU ID*/
DELIMITER //
CREATE OR REPLACE FUNCTION funcDeliveryHelp(idOrder INT) RETURNS VARCHAR(200)
   BEGIN
      DECLARE addressRestaurant VARCHAR(100);
      DECLARE addressUser VARCHAR(100);

      SET addressRestaurant =(SELECT restaurants.address FROM restaurants JOIN orders
      							ON (restaurants.restaurantId=orders.restaurantId)
                           WHERE (orders.orderId=idOrder));
      SET addressUser = (SELECT users.address FROM orders JOIN users
									ON (orders.userIdC=users.userId)
                           WHERE orders.orderId=idOrder);
      RETURN CONCAT("La dirección del restaurante es: ",addressRestaurant,
      " y la del cliente es: ",addressUser, " para el pedido con id: ", idOrder);
    END//
DELIMITER ;

/*BREVE RESUMEN DE UN PEDIDO QUE DEVUELVE DURACIÓN, PRECIO, RESTAURANTE, REPARTIDOR Y CLIENTE*/
DELIMITER //
CREATE OR REPLACE FUNCTION funcSumUpDelivery(idOrder INT) RETURNS VARCHAR(200)
	BEGIN
		DECLARE cDate DATETIME;
		DECLARE dDate DATETIME;
		DECLARE resName VARCHAR(100);
		DECLARE minuteSpent INT;
		DECLARE priceOrder DOUBLE;
		DECLARE clientOrder VARCHAR(100);
		DECLARE deliverManOrder VARCHAR(100);
		
		SET clientOrder=(SELECT users.name FROM orders JOIN users ON (orders.userIdC=users.userId) WHERE orders.orderId=idOrder);
		SET deliverManOrder=(SELECT users.name FROM orders JOIN users ON (orders.userIdD=users.userId) WHERE orders.orderId=idOrder);
		SET resName=(SELECT restaurants.name FROM orders JOIN restaurants ON (orders.restaurantId=restaurants.restaurantId) WHERE orders.orderId=idOrder);
		SET priceOrder=PT(idOrder)+(SELECT shippingCosts FROM orders WHERE orderId=idOrder);
		SET cDate=(SELECT creationDate FROM orders WHERE orderId=idOrder);
		SET dDate=(SELECT deliveryDate FROM orders WHERE orderId=idOrder);
		SET minuteSpent=(TIMESTAMPDIFF(MINUTE,cDate,dDate));
		
		RETURN CONCAT('PEDIDO ',idOrder,'-> DURACIÓN=',minuteSpent,' minutos | PRECIO=',priceOrder,'€ | RESTAURANTE=',resName, 
		' | REPARTIDOR ASIGNADO=',deliverManOrder,' | CLIENTE=',clientOrder);
	END //
DELIMITER ; 

/*SELECT funcAvgOrders('Kevin Martínez Monedero');
SELECT `name`,funcRestaurantsOpen(`name`,'13:00:00') FROM restaurants;
SELECT funcAmountOrdersPerMonth('www.iguanasranas.com', 3);
SELECT funcDeliveryHelp(1);
SELECT funcSumUpDelivery(orderId) FROM orders;*/