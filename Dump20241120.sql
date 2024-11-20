-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: paginacitas
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cita`
--

DROP TABLE IF EXISTS `cita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cita` (
  `idcita` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `idprofesional` int NOT NULL,
  `idhorarios` int NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `motivo` varchar(100) NOT NULL,
  `detalles` varchar(300) NOT NULL,
  PRIMARY KEY (`idcita`),
  KEY `fk_cita_usuario` (`idusuario`),
  KEY `fk_cita_profesional` (`idprofesional`),
  KEY `fk_idhorarios` (`idhorarios`),
  CONSTRAINT `fk_cita_profesional` FOREIGN KEY (`idprofesional`) REFERENCES `profesional` (`idprofesional`),
  CONSTRAINT `fk_cita_usuario` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`),
  CONSTRAINT `fk_idhorarios` FOREIGN KEY (`idhorarios`) REFERENCES `horarios` (`idhorarios`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cita`
--

LOCK TABLES `cita` WRITE;
/*!40000 ALTER TABLE `cita` DISABLE KEYS */;
INSERT INTO `cita` VALUES (37,2,3,49,'2024-11-15','20:00:00','contruccion','casa'),(40,2,3,48,'2024-11-14','01:00:00','recorte','vfdvfdvf'),(47,1,3,47,'2024-11-20','10:00:00','contruccion','fddvfvfvfv'),(49,1,4,53,'2024-11-25','10:59:00','DISEÑO DE PLANOS','diseño de una casa de campo');
/*!40000 ALTER TABLE `cita` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios`
--

DROP TABLE IF EXISTS `horarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios` (
  `idhorarios` int NOT NULL AUTO_INCREMENT,
  `idprofesional` int NOT NULL,
  `dia` text NOT NULL,
  `inicio` text NOT NULL,
  `fin` text NOT NULL,
  `estado` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idhorarios`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios`
--

LOCK TABLES `horarios` WRITE;
/*!40000 ALTER TABLE `horarios` DISABLE KEYS */;
INSERT INTO `horarios` VALUES (40,3,'Lunes','02:00','03:00',NULL),(47,3,'Miércoles','10:00','23:00','ocupado'),(48,3,'Jueves','01:00','02:00','ocupado'),(49,3,'Viernes','20:00','03:03','ocupado'),(50,3,'Domingo','02:58','04:58',NULL),(53,4,'Lunes','10:59','12:59','ocupado');
/*!40000 ALTER TABLE `horarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profesional`
--

DROP TABLE IF EXISTS `profesional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profesional` (
  `idprofesional` int NOT NULL AUTO_INCREMENT,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `celular` int NOT NULL,
  `fechanacimiento` date NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `servicio` varchar(100) NOT NULL,
  `nombreusuario` varchar(100) NOT NULL,
  `contraseña` varchar(100) NOT NULL,
  `fotoperfil` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`idprofesional`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profesional`
--

LOCK TABLES `profesional` WRITE;
/*!40000 ALTER TABLE `profesional` DISABLE KEYS */;
INSERT INTO `profesional` VALUES (3,'Walter Arturo','Zegarra Herrera',917153607,'2024-08-27','profesional','constructor','elprofe','elprofe','https://img.freepik.com/fotos-premium/persona-casco-amarillo-casco-amarillo-mascara-amarilla_1289884-3666.jpg?w=360'),(4,'Flor Elizabeth','Novoa Jara',988632145,'2024-09-12','profesional','doctor','demo','demo','https://img.freepik.com/fotos-premium/mujer-casco-amarillo-esta-parada-frente-trabajador-construccion_905510-1481.jpg'),(5,'Jorge','Gonzalez',492932008,'2024-10-03','profesional','médico',' jorgegonzalez','123456','https://st.depositphotos.com/4218696/52209/i/450/depositphotos_522097370-stock-photo-portrait-of-happy-arabic-doctor.jpg'),(6,'Maria Luna','Diaz Herrera',956874585,'2008-02-09','profesional','psicólogo','maria','123456','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzBClWN5tWGTloGp50TNwmlVW3OyhE9SUEiw&s'),(7,'Jose Alejandro','Perez Alva',985698745,'2016-07-02','profesional','profesor','joseale','123456','https://img.freepik.com/foto-gratis/profesor-saliente-pie-tribuna-explicando-material_23-2148201007.jpg'),(8,'Alex Fernando','Prado Manosalva',921456387,'2024-09-04','profesional','médico','alexfer','123456','https://www.imo.es/assets/2022/03/jorge-ruiz-medrano.webp'),(9,'Luis Pedro','Alva Chuquiruna',986721352,'2021-02-12','profesional','jardinero','luisalva','123456','https://img.freepik.com/fotos-premium/hombre-feliz-delantal-cuchara-jardin-verano_380164-256155.jpg'),(10,'Jose Alejandro','Zegarra Herrera',983092477,'2024-11-08','profesional','pintor','joze','joze','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png'),(11,'cdonc dscsdc','dscdc',983092477,'2006-10-31','profesional','enfermero','scsdc','dscsdcsd','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png'),(12,'dfvcx jmjhmjh','mhjmjmjh',956874585,'2006-11-11','profesional','chef','ffgbf','scdsc','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png'),(13,'mjmhjmj ddsds','ghnghdfvd',971461551,'2006-11-17','profesional','chef','tyhytyt','161233','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png'),(14,'njmmkj unny','ytythtty',971461551,'2006-11-09','profesional','docente','thythth','njjnhj','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png');
/*!40000 ALTER TABLE `profesional` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `idusuario` int NOT NULL AUTO_INCREMENT,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `celular` int NOT NULL,
  `fechanacimiento` date NOT NULL,
  `tipo` varchar(100) NOT NULL,
  `nombreusuario` varchar(100) NOT NULL,
  `contraseña` varchar(50) NOT NULL,
  `fotoperfil` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Walter Arturo','Zegarra Herrera',983092477,'1993-11-10','usuario','admin','admin','https://avatarfiles.alphacoders.com/375/375590.png'),(2,'Paul ','Limay Romero',962073125,'2002-11-29','usuario','elpapi','123456','https://avatarfiles.alphacoders.com/375/375590.png'),(7,'Luis Pedro','Novoa Jara',971461551,'2024-11-06','usuario','luno','1234','https://avatarfiles.alphacoders.com/375/375590.png'),(8,'Jorge alberto','campos saavedra',985623574,'2024-11-01','usuario','joca','1234','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png'),(9,'Jose Alejandro','Novoa Jara',983092477,'2024-11-08','usuario','jono','1234','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png'),(10,'fff','rrr',983092477,'2024-10-25','usuario','fr','1234','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png'),(11,'ttt','ggg',988632145,'2024-11-01','usuario','fg','1234','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png'),(12,'Jose Alberto','gonzalo torres',971461551,'2024-11-06','usuario','jogo','jogo','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png'),(14,'pedro  ulises ','macias nolerto',983092477,'2006-11-02','usuario','pedro','admin','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png'),(17,'frtrtgrtgr vrtfvr','rverce',988632145,'2006-11-16','usuario','qwwqsqw','umkukmu','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png'),(18,'njmjh hbfhfg','gbfgbgf ggbgf',988632145,'2006-11-08','usuario','gfbfgb','gbffg','https://w7.pngwing.com/pngs/818/1009/png-transparent-user-account-profile-account-user-user-profile-avatar-3d-icon-thumbnail.png');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-20  0:46:55
