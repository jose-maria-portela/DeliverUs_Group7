-- PROCEDIMIENTOS

-- INSERTAR UN USUARIO REPARTIDOR
DELIMITER //
CREATE OR REPLACE PROCEDURE procInsertUserDeliver(
	id CHAR(9),nameD VARCHAR(100),mailD VARCHAR(100),phoneD CHAR(9),addressD 
	VARCHAR(100),pcD CHAR(5), zoneD INT)
	BEGIN 
		INSERT INTO users(userId,idCard,`name`,mail,phone,address,pc,typeOfUser,payMethod,zoneId) VALUES
		(0,id,nameD,mailD,phoneD,addressD,pcD,'Repartidor',NULL,zoneD);
	END //
DELIMITER ;


-- CAMBIAR LA ZONA EN LA QUE TRABAJA EL REPARTIDOR
DELIMITER //
CREATE OR REPLACE PROCEDURE procChangeZoneDeliverman(id CHAR(9) ,nameD VARCHAR (100))
	BEGIN
		DECLARE newZoneId INT;
		DECLARE newUserId INT;
		SET newZoneId= (SELECT zoneId FROM zones WHERE (zones.name=nameD));
		SET newUserId= (SELECT userId FROM users WHERE (users.idCard=id));
		UPDATE users SET zoneId=newZoneId WHERE (users.userId=newUserId);
	END //
DELIMITER ;


-- CAMBIAR LA CANTIDAD DE UN PRODUCTO EN UN PEDIDO YA EXISTENTE
DELIMITER //
CREATE OR REPLACE PROCEDURE procChangeAmountProduct(idOrder INT,productName VARCHAR(100),amountProduct INT)
   BEGIN
      DECLARE idProduct INT;
      SET idProduct=(SELECT productId FROM products WHERE products.name=productName);
      UPDATE orderProducts SET amount=amountProduct WHERE (orderId=idOrder AND productId=idProduct);
   END //
DELIMITER ;


-- AÑADIR A LISTA DE INACTIVOS A LOS CLIENTES QUE LLEVAN MÁS DE X MESES SIN HACER UN PEDIDO
DELIMITER //
CREATE OR REPLACE PROCEDURE procInactiveClient(months INT)
	BEGIN
	DECLARE oldestOrder DATETIME;
	DECLARE diffTime INT;
	DECLARE done BOOLEAN;
	DECLARE clien ROW TYPE OF users;
	DECLARE clientsCursor CURSOR FOR SELECT * FROM users WHERE (users.typeOfUser='Cliente');
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := TRUE;
	DELETE FROM inactiveClients;
	
	OPEN clientsCursor;
		readLoop: LOOP
			FETCH clientsCursor INTO clien;
			IF done THEN 
				LEAVE readLoop;
			END IF; 
			
			SET oldestOrder= oldestOrder(clien.userId);
			IF (oldestOrder IS NOT NULL) THEN
				SET diffTime= timeHelp(oldestOrder);
				IF (diffTime>months) THEN 
					   INSERT INTO inactiveClients(userIdC) VALUES 
					   (clien.userId);
				END IF;
			END IF;
		END LOOP;
		
	CLOSE clientsCursor;
	END //
DELIMITER ;

-- FUNCIONES DE AYUDA
DELIMITER //
CREATE OR REPLACE FUNCTION timeHelp(dateStart DATETIME) RETURNS INT
BEGIN
	DECLARE months INT;
	SET months= TIMESTAMPDIFF(MONTH, dateStart, NOW());
	RETURN months;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION oldestOrder(clientId INT) RETURNS DATETIME
BEGIN
	DECLARE maxDeliveryTime DATETIME; 
	SET maxDeliveryTime= (SELECT MIN(deliveryDate) FROM orders WHERE (orders.userIdC=clientId));
	RETURN maxDeliveryTime;
END //
DELIMITER ;

/*CALL procInsertUserDeliver('12345678N','Federico Pérez Sosa','fdezkli@gmail.com','654789921','Avenida de la Rosa 13','21563',2);
CALL procChangeZoneDeliverman('67898765R', 'Triana');
CALL procChangeAmountProduct(1,'CocaCola',20);
CALL procInactiveClient(20);*/