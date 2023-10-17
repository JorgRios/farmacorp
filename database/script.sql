
CREATE `cliente` (
  `idcliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(191) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `telefono` INT NULL,
  `direccion` TEXT NULL,
  PRIMARY KEY (`idcliente`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `farmacorp`.`proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `farmacorp`.`proveedor` (
  `idproveedor` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(191) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `nit` VARCHAR(15) NOT NULL,
  `telefono` INT NULL,
  `direccion` TEXT NULL,
  PRIMARY KEY (`idproveedor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `farmacorp`.`producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `farmacorp`.`producto` (
  `idproducto` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idproveedor` INT NOT NULL,
  `nombre` VARCHAR(191) NOT NULL,
  `descripcion` TEXT NULL,
  `precio_venta` DECIMAL(12,2) NOT NULL,
  `precio_compra` DECIMAL(12,2) NOT NULL,
  `fecha_vencimiento` DATETIME NULL,
  PRIMARY KEY (`idproducto`, `idproveedor`),
  INDEX `fk_producto_proveedor1_idx` (`idproveedor` ASC) VISIBLE,
  CONSTRAINT `fk_producto_proveedor1`
    FOREIGN KEY (`idproveedor`)
    REFERENCES `farmacorp`.`proveedor` (`idproveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `farmacorp`.`sucursal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `farmacorp`.`sucursal` (
  `idsucursal` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(191) NOT NULL,
  `direccion` TEXT NOT NULL,
  `telefono` INT NULL,
  PRIMARY KEY (`idsucursal`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `farmacorp`.`acuerdo_hospitales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `farmacorp`.`acuerdo_hospitales` (
  `idacuerdo_hospitales` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idsucursal` INT NOT NULL,
  `hospital` VARCHAR(150) NOT NULL,
  `pocentaje_descuento` DECIMAL(5,2) NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_final` DATE NOT NULL,
  PRIMARY KEY (`idacuerdo_hospitales`, `idsucursal`),
  INDEX `fk_acuerdo_hospitales_sucursal1_idx` (`idsucursal` ASC) VISIBLE,
  CONSTRAINT `fk_acuerdo_hospitales_sucursal1`
    FOREIGN KEY (`idsucursal`)
    REFERENCES `farmacorp`.`sucursal` (`idsucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `farmacorp`.`venta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `farmacorp`.`venta` (
  `idventa` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idcliente` INT NOT NULL,
  `idsucursal` INT NOT NULL,
  `idacuerdo_hospitales` INT UNSIGNED NULL,
  `fecha` DATETIME NOT NULL,
  `forma_cobro` CHAR(1) NOT NULL,
  `descuento_clubcliente` DECIMAL(12,2) NULL,
  `descuento_hospital` DECIMAL(12,2) NULL,
  PRIMARY KEY (`idventa`, `idcliente`, `idsucursal`),
  INDEX `fk_venta_cliente_idx` (`idcliente` ASC) VISIBLE,
  INDEX `fk_venta_sucursal1_idx` (`idsucursal` ASC) VISIBLE,
  INDEX `fk_venta_acuerdo_hospitales1_idx` (`idacuerdo_hospitales` ASC) VISIBLE,
  CONSTRAINT `fk_venta_cliente`
    FOREIGN KEY (`idcliente`)
    REFERENCES `farmacorp`.`cliente` (`idcliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_venta_sucursal1`
    FOREIGN KEY (`idsucursal`)
    REFERENCES `farmacorp`.`sucursal` (`idsucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_venta_acuerdo_hospitales1`
    FOREIGN KEY (`idacuerdo_hospitales`)
    REFERENCES `farmacorp`.`acuerdo_hospitales` (`idacuerdo_hospitales`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `farmacorp`.`venta_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `farmacorp`.`venta_producto` (
  `idventa` INT UNSIGNED NOT NULL,
  `idproducto` INT UNSIGNED NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (`idventa`, `idproducto`),
  INDEX `fk_venta_has_producto_producto1_idx` (`idproducto` ASC) VISIBLE,
  INDEX `fk_venta_has_producto_venta1_idx` (`idventa` ASC) VISIBLE,
  CONSTRAINT `fk_venta_has_producto_venta1`
    FOREIGN KEY (`idventa`)
    REFERENCES `farmacorp`.`venta` (`idventa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_venta_has_producto_producto1`
    FOREIGN KEY (`idproducto`)
    REFERENCES `farmacorp`.`producto` (`idproducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `farmacorp`.`sucursal_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `farmacorp`.`sucursal_producto` (
  `sucursal_idsucursal` INT NOT NULL,
  `producto_idproducto` INT UNSIGNED NOT NULL,
  `stock` INT NOT NULL,
  PRIMARY KEY (`sucursal_idsucursal`, `producto_idproducto`),
  INDEX `fk_sucursal_has_producto_producto1_idx` (`producto_idproducto` ASC) VISIBLE,
  INDEX `fk_sucursal_has_producto_sucursal1_idx` (`sucursal_idsucursal` ASC) VISIBLE,
  CONSTRAINT `fk_sucursal_has_producto_sucursal1`
    FOREIGN KEY (`sucursal_idsucursal`)
    REFERENCES `farmacorp`.`sucursal` (`idsucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sucursal_has_producto_producto1`
    FOREIGN KEY (`producto_idproducto`)
    REFERENCES `farmacorp`.`producto` (`idproducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `farmacorp`.`factura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `farmacorp`.`factura` (
  `idfactura` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idventa` INT UNSIGNED NOT NULL,
  `numero` INT NOT NULL,
  `fecha` DATETIME NOT NULL,
  `nro_autorizacion` VARCHAR(50) NULL,
  `monto_total` DECIMAL(12,2) NULL,
  `descuento_total` DECIMAL(12,2) NULL,
  PRIMARY KEY (`idfactura`, `idventa`),
  INDEX `fk_factura_venta1_idx` (`idventa` ASC) VISIBLE,
  CONSTRAINT `fk_factura_venta1`
    FOREIGN KEY (`idventa`)
    REFERENCES `farmacorp`.`venta` (`idventa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `farmacorp`.`club_cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `farmacorp`.`club_cliente` (
  `idclubcliente` INT NOT NULL AUTO_INCREMENT,
  `idcliente` INT NOT NULL,
  `estado` CHAR(1) NOT NULL,
  `puntos_ganados` INT NULL,
  `puntos_usados` INT NULL,
  PRIMARY KEY (`idclubcliente`),
  INDEX `fk_club_cliente_cliente1_idx` (`idcliente` ASC) VISIBLE,
  CONSTRAINT `fk_club_cliente_cliente1`
    FOREIGN KEY (`idcliente`)
    REFERENCES `farmacorp`.`cliente` (`idcliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `farmacorp`.`compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `farmacorp`.`compra` (
  `idcompra` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idproveedor` INT NOT NULL,
  `fecha` DATETIME NOT NULL,
  `descripcion` TEXT NULL,
  PRIMARY KEY (`idcompra`, `idproveedor`),
  INDEX `fk_compra_proveedor1_idx` (`idproveedor` ASC) VISIBLE,
  CONSTRAINT `fk_compra_proveedor1`
    FOREIGN KEY (`idproveedor`)
    REFERENCES `farmacorp`.`proveedor` (`idproveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `farmacorp`.`compra_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `farmacorp`.`compra_producto` (
  `idcompra` INT UNSIGNED NOT NULL,
  `idsucursal` INT NOT NULL,
  `idproducto` INT UNSIGNED NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(12,2) NOT NULL,
  `descuento` DECIMAL(12,2) NULL,
  PRIMARY KEY (`idcompra`, `idsucursal`, `idproducto`),
  INDEX `fk_compra_has_producto_producto1_idx` (`idproducto` ASC) VISIBLE,
  INDEX `fk_compra_has_producto_compra1_idx` (`idcompra` ASC) VISIBLE,
  INDEX `fk_compra_producto_sucursal1_idx` (`idsucursal` ASC) VISIBLE,
  CONSTRAINT `fk_compra_has_producto_compra1`
    FOREIGN KEY (`idcompra`)
    REFERENCES `farmacorp`.`compra` (`idcompra`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compra_has_producto_producto1`
    FOREIGN KEY (`idproducto`)
    REFERENCES `farmacorp`.`producto` (`idproducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compra_producto_sucursal1`
    FOREIGN KEY (`idsucursal`)
    REFERENCES `farmacorp`.`sucursal` (`idsucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
