-- CURSOR

-- VISTA AYUDA PRECIO TOTAL
CREATE OR REPLACE VIEW viewTotalPrice AS
   SELECT orderproducts.amount, products.price FROM orders 
   JOIN orderproducts ON (orders.orderId=orderproducts.orderId)
   JOIN products ON (orderproducts.productId=products.productId);

-- CALCULA PRECIO TOTAL DE PEDIDO
DELIMITER //
CREATE OR REPLACE FUNCTION PT(orderId INT) RETURNS DOUBLE
   BEGIN
      DECLARE done BOOLEAN;
      DECLARE price DOUBLE;
      DECLARE register ROW TYPE OF viewTotalPrice;

      DECLARE productsPrice CURSOR FOR SELECT orderproducts.amount, products.price FROM orders 
      JOIN orderproducts ON (orders.orderId=orderproducts.orderId)
      JOIN products ON (orderproducts.productId=products.productId)
      WHERE (orders.orderId=orderId);

      DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := TRUE;

      SET price= 0;
      OPEN productsPrice;
      readLoop: LOOP
         FETCH productsPrice INTO register;
         IF done THEN 
            LEAVE readLoop;
         END IF;
            SET price= price + register.amount*register.price;
      END LOOP;
      CLOSE productsPrice;

      RETURN price;
   END //
DELIMITER ;

SELECT PT(4);