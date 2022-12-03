-- DISPARADORES

-- EN UN PEDIDO YA EXITENTE SALTA ERROR SI INTENTAS METER PRODUCTOS DE OTRO RESTAURANTE
DELIMITER //
CREATE OR REPLACE TRIGGER triggerProductsSameRestaurant
	BEFORE INSERT ON orderProducts
	FOR EACH ROW
	BEGIN
		DECLARE newResId INT;
		DECLARE resId INT;
		
		SET newResId= (SELECT restaurants.restaurantId  FROM products 
		JOIN restaurants ON (products.restaurantId= restaurants.restaurantId)
		WHERE (products.productId = new.productId));
		
		SET resId= (SELECT DISTINCT(restaurants.restaurantId) FROM orders
		JOIN orderProducts ON (orders.orderId=orderProducts.orderId)
		JOIN products ON (orderProducts.productId=products.productId) 
		JOIN restaurants ON (products.restaurantId= restaurants.restaurantId)
		WHERE (orders.orderId= new.orderId));
		
		IF (newResId!=resId) THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=
			'It is not allowed to add products from another restaurant to the order.';
		END IF;
	END //
DELIMITER ;

-- DA ERROR SI SE REALIZA UN PEDIDO FUERA DE HORARIO DEL RESTAURANTE
DELIMITER //
CREATE OR REPLACE TRIGGER triggerOrderOutOfHours
	AFTER INSERT ON orderProducts
	FOR EACH ROW
	BEGIN
		DECLARE idRestaurantOrder INT;
		DECLARE hourIntroducing TIME;
		DECLARE hourOpeningRes TIME;
		DECLARE hourClosingRes TIME;
		
		SET idRestaurantOrder=(SELECT restaurantId FROM orderProducts JOIN products ON (orderProducts.productId=products.productId)
		WHERE orderProducts.orderProductId=NEW.orderProductId);
		
		SET hourIntroducing=(SELECT TIME(creationDate) FROM orders JOIN orderProducts ON (orders.orderId=orderProducts.orderId)
		WHERE orderProducts.orderProductId=NEW.orderProductId);
		
		SET hourOpeningRes=(SELECT opening FROM restaurants WHERE idRestaurantOrder=restaurants.restaurantId);
		SET hourClosingRes=(SELECT closing FROM restaurants WHERE idRestaurantOrder=restaurants.restaurantId);
	
		IF(hourIntroducing<hourOpeningRes OR hourIntroducing>hourClosingRes) THEN
			SET @error_message=CONCAT(idRestaurantOrder,'The restaurant you are trying to order is closed right now, opening: ',hourOpeningRes,
			' closing: ',hourClosingRes);
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =@error_message;
		END IF;
	END //
DELIMITER ;

/*INTRODUCE EL PRECIO TOTAL PARA CADA UNO DE LOS PEDIDOS. SI EL PRECIO TOTAL ES 
SUPERIOR A 10€ ENTONCES EL PEDIDO TENDRÁ GASTOS DE ENVÍO GRATUITO. DE FORMA 
PREDETERMINADA ASIGNA LOS GASTOS DE ENVÍO DEL RESTAURANTE AL QUE SE PIDE*/
DELIMITER //
CREATE OR REPLACE TRIGGER triggerCalculateTotalPriceAndShCosts
	AFTER INSERT ON orderproducts
	FOR EACH ROW
	BEGIN
		DECLARE realTotalPrice DOUBLE;
		DECLARE realShCosts DOUBLE;
		
		SET realShCosts=(SELECT restaurants.shippingCosts FROM orders JOIN restaurants ON(restaurants.restaurantId=orders.restaurantId)
		WHERE orders.orderId=NEW.orderId);-- gastos de envío del restaurante al que se pide
		SET realTotalPrice=PT(NEW.orderId);
		UPDATE orders SET shippingCosts=realShCosts WHERE orderId=NEW.orderId; -- actualizamos el valor
		UPDATE orders SET totalPrice=realTotalPrice WHERE orderId=NEW.orderId;
		IF(realTotalPrice>10)THEN
			UPDATE orders SET shippingCosts=0 WHERE orderId=NEW.orderId;
		END IF; 
	END //
DELIMITER ;

-- COMPRUEBA QUE EN EL RESTAURANTE SE INSERTE EL ID DE UN USUARIO QUE SEA PROPIETARIO
DELIMITER //
CREATE OR REPLACE TRIGGER triggerOwnerId
BEFORE INSERT ON restaurants
FOR EACH ROW
BEGIN
	DECLARE typeOfUser VARCHAR(100);
	SET typeOfUser= (SELECT typeOfUser FROM users WHERE(users.userId=NEW.userIdO));
	IF (typeOfUser!='Propietario') THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The user must be an owner.';
	END IF;
END //
DELIMITER ;

-- COMPRUEBA QUE EN EL PEDIDO SE INSERTE EL ID DE UN USUARIO QUE SEA CLIENTE
DELIMITER //
CREATE OR REPLACE TRIGGER triggerClientId
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
	DECLARE typeOfUser VARCHAR(100);
	SET typeOfUser= (SELECT typeOfUser FROM users WHERE(users.userId=NEW.userIdC));
	IF (typeOfUser!='Cliente') THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The user must be a client.';
	END IF;
END //
DELIMITER ;

-- COMPRUEBA QUE EN EL PEDIDO SE INSERTE EL ID DE UN USUARIO QUE SEA REPARTIDOR
DELIMITER //
CREATE OR REPLACE TRIGGER triggerDeliverymanId
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
	DECLARE typeOfUser VARCHAR(100);
	SET typeOfUser= (SELECT typeOfUser FROM users WHERE(users.userId=NEW.userIdD));
	IF (typeOfUser!='Repartidor') THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The user must be a deliveryman.';
	END IF;
END //
DELIMITER ;

/*COMPRUEBA QUE EN LA VALORACIÓN SE INSERTE EL ID DE UN USUARIO QUE SEA CLIENTE
Y QUE ESE CLIENTE HAYA HECHO AL MENOS UN PEDIDO A ESE RESTAURANTE*/
DELIMITER //
CREATE OR REPLACE TRIGGER triggerAssessment 
BEFORE INSERT ON assessments
FOR EACH ROW 
BEGIN
	DECLARE typeOfUser VARCHAR(100);
	DECLARE numberOrders INT;
	SET typeOfUser= (SELECT typeOfUser FROM users WHERE(users.userId=NEW.userIdC));
	SET numberOrders= (SELECT COUNT(*) FROM orders WHERE(orders.restaurantId=NEW.restaurantId AND orders.userIdC= NEW.userIdC));
	IF (typeOfUser!='Cliente') THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The user must be a client.';
	END IF;
	IF (numberOrders<1) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The client has not placed an order with that restaurant.';
	END IF;
END //
DELIMITER ;