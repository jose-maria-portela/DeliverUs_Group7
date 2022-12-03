-- CREACIÓN DE TABLAS

DROP TABLE if EXISTS assessments;
DROP TABLE if EXISTS inactiveClients;
DROP TABLE if EXISTS orderProducts;
DROP TABLE if EXISTS products;
DROP TABLE if EXISTS orders;
DROP TABLE if EXISTS restaurants;
DROP TABLE if EXISTS users;
DROP TABLE if EXISTS zones;

CREATE TABLE zones(
	zoneId INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL UNIQUE,
	PRIMARY KEY (zoneId)
);

CREATE TABLE users(
	userId INT NOT NULL AUTO_INCREMENT,  
	idCard CHAR(9) NOT NULL UNIQUE,
	`name` VARCHAR(100) NOT NULL, 
	mail VARCHAR(100) NOT NULL UNIQUE,
	phone CHAR(9) NOT NULL UNIQUE,
	address VARCHAR(100) NOT NULL,
	pc CHAR(5) NOT NULL,
	typeOfUser VARCHAR(100) NOT NULL,
	payMethod VARCHAR(100),
	zoneId INT,
	FOREIGN KEY(zoneId) REFERENCES zones (zoneId),
	CONSTRAINT invalidPayMethod CHECK (payMethod IN ('PayPal','Efectivo','TarjetaBancaria')),-- condicion solo en clientes
	CONSTRAINT invalidTypeOfUser CHECK (typeOfUser IN ('Cliente','Repartidor','Propietario')),
	PRIMARY KEY(userId)
);

CREATE TABLE restaurants(
	restaurantId INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL,
	description VARCHAR(200) NOT NULL,
	address VARCHAR(100) NOT NULL,
	pc CHAR(5) NOT NULL,
	url VARCHAR(100) NOT NULL UNIQUE,
	mail VARCHAR(100) NOT NULL UNIQUE,
	phone CHAR(9) NOT NULL UNIQUE,
	foodType VARCHAR(100) NOT NULL,
	shippingCosts DOUBLE NOT NULL,
	avgServiceTime INT NOT NULL,
	opening TIME NOT NULL,
	closing TIME NOT NULL,
	`condition` BOOLEAN NOT NULL,
	userIdO INT NOT NULL,
	zoneId INT NOT NULL,
	PRIMARY KEY (restaurantId),
	FOREIGN KEY (userIdO) REFERENCES users (userId), -- usuarios propietarios
	FOREIGN KEY (zoneId) REFERENCES zones(zoneId),
	CONSTRAINT invalidAvgServiceTime CHECK (avgServiceTime>0),
	CONSTRAINT invalidShippingCosts CHECK (shippingCosts>=0),
	CONSTRAINT invalidTime CHECK (closing>opening),
	CONSTRAINT invalidFoodType CHECK (foodType IN (
													'China','Japonesa','Italiana',
													'Turca','Americana','Peruana',
													'Mejicana','Tradicional'))
);

CREATE TABLE orders(
	orderId INT NOT NULL AUTO_INCREMENT,
	creationDate DATETIME NOT NULL,
	activationDate DATETIME NOT NULL,
	sendingDate DATETIME NOT NULL,
	deliveryDate DATETIME NOT NULL,
	address VARCHAR(100) NOT NULL,
	totalPrice DOUBLE,
	shippingCosts DOUBLE,
	userIdD INT NOT NULL,
	userIdC INT NOT NULL,
	restaurantId INT NOT NULL,
	PRIMARY KEY(orderId),
	FOREIGN KEY (userIdD) REFERENCES users (userId),-- usuarios repartidores
	FOREIGN KEY (userIdC) REFERENCES users (userId),-- usuarios clientes
	FOREIGN KEY (restaurantId) REFERENCES restaurants (restaurantId),
	CONSTRAINT invalidShippingCosts CHECK (shippingCosts>=0),
	CONSTRAINT invalidTime CHECK (creationDate<activationDate AND 
	activationDate<sendingDate AND sendingDate<deliveryDate)
);

CREATE TABLE products(
	productId INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL,
	description VARCHAR(100) NOT NULL,
	price DOUBLE NOT NULL,
	available BOOLEAN NOT NULL,
	category VARCHAR(100) NOT NULL,
	productOrder INT NOT NULL,
	restaurantId INT NOT NULL,
	PRIMARY KEY (productId),
	FOREIGN KEY (restaurantId) REFERENCES restaurants (restaurantId),
	CONSTRAINT invalidPrice CHECK (price>0),
	CONSTRAINT invalidProductOrder CHECK (productOrder>=0),
	CONSTRAINT invalidCategory CHECK(category IN ('Bebida','Entrante','Plato','Postre'))
);

CREATE TABLE orderProducts(
	orderProductId INT NOT NULL AUTO_INCREMENT,
	amount INT NOT NULL,
	orderId INT NOT NULL,
	productId INT NOT NULL,
	PRIMARY KEY (orderProductId),
	FOREIGN KEY (orderId) REFERENCES orders (orderId),
	FOREIGN KEY (productId) REFERENCES products (productId),
	CONSTRAINT invalidAmount CHECK (amount>0)
);

CREATE TABLE inactiveClients(
   userIdC INT NOT NULL,
   FOREIGN KEY (userIdC) REFERENCES users (userId)
);

CREATE TABLE assessments(
   assessmentId INT NOT NULL AUTO_INCREMENT,
   description VARCHAR(500) NOT NULL,
   rate INT NOT NULL,
   userIdC INT NOT NULL,
   restaurantId INT NOT NULL,
   PRIMARY KEY(assessmentId),
   FOREIGN KEY (userIdC) REFERENCES users (userId),
   FOREIGN KEY (restaurantId) REFERENCES restaurants (restaurantId),
   CONSTRAINT invalidRate CHECK (rate>=1 AND rate<=5)
);