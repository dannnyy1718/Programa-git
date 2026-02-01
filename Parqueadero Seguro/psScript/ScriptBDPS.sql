-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema parqueoseguro
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema parqueoseguro
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `parqueoseguro` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `parqueoseguro` ;

-- -----------------------------------------------------
-- Table `parqueoseguro`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parqueoseguro`.`usuarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `correo` VARCHAR(100) NOT NULL,
  `contrasena` VARCHAR(255) NOT NULL,
  `tipo` ENUM('cliente', 'administrador') NULL DEFAULT 'cliente',
  `fecha_registro` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `correo` (`correo` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `parqueoseguro`.`parqueadero`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parqueoseguro`.`parqueadero` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `direccion` VARCHAR(255) NOT NULL,
  `ciudad` VARCHAR(100) NOT NULL,
  `capacidad_total` INT NOT NULL,
  `cupos_disponibles` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `parqueoseguro`.`vehiculos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parqueoseguro`.`vehiculos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `usuario_id` INT NOT NULL,
  `placa` VARCHAR(20) NOT NULL,
  `tipo` ENUM('carro', 'moto') NOT NULL,
  `marca` VARCHAR(50) NOT NULL,
  `modelo` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `placa` (`placa` ASC) VISIBLE,
  INDEX `usuario_id` (`usuario_id` ASC) VISIBLE,
  CONSTRAINT `vehiculos_ibfk_1`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `parqueoseguro`.`usuarios` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `parqueoseguro`.`reservas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parqueoseguro`.`reservas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `usuario_id` INT NOT NULL,
  `parqueadero_id` INT NOT NULL,
  `vehiculo_id` INT NOT NULL,
  `fecha_inicio` DATETIME NOT NULL,
  `fecha_fin` DATETIME NOT NULL,
  `estado` ENUM('pendiente', 'confirmada', 'cancelada', 'finalizada') NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `usuario_id` (`usuario_id` ASC) VISIBLE,
  INDEX `parqueadero_id` (`parqueadero_id` ASC) VISIBLE,
  INDEX `vehiculo_id` (`vehiculo_id` ASC) VISIBLE,
  CONSTRAINT `reservas_ibfk_1`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `parqueoseguro`.`usuarios` (`id`),
  CONSTRAINT `reservas_ibfk_2`
    FOREIGN KEY (`parqueadero_id`)
    REFERENCES `parqueoseguro`.`parqueadero` (`id`),
  CONSTRAINT `reservas_ibfk_3`
    FOREIGN KEY (`vehiculo_id`)
    REFERENCES `parqueoseguro`.`vehiculos` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `parqueoseguro`.`pagos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parqueoseguro`.`pagos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `reserva_id` INT NOT NULL,
  `monto` DECIMAL(10,2) NOT NULL,
  `metodo_pago` ENUM('efectivo', 'tarjeta', 'nequi', 'daviplata') NOT NULL,
  `fecha_pago` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `reserva_id` (`reserva_id` ASC) VISIBLE,
  CONSTRAINT `pagos_ibfk_1`
    FOREIGN KEY (`reserva_id`)
    REFERENCES `parqueoseguro`.`reservas` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
