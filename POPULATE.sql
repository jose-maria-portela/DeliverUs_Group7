-- POBLACIÓN DE TABLAS

DELETE FROM orderProducts;
DELETE FROM products;
DELETE FROM orders;
DELETE FROM restaurants;
DELETE FROM users;
DELETE FROM zones;

INSERT INTO zones(zoneId,`name`) VALUES
(1,'Sevilla Capital'),
(2,'Aljarafe'),
(3,'Pino Montano'),
(4,'Triana'),
(5,'Los Remedios');

INSERT INTO users(userId,idCard,`name`,mail,phone,address,pc,typeOfUser,payMethod,zoneId) VALUES 
(1, '67898765R', 'Kevin Martínez Monedero', 'er_keviiiin@hotmail.es', '608958742', 'Avda Reina Mercedes 41', '41012','Repartidor',NULL,1),
(2, '78961235B', 'Andrés Pizzano Cerrillos', 'andrew@gmail.com', '608938732', 'Avda Universidad de Salamanca 13', '41930','Repartidor',NULL,4),
(3, '67845625Z', 'Lorenzo Torralba Lanzas', 'ellorenso21@gmail.com', '608958312', 'Avda Reina Mercedes 3', '41012','Repartidor',NULL,3),
(4, '67898765A', 'Francisco Avilés Carrera', 'gemeliersss@outlook.com', '609968742', 'Avda Al Margen 5', '41930','Repartidor',NULL,2),
(5, '67893333V', 'Alexis Molins López', 'biris_norte55@hotmail.es', '651583225', 'Avda de la Inspiración', '41014','Repartidor',NULL,5),
(6, '67895566J', 'Jose María Portela Huerta', 'josemaria86@gmail.com', '608998745', 'Calle Piodoce 15', '41234','Propietario',NULL,NULL),
(7, '67894567A', 'Sohail Rashid Charadi', 'sohashisha2@kebab.com', '608555444', 'Avda Los Remedios', '41015','Propietario',NULL,NULL),
(8, '54321678N', 'Pedro Jiménez Pérez', 'ximenezjp@hotmail.es', '652345675', 'Avda Reina Mercedes 8', '41013','Propietario',NULL,NULL),
(9, '67898866P', 'William Olankawa Iniesta', 'wiolaninies@hotmail.es', '693214567', 'Calle Sierpes 3', '41012','Propietario',NULL,NULL),
(10, '67888962W', 'Pedro Sánchez Pérez-Castejón', 'pedritosanche5@hotmail.es', '608665522', 'Avda Moncloa s/n', '41010','Cliente','PayPal',NULL),
(11, '67888999A', 'Pablo Iglesias Turrión', 'coletaforever5@outlook.es', '608689522', 'Avda Moncloa s/n', '41010','Cliente','PayPal',NULL),
(12, '67877777M', 'Mariano Rajoy Brey', 'elpuebloespañol@hotmail.es', '608555666', 'Avda Moncloa s/n', '41010','Cliente','Efectivo',NULL),
(13, '67888332D', 'Linus Benedict Torvalds', 'linuxbestso@hotmail.es', '608875612', 'Calle Betis 12', '41010','Cliente','TarjetaBancaria',NULL),
(14, '67882424X', 'William Henry Gates', 'windowsbestso@hotmail.es', '608857891', 'Calle Betis 13', '41930','Cliente','TarjetaBancaria',NULL),
(15, '67888962U', 'Steven Paul Jobs', 'appleisbetter@hotmail.es', '608785412', 'Calle Betis 14', '41010','Cliente','TarjetaBancaria',NULL),
(16, '65897412M', 'Juan Díaz Álvarez', 'jdiazdiazdias@hotmail.es', '608785419', 'Calle Betis 22', '41930','Propietario',NULL,NULL),
(17, '78459632N', 'Cristiano Ronaldo dos Santos', 'cr7suu@cr.com', '457893612', 'Calle margarita 40', '41930','Cliente','TarjetaBancaria',NULL),
(18, '78789855M', 'Pau Gasol Sáez', 'paupaupivot@gmail.es', '605231454', 'Calle Béquer 7', '41010','Repartidor',NULL,3),
(19, '88896325L', 'Peter Benjamin Parker', 'gafitas33@hotmail.es', '666321255', 'Calle Lope de Vega 1', '41925','Cliente','TarjetaBancaria',NULL),
(20, '98741236C', 'Lionel Andrés Messi', 'messinashee33@gmail.es', '321456987', 'Calle Béquer 5', '41010','Propietario',NULL,NULL),
(21, '45457878R', 'Luis Enrique Martínez García', 'luispadrique@hotmail.es', '608885413', 'Calle Dos Hermanas 5', '41907','Propietario',NULL,NULL);

INSERT INTO restaurants(restaurantId,`name`,description,address,pc,url,mail,phone,foodType,
shippingCosts,avgServiceTime,opening,closing,`condition`,userIdO,zoneId) VALUES
(1, 'BurgenKing', 'Restaurante de comida rápida especializado en hamburguesas', 'C/Pages del Corro','41930', 'www.myBurgerKing.com','burgerking_32@bk.es', '954558932', 'Americana', 1.6, 20, '13:00:00', '23:00:00', TRUE, 6, 1),
(2, 'Kebab Reina Mercedes', 'Establecimiento especializado en kebabs', 'Av/ Reina Mercedes','41930', 'www.KebabTurco.com','kebabturk@gmail.com', '967823456', 'Turca', 1.3, 10, '13:00:00', '23:00:00', TRUE, 7 , 2),
(3, 'Papa Johns', 'Pizzas y comida rápida a muy buen precio', 'Av/ Reina Mercedes','41930', 'www.papajohns.com','papajhons_76@ppj.es', '659342576', 'Americana', 2.5, 30, '12:00:00', '22:30:00', TRUE, 8, 3),
(4, 'Goiko Grill', 'Hamburguesas deluxe calidad precio', 'C/ Albareda 14', '41930','www.GoikoGrill.com','goikoalbareda@gk.es','734098342', 'Americana', 2.2, 30, '20:00:00', '23:00:00', TRUE, 9, 4),
(5, 'Casa Paco', 'Comida tradicional española para toda la familia', 'C/ Albareda  24', '41930','www.casaPaco.com','casapaco33@gmail.com','966322145', 'Tradicional', 3.3, 30, '20:00:00', '23:00:00', TRUE, 21, 4),
(6, 'Iguanas Ranas', 'Comida mejicana tradicional de buena calidad', 'C/ Reyes Católicos 18','41930', 'www.iguanasranas.com','iguanasreyesc@gmail.com', '955512067','Mejicana',3.5, 25, '12:00:00', '23:30:00', TRUE , 21,1),
(7, 'Asador Argentino Tradicional', 'Carne Argentina en abundancia', 'C/ Alférez 20','41930', 'www.argentinoss5.com','argentinoss5@gmail.com', '954121245','Tradicional',2.1, 30, '13:00:00', '23:30:00', TRUE , 14,4),
(8, 'El tortellini', 'Comida italiana tradicional de buena calidad', 'C/ Reyes Católicos 35','41930', 'www.eltortini4545.com','eltortini4545@gmail.com', '955122132','Italiana',1.6, 40, '12:30:00', '23:30:00', TRUE , 16,5);

INSERT INTO products(productId,`name`,description,price,available,category,productOrder,restaurantId) VALUES
(1,'CocaCola','Bebida refrescante de frutas',1.2,TRUE,'Bebida',1,1),
(2,'Fanta','Bebida refrescante de naranja',1.2,TRUE,'Bebida',1,6),
(3,'Nestea','Bebida refrescante de te frío',1.2,TRUE,'Bebida',1,5),
(4,'Patatas Fritas','Patatas fritas en aceite de oliva',3.2,TRUE,'Entrante',2,1),
(5,'Nachos','Nachos mejicanos con guacamole',3.5,TRUE,'Entrante',2,6),
(6,'Ensaladilla','Ensaladilla de patata mahonesa y gambas',3.7,TRUE,'Entrante',2,5),
(7,'Hamburguesa','Hamburguesa de ternera completa',8.2,TRUE,'Plato',2,1),
(8,'Quesadillas','Quesadillas clásicas mejicanas',8.3,TRUE,'Plato',2,6),
(9,'Tortilla de patatas','Tortilla española con cebolla',8.9,TRUE,'Plato',2,5),
(10,'Tortitas','Tortitas de huevo y harina',5.3,TRUE,'Postre',2,1),
(11,'Flan','Flan de huevo con caramelo dulce',5.2,TRUE,'Postre',2,6),
(12,'Arroz con leche','Arroz con leche y canela de la abuela',5.1,TRUE,'Postre',2,5),
(13,'Casera','Bebida refrescante con gas y pocas calorías',1.2,TRUE,'Bebida',1,8),
(14,'Pizza Barbacoa','Pizza con carne y salsa barbacoa',8.6,TRUE,'Plato',2,8),
(15,'Coulant de chocolate','Postre de chocolate y helado de vainilla',6.7,TRUE,'Postre',3,8);

INSERT INTO orders(orderId,creationDate,activationDate,sendingDate,deliveryDate,address,totalPrice,shippingCosts,userIdC, userIdD,restaurantId) VALUES
(1,'2022-03-02 13:55:05','2022-03-02 13:56:05','2022-03-02 13:59:05','2022-03-02 14:10:00','Calle Piodoce 15',0,0,11,1,1),
(2,'2022-03-05 22:03:55','2022-03-05 22:04:55','2022-03-05 22:07:55','2022-03-05 22:30:55','Avda de la Inspiración',0,0,19,2,6),
(3,'2022-03-04 20:00:00','2022-03-04 20:01:00','2022-03-04 20:04:00','2022-03-04 20:26:00','Calle Betis 13',0,0,12,3,5),
(4,'2022-03-04 15:00:00','2022-03-04 15:01:00','2022-03-04 15:04:00','2022-03-04 15:26:00','Calle Alfonso XII',0,0,17,4,8);

INSERT INTO orderProducts(orderProductId,amount,orderId,productId) VALUES
(1,2,1,1),
(2,2,1,4),
(3,3,1,7),
(4,2,2,2),
(5,3,2,5),
(6,4,2,8),
(7,1,3,3),
(8,1,3,6),
(9,2,4,13),
(10,1,4,14),
(11,2,4,15);

INSERT INTO assessments(assessmentId,description,rate,userIdC,restaurantId) VALUES
(1,'No es un BurgerKing se hace llamar burgenking y es el mayor robo que he visto, hamburguesas nefastas y establecimiento sucio',1,11,1),
(2,'Comida demasiado picante y tardan mucho en atenderte',1,19,6),
(3,'la mejor hambourguesa q mecomío',5,12,5);
