/*!50503 SET NAMES utf8mb4 */;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: soccer
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;/*!50503 SET NAMES utf8mb4 */;

--
-- Table structure for table `auth_group`
--
USE soccer;
DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add Token',6,'add_token'),(22,'Can change Token',6,'change_token'),(23,'Can delete Token',6,'delete_token'),(24,'Can view Token',6,'view_token'),(25,'Can add Token',7,'add_tokenproxy'),(26,'Can change Token',7,'change_tokenproxy'),(27,'Can delete Token',7,'delete_tokenproxy'),(28,'Can view Token',7,'view_tokenproxy'),(29,'Can add completed task',8,'add_completedtask'),(30,'Can change completed task',8,'change_completedtask'),(31,'Can delete completed task',8,'delete_completedtask'),(32,'Can view completed task',8,'view_completedtask'),(33,'Can add task',9,'add_task'),(34,'Can change task',9,'change_task'),(35,'Can delete task',9,'delete_task'),(36,'Can view task',9,'view_task'),(37,'Can add customer',10,'add_customer'),(38,'Can change customer',10,'change_customer'),(39,'Can delete customer',10,'delete_customer'),(40,'Can view customer',10,'view_customer'),(41,'Can add employee',11,'add_employee'),(42,'Can change employee',11,'change_employee'),(43,'Can delete employee',11,'delete_employee'),(44,'Can view employee',11,'view_employee'),(45,'Can add customer account',12,'add_customeraccount'),(46,'Can change customer account',12,'change_customeraccount'),(47,'Can delete customer account',12,'delete_customeraccount'),(48,'Can view customer account',12,'view_customeraccount'),(49,'Can add employee account',13,'add_employeeaccount'),(50,'Can change employee account',13,'change_employeeaccount'),(51,'Can delete employee account',13,'delete_employeeaccount'),(52,'Can view employee account',13,'view_employeeaccount'),(53,'Can add league',14,'add_league'),(54,'Can change league',14,'change_league'),(55,'Can delete league',14,'delete_league'),(56,'Can view league',14,'view_league'),(57,'Can add match',15,'add_match'),(58,'Can change match',15,'change_match'),(59,'Can delete match',15,'delete_match'),(60,'Can view match',15,'view_match'),(61,'Can add stadium',16,'add_stadium'),(62,'Can change stadium',16,'change_stadium'),(63,'Can delete stadium',16,'delete_stadium'),(64,'Can view stadium',16,'view_stadium'),(65,'Can add team',17,'add_team'),(66,'Can change team',17,'change_team'),(67,'Can delete team',17,'delete_team'),(68,'Can view team',17,'view_team'),(69,'Can add match history',18,'add_matchhistory'),(70,'Can change match history',18,'change_matchhistory'),(71,'Can delete match history',18,'delete_matchhistory'),(72,'Can view match history',18,'view_matchhistory'),(73,'Can add section',19,'add_section'),(74,'Can change section',19,'change_section'),(75,'Can delete section',19,'delete_section'),(76,'Can view section',19,'view_section'),(77,'Can add section price',20,'add_sectionprice'),(78,'Can change section price',20,'change_sectionprice'),(79,'Can delete section price',20,'delete_sectionprice'),(80,'Can view section price',20,'view_sectionprice'),(81,'Can add seat',21,'add_seat'),(82,'Can change seat',21,'change_seat'),(83,'Can delete seat',21,'delete_seat'),(84,'Can view seat',21,'view_seat'),(85,'Can add price history',22,'add_pricehistory'),(86,'Can change price history',22,'change_pricehistory'),(87,'Can delete price history',22,'delete_pricehistory'),(88,'Can view price history',22,'view_pricehistory'),(89,'Can add order',23,'add_order'),(90,'Can change order',23,'change_order'),(91,'Can delete order',23,'delete_order'),(92,'Can view order',23,'view_order'),(93,'Can add payment',24,'add_payment'),(94,'Can change payment',24,'change_payment'),(95,'Can delete payment',24,'delete_payment'),(96,'Can view payment',24,'view_payment'),(97,'Can add order detail',25,'add_orderdetail'),(98,'Can change order detail',25,'change_orderdetail'),(99,'Can delete order detail',25,'delete_orderdetail'),(100,'Can view order detail',25,'view_orderdetail'),(101,'Can add promotion',26,'add_promotion'),(102,'Can change promotion',26,'change_promotion'),(103,'Can delete promotion',26,'delete_promotion'),(104,'Can view promotion',26,'view_promotion'),(105,'Can add promotion detail',27,'add_promotiondetail'),(106,'Can change promotion detail',27,'change_promotiondetail'),(107,'Can delete promotion detail',27,'delete_promotiondetail'),(108,'Can view promotion detail',27,'view_promotiondetail'),(109,'Can add ticket return',28,'add_ticketreturn'),(110,'Can change ticket return',28,'change_ticketreturn'),(111,'Can delete ticket return',28,'delete_ticketreturn'),(112,'Can view ticket return',28,'view_ticketreturn');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authtoken_token`
--

DROP TABLE IF EXISTS `authtoken_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authtoken_token` (
  `key` varchar(40) NOT NULL,
  `created` datetime(6) NOT NULL,
  `user_id` varchar(15) NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `authtoken_token_user_id_35299eff_fk_employee_account_username` FOREIGN KEY (`user_id`) REFERENCES `employee_account` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authtoken_token`
--

LOCK TABLES `authtoken_token` WRITE;
/*!40000 ALTER TABLE `authtoken_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `authtoken_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `background_task`
--

DROP TABLE IF EXISTS `background_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `background_task` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_name` varchar(190) NOT NULL,
  `task_params` longtext NOT NULL,
  `task_hash` varchar(40) NOT NULL,
  `verbose_name` varchar(255) DEFAULT NULL,
  `priority` int NOT NULL,
  `run_at` datetime(6) NOT NULL,
  `repeat` bigint NOT NULL,
  `repeat_until` datetime(6) DEFAULT NULL,
  `queue` varchar(190) DEFAULT NULL,
  `attempts` int NOT NULL,
  `failed_at` datetime(6) DEFAULT NULL,
  `last_error` longtext NOT NULL,
  `locked_by` varchar(64) DEFAULT NULL,
  `locked_at` datetime(6) DEFAULT NULL,
  `creator_object_id` int unsigned DEFAULT NULL,
  `creator_content_type_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `background_task_creator_content_type_61cc9af3_fk_django_co` (`creator_content_type_id`),
  KEY `background_task_task_name_4562d56a` (`task_name`),
  KEY `background_task_task_hash_d8f233bd` (`task_hash`),
  KEY `background_task_priority_88bdbce9` (`priority`),
  KEY `background_task_run_at_7baca3aa` (`run_at`),
  KEY `background_task_queue_1d5f3a40` (`queue`),
  KEY `background_task_attempts_a9ade23d` (`attempts`),
  KEY `background_task_failed_at_b81bba14` (`failed_at`),
  KEY `background_task_locked_by_db7779e3` (`locked_by`),
  KEY `background_task_locked_at_0fb0f225` (`locked_at`),
  CONSTRAINT `background_task_creator_content_type_61cc9af3_fk_django_co` FOREIGN KEY (`creator_content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `background_task_chk_1` CHECK ((`creator_object_id` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `background_task`
--

LOCK TABLES `background_task` WRITE;
/*!40000 ALTER TABLE `background_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `background_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `background_task_completedtask`
--

DROP TABLE IF EXISTS `background_task_completedtask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `background_task_completedtask` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_name` varchar(190) NOT NULL,
  `task_params` longtext NOT NULL,
  `task_hash` varchar(40) NOT NULL,
  `verbose_name` varchar(255) DEFAULT NULL,
  `priority` int NOT NULL,
  `run_at` datetime(6) NOT NULL,
  `repeat` bigint NOT NULL,
  `repeat_until` datetime(6) DEFAULT NULL,
  `queue` varchar(190) DEFAULT NULL,
  `attempts` int NOT NULL,
  `failed_at` datetime(6) DEFAULT NULL,
  `last_error` longtext NOT NULL,
  `locked_by` varchar(64) DEFAULT NULL,
  `locked_at` datetime(6) DEFAULT NULL,
  `creator_object_id` int unsigned DEFAULT NULL,
  `creator_content_type_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `background_task_comp_creator_content_type_21d6a741_fk_django_co` (`creator_content_type_id`),
  KEY `background_task_completedtask_task_name_388dabc2` (`task_name`),
  KEY `background_task_completedtask_task_hash_91187576` (`task_hash`),
  KEY `background_task_completedtask_priority_9080692e` (`priority`),
  KEY `background_task_completedtask_run_at_77c80f34` (`run_at`),
  KEY `background_task_completedtask_queue_61fb0415` (`queue`),
  KEY `background_task_completedtask_attempts_772a6783` (`attempts`),
  KEY `background_task_completedtask_failed_at_3de56618` (`failed_at`),
  KEY `background_task_completedtask_locked_by_edc8a213` (`locked_by`),
  KEY `background_task_completedtask_locked_at_29c62708` (`locked_at`),
  CONSTRAINT `background_task_comp_creator_content_type_21d6a741_fk_django_co` FOREIGN KEY (`creator_content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `background_task_completedtask_chk_1` CHECK ((`creator_object_id` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `background_task_completedtask`
--

LOCK TABLES `background_task_completedtask` WRITE;
/*!40000 ALTER TABLE `background_task_completedtask` DISABLE KEYS */;
/*!40000 ALTER TABLE `background_task_completedtask` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `email` varchar(254) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone_number` (`phone_number`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Nguyễn Thị Huyền My','0363032808','nmhhuong3@gmail.com','2025-04-23 22:09:36.158034','2025-05-05 02:43:45.681865'),(2,'Nguyễn Thư','0123456789','n21@student.ptit.edu.vn','2025-04-24 13:08:56.809778','2025-04-24 13:08:56.809862'),(3,'Nguyễn Thái Hà','09259966465','thaiha@gmail.com','2025-04-25 04:00:29.863667','2025-04-25 04:00:29.863693'),(4,'Nguyễn Thị Huyền My','03630323323','n21dccn147@student.ptithcm.edu.vn','2025-04-25 05:11:03.854797','2025-06-12 04:00:12.779454'),(6,'Anh Thu','1234575489','minh@ptut.vn.cbd','2025-04-25 08:10:42.517681','2025-04-25 08:10:42.517718'),(8,'Trịnh Trần Phương Tuấn','0132189796','hihi@gmail.com','2025-05-02 02:10:50.747757','2025-05-05 02:49:55.412343'),(13,'Minh Thu','0912312312','n21dccn082@student.ptithcm.edu.vn','2025-05-04 02:20:15.063026','2025-05-04 02:20:15.063059'),(29,'Trieu Quoc Dat','0855831615','blinks987@gmail.com','2025-06-15 12:08:29.187942','2025-06-15 12:08:29.187981'),(33,'NGUYEN THI HUYEN MY','2435590089','test@gmail.com','2025-06-15 17:06:44.298812','2025-06-15 17:06:44.298841'),(34,'Nguyễn Phúc','01284512124','nguyenphuc32@gmail.com','2025-06-15 17:50:54.454893','2025-06-15 17:51:46.245190');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_account`
--

DROP TABLE IF EXISTS `customer_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_account` (
  `username` varchar(15) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_verified` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `customer_id` int NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `customer_id` (`customer_id`),
  CONSTRAINT `customer_account_customer_id_82794ac9_fk_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_account`
--

LOCK TABLES `customer_account` WRITE;
/*!40000 ALTER TABLE `customer_account` DISABLE KEYS */;
INSERT INTO `customer_account` VALUES ('01284512124','pbkdf2_sha256$600000$u2vncnmEzKBKMTsOfLIwxl$LNWQMOMAmHs7SwHTSnWhcaJzo5q9FUBQ5umgJX7+abQ=',0,1,34),('0855831615','pbkdf2_sha256$600000$iUFp0WUCNaplfaOwXlw3wT$dvd2z1NTyZAxFdZwFCCAYBiE9uLdtrbDSSBTb3dx5ck=',0,1,29),('1234575489','pbkdf2_sha256$600000$32CMNvd9BVrNAhAtj1Jzlf$uSxppk8o3ntA3lqLz1/1BizOBKzASa/ONzZHkmRO8rE=',0,1,6),('2435590089','pbkdf2_sha256$600000$pg7kby3rFQbcO2Y349eC8r$nMoaSzi55BADLp2JfHFqCb5XsZvaLlvmoJMkx6hEY2I=',1,1,33),('bacha','pbkdf2_sha256$600000$YzXfFPzhYuJaRvxlF7VBNa$FnrFnRyJcFWiwfzViHBWbK6J4AcR4iu4ZAeW00jAQjI=',1,1,3),('miekhumkhon','pbkdf2_sha256$600000$GH8po0qL2n6HwwqbpTs9k6$ozpL6RsHFvz5++s0rZkiNz9DeBpRtOlF6r+lgISrIoo=',1,1,1),('miemie','pbkdf2_sha256$600000$vVWQpsqPpayJFtfvedqJN5$2Ggo4GhUbQq45lfRBRA3WKenS9NZh50YkisiGZ9xLM0=',1,1,4),('miene','pbkdf2_sha256$600000$kBFUpmnPs9T7F8DgDLQjKQ$T0ntri99n7TCh4DofEKBZdx/5lzO7ZDmWeIQgEhXA2I=',1,1,8),('minhthu','pbkdf2_sha256$600000$EAqnAILunatUEQK8ZgCTCp$nVEAx1wUjlkK+tHXOFZYMyT/wSnQ6vae4GmXKP8SuDE=',1,1,2),('minhthu123','pbkdf2_sha256$600000$Ywo1mLQR7yNqXcwyqzigid$ysH+ceDjivP1WZ/pomDJ5SMnWu6D9IvMex5WB8QqiRw=',1,1,13);
/*!40000 ALTER TABLE `customer_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_employee_account_username` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_employee_account_username` FOREIGN KEY (`user_id`) REFERENCES `employee_account` (`username`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (10,'accounts','customer'),(12,'accounts','customeraccount'),(11,'accounts','employee'),(13,'accounts','employeeaccount'),(1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(6,'authtoken','token'),(7,'authtoken','tokenproxy'),(8,'background_task','completedtask'),(9,'background_task','task'),(4,'contenttypes','contenttype'),(14,'events','league'),(15,'events','match'),(18,'events','matchhistory'),(16,'events','stadium'),(17,'events','team'),(23,'orders','order'),(25,'orders','orderdetail'),(24,'orders','payment'),(26,'promotions','promotion'),(27,'promotions','promotiondetail'),(28,'returns','ticketreturn'),(5,'sessions','session'),(22,'tickets','pricehistory'),(21,'tickets','seat'),(19,'tickets','section'),(20,'tickets','sectionprice');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-04-23 22:08:09.954747'),(2,'contenttypes','0002_remove_content_type_name','2025-04-23 22:08:09.993552'),(3,'auth','0001_initial','2025-04-23 22:08:10.176696'),(4,'auth','0002_alter_permission_name_max_length','2025-04-23 22:08:10.222524'),(5,'auth','0003_alter_user_email_max_length','2025-04-23 22:08:10.228605'),(6,'auth','0004_alter_user_username_opts','2025-04-23 22:08:10.234302'),(7,'auth','0005_alter_user_last_login_null','2025-04-23 22:08:10.238917'),(8,'auth','0006_require_contenttypes_0002','2025-04-23 22:08:10.241896'),(9,'auth','0007_alter_validators_add_error_messages','2025-04-23 22:08:10.248328'),(10,'auth','0008_alter_user_username_max_length','2025-04-23 22:08:10.253042'),(11,'auth','0009_alter_user_last_name_max_length','2025-04-23 22:08:10.258132'),(12,'auth','0010_alter_group_name_max_length','2025-04-23 22:08:10.270395'),(13,'auth','0011_update_proxy_permissions','2025-04-23 22:08:10.276807'),(14,'auth','0012_alter_user_first_name_max_length','2025-04-23 22:08:10.282257'),(15,'accounts','0001_initial','2025-04-23 22:08:10.658202'),(16,'admin','0001_initial','2025-04-23 22:08:10.755899'),(17,'admin','0002_logentry_remove_auto_add','2025-04-23 22:08:10.765214'),(18,'admin','0003_logentry_add_action_flag_choices','2025-04-23 22:08:10.773309'),(19,'authtoken','0001_initial','2025-04-23 22:08:10.825313'),(20,'authtoken','0002_auto_20160226_1747','2025-04-23 22:08:10.844589'),(21,'authtoken','0003_tokenproxy','2025-04-23 22:08:10.848880'),(22,'authtoken','0004_alter_tokenproxy_options','2025-04-23 22:08:10.854132'),(23,'background_task','0001_initial','2025-04-23 22:08:11.308944'),(24,'background_task','0002_auto_20170927_1109','2025-04-23 22:08:11.326713'),(25,'background_task','0003_alter_completedtask_id_alter_task_id','2025-04-23 22:08:11.470926'),(26,'events','0001_initial','2025-04-23 22:08:11.919742'),(27,'tickets','0001_initial','2025-04-23 22:08:12.312646'),(28,'promotions','0001_initial','2025-04-23 22:08:12.587529'),(29,'orders','0001_initial','2025-04-23 22:08:12.950160'),(30,'returns','0001_initial','2025-04-23 22:08:13.096234'),(31,'sessions','0001_initial','2025-04-23 22:08:13.127151'),(32,'orders','0002_alter_order_order_id','2025-04-24 10:36:23.448608'),(33,'tickets','0002_alter_pricehistory_effective_date','2025-04-24 12:20:23.036092'),(34,'orders','0003_alter_payment_order','2025-04-25 00:32:20.756998'),(35,'orders','0004_alter_payment_order','2025-04-25 00:34:09.199738'),(36,'orders','0005_alter_orderdetail_qr_code','2025-04-25 01:12:47.886188'),(37,'events','0002_alter_stadium_stadium_layouts','2025-04-25 05:17:28.375280');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('1ei4w4spqotd42d0z5kqu5j6wnhtm8vl','.eJwNyMENwCAIAMBdmKAgYugyBkHju9ZX093be94D1fY96179qtPWhBOMGHGknJq44YFG4oUpI0e0UJdSlCMJDY-RR9fGpv91JWSOAu8HhXUZSQ:1uQiWi:lotKl28OGfBvGd9GW9_qsoUypkgXTGkP6f6eacYzuEw','2025-06-29 08:15:40.377015'),('216kro2kvxdsl9qwpeqzq4i2umqy7pto','.eJwFwcERgCAMBMBeqCCGEMRmmByE4S3ycuzd3TdU28-se_ldp60ZrkAEM1cB29mkgws7iRbJHcfInUZEy44RXYdCyXtOCRohJUrj8P2woRom:1uQiCO:SWdHHUqqLcmETNO27fs3phZ3pApOCbxbWj5cDUWzq2Q','2025-06-29 07:54:40.444640'),('3jp8r3l9pf7ypjgg1l9cr80vhila8p7m','.eJwFwcsRgCAMBcBeqIBfQmIzDIHHcBY5Ofbu7utqO8-qZ-Ouq-3lLuc5U1Qj4ZwkMBsPK9N3A3WhgSJzSDRCiUlTUzJMQgayCgLIfT-AHhmb:1uQNdp:iY7pIer9yv6pjPBWPxBiQO2b6Mtfd_k_zc7mK1y6C_0','2025-06-28 09:57:37.832088'),('3xspb29z9ngl98snbwqd14ash4jkcrhm','.eJwFwckRgCAMAMBeqAAIBGIzTMgxvEVejr27-4bB51njbLvH4r3CFbxoz2RqoOBRqrbpsyjmGEFJAFzQUhOPQFyIO9Y01Up39lkBw_cDuOkaag:1uQNeC:qUgJQrlLNfWaWhloU6ThZC1ig3IyskWupBGvBQA6U_w','2025-06-28 09:58:00.685690'),('6pld0ncb8yyqn5r57pq5hquzkk4jov8h','.eJwNysERgCAMBMBeqABIDsFmmAPJ8BZ9Ofau-97HVd7XrPcaZ51c0-1O1NIAvQgw6PMw0Ra2EArNlFG1WwHIxqNlAJL-EX3rxYJEuPcDkTUZYQ:1uQiCO:JbK-l7HsOCiTNFhDCsAVFNISxir6hvukS8BnC3TRgxY','2025-06-29 07:54:40.419649'),('b8nn6qcv6i74gpfmkcqu0d21k4nkc4bg','.eJwFwckRgCAQBMBciID7MBlqdliKt8jLMne7X9NxntXP1rsv7GUuk1ytsTK6htGQo5s-VCuJjh4CT0K1DMsZiuQpTRRzkCzMgQLz_aQAGz8:1uBOho:aSibuiTNIlRTBWDPjOWa0qWz8_8HCxaQJrMr5FplfiA','2025-05-18 02:03:48.331131'),('d09hfj7qnh8kr8ryslvupr4pjrqbutdx','.eJwNyckRgCAMAMBeUgE5BLUZJpJkeIO8HHvX_e4DVdfd65o-atfZ4YRLDuIwTKZbQUcKcXMiCwuVhqyZtQRjTty8iRkjUcZdwvl_eD-pSBnf:1uPZ9P:SF0lqmTrAHJ8wIGtDWYouEyPONZWeOjmc2Qa__s-mDw','2025-06-26 04:02:51.401262'),('fknyhdr1vig494s6q5apzlrvui68cn2i','.eJwFwUESgCAIAMC_8AITUuwzDgiM58xT09_bfaHLfmbfy-8-ZU24wAlDteREaTQj9qjIZIKKHiJnUXVOrFy9GVrmQU35iHSGmmeE7wewdBpq:1uBORt:YpUU8n7aF3sG0hESK3CTjToVxZ_LQCRzgfU-Jd99T2Y','2025-05-18 01:47:21.915185'),('fs4typbbst5rzfsout16rbofvjf0gxkx','.eJwFwcENwCAIAMBdmAARRbuMAZX4rvXVdPfevdD0PKudPe-2dC-4AHFUpqlMnky7m1WtWTIWjsXGDFGolIwSOtFQ8s6sgSiKu6Tg8P2QXhk4:1uQqNM:4IAVDZTFV6tdPqHpfU-Zo667U_nISn5h7CP1NZrU8BQ','2025-06-29 16:38:32.359764'),('ix5m9e216s4n48ble0btqozt8jwkddp9','.eJwFwckRgCAMAMBeqCAICcFmmBxkeIu-HHt3901DnnuNZ89rLNkrnSkYG04KL60KN4lGClqLiYtbIFHVHGLeMxwMLLOQOSCZRnju6fsBs70alg:1uQiBs:qYkO1WJlfSWNRpVin4YRxMyO_V1mUldidrYCr3mhEUE','2025-06-29 07:54:08.693108'),('qo8uqekadc53vrk80fhupeku884cqqk6','.eJwFwckRgCAMAMBeqCAHCWAzTCAwvEVejr27-4Zq51n17HHXZXuFK2BP2oBaZu-ihdDYaQqKkOWIDTUViE4cMwM0hunKxoIekZOP8P1l3hgw:1uQiBs:tXrSHkjsxslfun1dLhDb9DVXDBDWqYO6cSD9xHSQDzk','2025-06-29 07:54:08.693396'),('te1jzg21ap4v3gipruedba6j2kvry6r1','.eJwFwcENwCAIAMBdmAAJFOwyhoLGd62vprv37oXm-5ltr3636WvCCRyiXVCNqh8mxEaiURQFM4-iwTUYTWVooBs5X1mc00eJKqzw_VypGIk:1uPYy3:yl3c5xn0PycDlz6uPxIIktGbfE_zijvGoG_G9f7QhkY','2025-06-26 03:51:07.692025'),('vcpy4j6o9zy5uzwdqmq5ygr7af4n9fes','.eJwFwUESgCAIAMC_-AJEwOgzDimM58xT09_bfVOz_cy2l99t2prpTAZ85VGUhyggIUkFPIqpKRrgRQgUI7L0WrgDsTO69xzBwgSRvh9lJBie:1uQNeC:IQB5R4kGzIUH34RXlOlLgaZi1jSl_gykHfsEYthEqt8','2025-06-28 09:58:00.705850'),('wozncrm7w0wu2rsyg188kal0h55mr43z','.eJwFwUESgCAIAMC_8IIUQugzDgqO58xT09_bfaHafmbdK-46bU24oAs1EaESTIemkc0Kna1lZ6boPNBVTgoU5aHqmZzQGLsZl6QO3w-D2hk5:1uQqMl:_lyagjvqq2-E9BcHtAdupbLoVTy9ICltNnx9ZLcdf5U','2025-06-29 16:37:55.785402'),('x2qppryc91b157q5ltwge2sv0ryeumj4','.eJwFwckRgCAMAMBeqIAjh7EZJoZkeIu8HHt3901d9zP7Xn73qWumM2WLIwpygyFUdbRcotRgcwKxRnQ5ejG2SwBFAVm5KrYYwqDB6fsBjxkZhQ:1uQNdp:qR2VH07LKz99gGMBBf3_BLHJlU8X8ZarCMmihociVxE','2025-06-28 09:57:37.822922'),('y00ua19ubvzga7z6lb5ax05jxq1v7cjb','.eJwFwckRgCAMAMBeqAByALEZJiQwvEVejr27-4am51nt7HG3pXuFK2QhIBxxGGHtM0MEY0fWAiQ9Mqs4kVgyS9hrUaIBFQFck-fp4fsBcvIZBQ:1uBOi8:ldhX598zNts04jKfaqvT-CT6tXIYOTF2EbM3Lr-tfec','2025-05-18 02:04:08.417424'),('yza89liuwb2uej6hbjywxcas3301p9h8','.eJwFwcERgCAMBMBeqCABE9BmmASO4S3ycuzd3TdU28-se-Gu09YMVxgJKAY4uA8nbRabeyeJTKdqcWWR7NS05ANCOFrKoCHO3Zw4fD_FyxpG:1uBOSB:8GgSPsrj38KymOTn3H3Wx6ZrjU7__AdV6JzA5eyL1Lc','2025-05-18 01:47:39.956317'),('zr0cy4uh6lhsczdh859w03t6sjc1146q','.eJwNyckRwCAIAMBeqEBAUNOM44HjO8ZXJr3H7-4Luexn5r3szrOsCRd0bRUjJUQSjrWbuoRDlCViihZQ2HxAsnaAiw5fh1OmUp3iCfh-ZloYHQ:1uPYxi:3XKSDGSSWoFR2PAHP0CAbZw4ACFlbGnQCXSy29MqnPg','2025-06-26 03:50:46.137270');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) NOT NULL,
  `date_of_birth` date NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `email` varchar(254) NOT NULL,
  `citizen_id` varchar(20) NOT NULL,
  `gender` tinyint(1) NOT NULL,
  `address` longtext NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone_number` (`phone_number`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `citizen_id` (`citizen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (2,'Nguyễn Thị Minh Thư','2003-12-17','0912341213','vtktfboys9210@gmail.com','0123456789',1,'Thu Duc','employee_images/ChatGPT_Image_23_48_21_15_thg_6_2025.png','2025-04-25 07:30:34.054040','2025-06-15 16:48:41.900460'),(3,'Triệu Quốc Đạt','2003-12-11','0879879878','Blinks987@gmail.com','987654321',0,'Ho Chi Minh','','2025-04-25 07:34:24.396938','2025-05-05 00:22:11.423014'),(4,'Nguyễn Văn An','2007-05-02','0901234567','an.nguyen.admin@example.com','01234598985',0,'78 man thiện','','2025-05-03 13:52:15.541577','2025-05-03 13:52:15.541613'),(6,'Nguyễn Thảo','2007-05-04','01234567878','minhthu@gmail.com','01123351555',0,'54 Hàm Nghi','','2025-05-04 01:23:52.263043','2025-05-04 01:30:03.337005'),(8,'Nguyễn An','2007-05-04','0152345678','anguyen@it.vn.edu','011233515789',0,'78 man thiện','','2025-05-04 01:25:56.384370','2025-05-04 01:25:56.384414'),(10,'Nguyễn Anh Thư','2007-05-15','0123456789','nguyenanhthu@gmail.com','015188231545',0,'phú yên','employee_images/maomaoo_6hV8Mjl.jpg','2025-05-04 01:30:45.423974','2025-06-14 09:51:04.269281'),(11,'Anh Thu','2007-06-15','0123456777','minh@ptut.vn.cbd','01123351222',0,'Số 1, Đường Láng, Hà Nội','','2025-06-15 08:19:03.420996','2025-06-15 08:19:03.421047'),(12,'Anh Thu','2007-06-15','0123456733','minhthu@ptut.vn.cbd','011233512111',1,'Thu Duc','','2025-06-15 08:20:43.889894','2025-06-15 08:20:43.889943'),(13,'Thư Nguyễn Thị Minh','2007-06-15','0123456773','minhthutfboys9210@gmail.com','011233518888',1,'Thôn Phước Lương','','2025-06-15 08:59:22.548388','2025-06-15 08:59:46.775496'),(14,'Nguyễn Hoàng','2007-05-15','0123456712','nguyenhoang@gmail.com','015188231789',0,'Số 1, Đường Láng, Hà Nội','','2025-06-15 11:43:04.589332','2025-06-15 11:43:04.589374'),(18,'Nguyễn Tùng','2007-06-15','0122345465','mymy@gmail.com','0123456012',0,'54 Hàm Nghi','','2025-06-15 11:52:39.952268','2025-06-15 11:52:39.952322'),(21,'Nguyễn Hảo','2007-06-15','0987456321','nguyenhao@student.ptithcm.edu.vn','012345678978',0,'Thu Duc','','2025-06-15 12:06:54.779899','2025-06-15 12:06:54.779959'),(22,'Trần My','2007-06-15','0363032802','mymy2@gmail.com','01123351789',0,'65 tăng nhơn phú, phước long b, thủ đức','','2025-06-15 12:08:00.425433','2025-06-15 12:08:00.425480'),(23,'Trần My My','2007-06-15','0363032878','tranmy@gmail.com','01123351000',0,'78 man thiện','','2025-06-15 12:09:32.642958','2025-06-15 12:09:32.642999'),(26,'Nguyễn Văn An','2007-06-15','0147852369','an.nguyen589@example.com','011233510000',0,'Thôn Phước Lương','','2025-06-15 13:10:28.281026','2025-06-15 13:10:28.281063'),(27,'Nguyễn Thái Hà','2005-02-04','0425645653','ngthaiha@gmail.com','2343243244',1,'Hà Nội','employee_images/ChatGPT_Image_23_53_44_15_thg_6_2025_69FUCMa.png','2025-06-15 16:50:46.209120','2025-06-15 16:54:02.370616'),(28,'Nguyen Minh','2007-06-15','0363032821','nguyenminh@gmail.com','012345678974',0,'Thu Duc','','2025-06-15 17:42:40.181941','2025-06-15 17:42:40.181992'),(30,'Nguyen Chi','2007-06-15','0123456445','nguyenchi@gmail.com','015188231500',0,'78 man thiện','','2025-06-15 17:43:51.871995','2025-06-15 17:43:51.872023'),(32,'Minh Hoang','2007-06-15','0356520774','anhminhthu@gmail.com','012340123123',0,'Thu Duc','','2025-06-15 17:47:03.544259','2025-06-15 17:47:03.544321'),(33,'Nguyen Phuc','2007-06-15','03565207896','nguyenphuc@gmail.com','012340123789',0,'Thu Duc','','2025-06-15 17:47:55.854676','2025-06-15 17:47:55.854699'),(34,'Triệu Quốc Đạt','2006-07-12','0839452272','blinks987@gmail.com2','123443211234',0,'acd','','2025-06-16 01:59:46.131043','2025-06-16 01:59:46.131093'),(36,'Nguyen Thi Huyen My','2007-06-15','0912345678','huynmy@gmail.com','02323263262',0,'105/8','','2025-06-16 07:54:36.758557','2025-06-16 07:54:36.758602'),(40,'Nguyen Thu','2007-06-16','0124578132','nguyenthu@gmail.com','012487154812',0,'105/8','','2025-06-16 07:57:10.774135','2025-06-16 07:57:10.774157'),(42,'Nguyen Thu','2007-06-16','0121545212','nguyenthu1@gmail.com','012487154777',0,'105/8','','2025-06-16 07:57:43.911575','2025-06-16 07:57:43.911595'),(44,'Nguyễn Văn Trọng','2007-06-16','0121564887','nguyn@gmail.com','01843518798',0,'105/8','','2025-06-16 07:59:08.270766','2025-06-16 07:59:08.270786'),(46,'Nguyễn Văn Trọng Trọng','2007-06-16','0121567787','ngumauyn@gmail.com','018435187132',0,'105/8','','2025-06-16 08:00:19.610530','2025-06-16 08:00:19.610573'),(48,'Nguyễn Văn Trọng Trunh','2007-06-16','01234578112','trongtirnh@gmail.com','012484351852',0,'102/3','','2025-06-16 08:03:19.112632','2025-06-16 08:03:19.112652');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_account`
--

DROP TABLE IF EXISTS `employee_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_account` (
  `username` varchar(15) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `employee_id` int NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `employee_id` (`employee_id`),
  CONSTRAINT `employee_account_employee_id_12f15358_fk_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_account`
--

LOCK TABLES `employee_account` WRITE;
/*!40000 ALTER TABLE `employee_account` DISABLE KEYS */;
INSERT INTO `employee_account` VALUES ('01123351000','pbkdf2_sha256$600000$G3jwr8qaLNDOOMaLoMsu5l$Pex52t2qwdFiGshrJLLZ8Uh+nRi/LEM+t+CYHEnInTw=','staff',1,23),('011233510000','pbkdf2_sha256$600000$636Tc7vx4tGQm1tODszBqg$iFyyPVIE2rEhZY/1PbVgIqmlpS4soK9PnIGDv1/aW4A=','staff',1,26),('011233512111','pbkdf2_sha256$600000$CnfIz49rZEtXEfeGaBJaCe$4Rcoa+Kb+yr+iV0mkxQcCUq3F5H/CR5LRN5JPSXiSlA=','staff',1,12),('01123351222','pbkdf2_sha256$600000$MqPVd0z4pFwjzPevbeGHQn$L0NU4mP6ssYXfhzdN2YNiNiN7w+mTuMH0bwkdfNF4Sk=','staff',1,11),('01123351555','pbkdf2_sha256$600000$xtMMrlvUx9vKDh72cBYUln$1ZnS0/SNZjTQpzpqszdAsrNxyEpzwYSW09MXB34ozMc=','staff',1,6),('011233515789','pbkdf2_sha256$600000$OgydTB26SQsYkmy1s4oA3v$gJ5jkTwVYfE34z5dDQEoNLOi4gtjGJxfXfOvCXYLe+8=','staff',0,8),('01123351789','pbkdf2_sha256$600000$eHWF5wzJMgLUGVGcWMtqRG$9owWdV2OGhf87838oALpWe5ZcG1ZPzmnggyiiPe28uI=','staff',1,22),('011233518888','pbkdf2_sha256$600000$oKsLRsDUKI2mzHGwDPln4F$1ts4c/CrTGGHAuNbCnaM5KQYTF+yodQ4Jn8SLFItP4U=','staff',0,13),('012340123123','pbkdf2_sha256$600000$1jgTKVDzldRlnxpkHiUbcM$jHh07qYqO+a9TctknPl8mCLcWiAmCorJpKuq885uJf8=','staff',1,32),('012340123789','pbkdf2_sha256$600000$TU1C33XHXbibpC7sN2JH0W$FI1/0Z9i2ssQIy3tOIX1t07WkYFD+W/2mAcc0u1w91k=','staff',1,33),('0123456012','pbkdf2_sha256$600000$JOfq1gAbokqUO0YqX1WwFI$cBvF7UTWv6uFqXsP4+jhwC9X5L1XtJVYrrgxLpD73qU=','staff',1,18),('0123456789','pbkdf2_sha256$600000$LOrxte4bOuwf6NWhCAJq1n$r30rHP1C0gCUzzHTvPFe2NqPQX4YrgFzCruQHX2a5Fc=','admin',1,2),('012345678974','pbkdf2_sha256$600000$gmnTgp1qTl23OGn1sdJ9VD$qtBRdqzVD00KYS3FptQ+YoCDPqiWeaZhTC9dY86ULhc=','staff',1,28),('012345678978','pbkdf2_sha256$600000$HkXpQM805PxddBdguDFAV4$zbkag65B55DiuW2K1HWN/gFW6BsCEOjFRIpZ2BqTI0Y=','staff',1,21),('01234598985','pbkdf2_sha256$600000$3YpbNdC5ancxXpeKj4Cz9j$A1VOzHc49ic08B7QqdYzAY7LMj+lB341/OOG98PO2wA=','staff',0,4),('012484351852','pbkdf2_sha256$600000$5TfSOBNeFqqBxPFxtV6tYg$eKX/veLBzcPgetEa6tEACbiKZDh3vd+aKfyPud+Z/gw=','staff',1,48),('012487154777','pbkdf2_sha256$600000$HGjT1QxVYXxtoUrHxDlKAV$dpd5hctj7Eqnx9Wammx9if2hon2+wvU0Gyax9PPiWFo=','staff',1,42),('012487154812','pbkdf2_sha256$600000$H6s0xMKN5Och9QQ4JhapCn$zY5Hi+buNx8pExXz/LVOT9lvw9IWVXQlTFXbw1hmAqE=','staff',1,40),('015188231500','pbkdf2_sha256$600000$HE1Patj1QmqAivdybvnu3p$Ihuqr0LU7tMX7x91kfwuQsZlsQ0Ys4EppBPfX34Q6Rw=','staff',1,30),('015188231545','pbkdf2_sha256$600000$GEuG7XwoevJwbDMDl3R7YF$yzs9ZCUEvP75uzlO+y0LnzBEwp3gAe9gm1b/FYkjCik=','staff',0,10),('015188231789','pbkdf2_sha256$600000$vQwE4gplYFg5Vo7AAmXBpD$gQ2omHiyR4v5Aum1D/QqK140E/+VuUvOjyaPHcFfeng=','staff',1,14),('018435187132','pbkdf2_sha256$600000$8XQONqgs3eTyY7VVmFCGWE$2Voq8ldu953oVQ3bTKy0u+GcSKqDygTQrRvbw5YPkOI=','staff',1,46),('01843518798','pbkdf2_sha256$600000$l7nndEKxnWgT6HTCpMn5eI$A5b8YOYICU4qo5/mesj74cZOW4+5uQw2NNqglLHkBPM=','staff',1,44),('02323263262','pbkdf2_sha256$600000$U638SsU5zszxGIeTXRrgmY$ig94kPfc0I9BD8PBqXB7LjvhMymt0niQzPy5UZWCC0M=','staff',1,36),('123443211234','pbkdf2_sha256$600000$uTz2i0Di5fx2CQc7M7C4AT$k/ceN8E/z7SKrZEsWFMK86/r60+n0z9GoCpDR8Mbxv4=','staff',1,34),('2343243244','pbkdf2_sha256$600000$ZsMoE3e8l26hBZGCGwjzRW$YxYyLCPZRVk/ksoCSf38GGAOHnKjIsH3yCrqBMQ1Wq8=','admin',1,27),('987654321','pbkdf2_sha256$600000$NqinUdKW0FYxKOcFHzylxp$6LYD5ZrVnDPsrkyN3F2jZvThbS3+Dra5XFVxxBt2Hdk=','staff',1,3);
/*!40000 ALTER TABLE `employee_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_account_groups`
--

DROP TABLE IF EXISTS `employee_account_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_account_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employeeaccount_id` varchar(15) NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_account_groups_employeeaccount_id_group_a6becb80_uniq` (`employeeaccount_id`,`group_id`),
  KEY `employee_account_groups_group_id_6c057951_fk_auth_group_id` (`group_id`),
  CONSTRAINT `employee_account_gro_employeeaccount_id_98d6cf58_fk_employee_` FOREIGN KEY (`employeeaccount_id`) REFERENCES `employee_account` (`username`),
  CONSTRAINT `employee_account_groups_group_id_6c057951_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_account_groups`
--

LOCK TABLES `employee_account_groups` WRITE;
/*!40000 ALTER TABLE `employee_account_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `employee_account_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_account_user_permissions`
--

DROP TABLE IF EXISTS `employee_account_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_account_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employeeaccount_id` varchar(15) NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_account_user_pe_employeeaccount_id_permi_1c19e578_uniq` (`employeeaccount_id`,`permission_id`),
  KEY `employee_account_use_permission_id_76808304_fk_auth_perm` (`permission_id`),
  CONSTRAINT `employee_account_use_employeeaccount_id_b6d3e5cd_fk_employee_` FOREIGN KEY (`employeeaccount_id`) REFERENCES `employee_account` (`username`),
  CONSTRAINT `employee_account_use_permission_id_76808304_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_account_user_permissions`
--

LOCK TABLES `employee_account_user_permissions` WRITE;
/*!40000 ALTER TABLE `employee_account_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `employee_account_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `league`
--

DROP TABLE IF EXISTS `league`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `league` (
  `league_id` int NOT NULL AUTO_INCREMENT,
  `league_name` varchar(255) NOT NULL,
  `league_type` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`league_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `league`
--

LOCK TABLES `league` WRITE;
/*!40000 ALTER TABLE `league` DISABLE KEYS */;
INSERT INTO `league` VALUES (12,'Champions League',1,'2025-05-06','2025-08-15','2025-05-03 14:07:33.408136','2025-06-16 03:34:33.995999'),(15,'Primer',0,'2025-05-06','2025-08-07','2025-05-05 01:42:59.750272','2025-05-05 01:42:59.750310'),(17,'Champion League2',1,'2025-05-08','2025-08-15','2025-05-05 02:16:40.193906','2025-05-05 02:16:40.193928'),(18,'GIAIDAU1',0,'2025-06-12','2025-10-11','2025-06-12 03:25:04.526191','2025-06-12 03:25:04.526235'),(19,'GIẢI MENSHIP',2,'2025-06-15','2025-10-11','2025-06-15 09:01:31.514226','2025-06-15 09:01:45.475568'),(20,'Laliga',1,'2025-06-01','2025-09-30','2025-06-16 03:13:04.861063','2025-06-16 03:13:04.861115');
/*!40000 ALTER TABLE `league` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match`
--

DROP TABLE IF EXISTS `match`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `match` (
  `match_id` int NOT NULL AUTO_INCREMENT,
  `match_time` datetime(6) NOT NULL,
  `description` longtext NOT NULL,
  `round` varchar(100) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `league_id` int NOT NULL,
  `stadium_id` int NOT NULL,
  `team_1_id` int NOT NULL,
  `team_2_id` int NOT NULL,
  PRIMARY KEY (`match_id`),
  UNIQUE KEY `unique_match_time_stadium` (`match_time`,`stadium_id`),
  UNIQUE KEY `unique_league_round_teams` (`league_id`,`round`,`team_1_id`,`team_2_id`),
  KEY `match_stadium_id_b9015059_fk_stadium_stadium_id` (`stadium_id`),
  KEY `match_team_1_id_56ede6da_fk_team_team_id` (`team_1_id`),
  KEY `match_team_2_id_1d4fec35_fk_team_team_id` (`team_2_id`),
  CONSTRAINT `match_league_id_23bb3dec_fk_league_league_id` FOREIGN KEY (`league_id`) REFERENCES `league` (`league_id`),
  CONSTRAINT `match_stadium_id_b9015059_fk_stadium_stadium_id` FOREIGN KEY (`stadium_id`) REFERENCES `stadium` (`stadium_id`),
  CONSTRAINT `match_team_1_id_56ede6da_fk_team_team_id` FOREIGN KEY (`team_1_id`) REFERENCES `team` (`team_id`),
  CONSTRAINT `match_team_2_id_1d4fec35_fk_team_team_id` FOREIGN KEY (`team_2_id`) REFERENCES `team` (`team_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match`
--

LOCK TABLES `match` WRITE;
/*!40000 ALTER TABLE `match` DISABLE KEYS */;
INSERT INTO `match` VALUES (55,'2025-05-03 14:15:00.000000','Trận 1','Chung kết','2025-05-03 14:10:19.233687',12,11,11,12),(56,'2025-05-25 14:12:00.000000','Trận 2','Bán kết','2025-05-03 14:13:08.352510',12,11,12,11),(58,'2025-05-17 14:20:00.000000','Trận 3','Tứ kết','2025-05-03 14:20:20.981574',12,11,11,12),(60,'2025-05-10 03:00:00.000000','Siêu Kinh','Chung kết','2025-05-04 23:57:20.722421',12,12,11,13),(62,'2025-05-15 00:39:00.000000','Trận 4','Bán kết','2025-05-05 00:39:38.814257',12,11,12,13),(63,'2025-05-08 01:10:00.000000','Trận 5','sơ loại','2025-05-05 01:11:10.022902',12,11,12,13),(65,'2025-06-20 09:36:00.000000','Trận giao lưu','Vòng sơ loại','2025-06-08 09:36:33.350999',12,13,12,11),(66,'2025-06-28 12:39:00.000000','Trận đấu hay nhất','Vòng 4','2025-06-12 03:33:47.808165',15,12,12,11),(67,'2025-06-15 01:49:00.000000','Trận ngày 18.9','Vòng 3','2025-06-12 05:43:30.981639',18,12,14,13),(68,'2025-06-21 06:30:00.000000','Trận ngày 21','Vòng 6','2025-06-12 06:31:02.390341',18,11,11,14),(75,'2025-06-18 09:05:00.000000','Trận Việt Nam','Giao hữu trong nước','2025-06-15 09:06:19.871124',19,14,15,14),(76,'2025-06-20 05:36:00.000000','Trận 2','sơ lo?i','2025-06-16 05:36:36.414319',12,12,11,14),(77,'2025-06-28 06:18:00.000000','Trận dat tao','Giao hữu quốc tế','2025-06-16 06:18:47.576493',19,12,11,16),(78,'2025-06-20 07:31:00.000000','Siêu Kinh điển','Bán kết','2025-06-16 07:32:01.920032',12,12,16,17),(79,'2025-06-28 07:33:00.000000','Darby thành Man','38','2025-06-16 07:34:11.973106',15,13,13,17),(80,'2025-06-16 08:58:00.000000','Trận test1','sơ loại','2025-06-16 08:57:08.185253',12,11,11,12);
/*!40000 ALTER TABLE `match` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match_history`
--

DROP TABLE IF EXISTS `match_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `match_history` (
  `m_history_id` int NOT NULL AUTO_INCREMENT,
  `changed_at` datetime(6) NOT NULL,
  `change_type` varchar(50) NOT NULL,
  `old_value` json NOT NULL,
  `new_value` json NOT NULL,
  `reason` longtext NOT NULL,
  `employee_id` int NOT NULL,
  `match_id` int NOT NULL,
  PRIMARY KEY (`m_history_id`),
  KEY `match_history_employee_id_05267eb5_fk_employee_id` (`employee_id`),
  KEY `match_history_match_id_549c7b05_fk_match_match_id` (`match_id`),
  CONSTRAINT `match_history_employee_id_05267eb5_fk_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`),
  CONSTRAINT `match_history_match_id_549c7b05_fk_match_match_id` FOREIGN KEY (`match_id`) REFERENCES `match` (`match_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_history`
--

LOCK TABLES `match_history` WRITE;
/*!40000 ALTER TABLE `match_history` DISABLE KEYS */;
INSERT INTO `match_history` VALUES (1,'2025-06-15 11:51:31.714525','update','{\"match_time\": \"2025-06-16 18:32:00\", \"description\": \"Trận đấu hay\"}','{\"match_time\": \"2025-06-20 18:00:00\", \"description\": \"Trận đấu hay\"}','Test Thay doi tran dau',2,66),(2,'2025-06-15 12:05:19.649995','update','{\"match_time\": \"2025-06-18 05:42:00\", \"description\": \"Trận ngày 18\"}','{\"match_time\": \"2025-06-20 19:00:00\", \"description\": \"Trận ngày 18.1\"}','MY OI',2,67),(3,'2025-06-15 12:11:23.431935','update','{\"match_time\": \"2025-06-20 11:00:00\", \"description\": \"Trận đấu hay\"}','{\"match_time\": \"2025-06-21 19:15:00\", \"description\": \"Trận đấu hay\"}','test Dat',2,66),(4,'2025-06-15 12:15:38.092109','update','{\"match_time\": \"2025-06-20 12:00:00\", \"description\": \"Trận ngày 18.1\"}','{\"match_time\": \"2025-06-21 19:00:00\", \"description\": \"Trận ngày 18.2\"}','Thu & My',2,67),(5,'2025-06-15 12:15:52.723238','update','{\"match_time\": \"2025-06-21 12:00:00\", \"description\": \"Trận ngày 18.2\"}','{\"match_time\": \"2025-06-22 19:00:00\", \"description\": \"Trận ngày 18.2\"}','Thu & My',2,67),(6,'2025-06-15 12:18:07.777397','update','{\"match_time\": \"2025-06-21 12:15:00\", \"description\": \"Trận đấu hay\"}','{\"match_time\": \"2025-06-22 19:15:00\", \"description\": \"Trận đấu hay\"}','test Dat2',2,66),(7,'2025-06-15 12:20:12.220050','update','{\"match_time\": \"2025-06-22 12:00:00\", \"description\": \"Trận ngày 18.2\"}','{\"match_time\": \"2025-06-23 19:00:00\", \"description\": \"Trận ngày 18.3\"}','test Dat3',2,67),(8,'2025-06-15 12:22:52.151555','update','{\"match_time\": \"2025-06-23 12:00:00\", \"description\": \"Trận ngày 18.3\"}','{\"match_time\": \"2025-06-24 19:22:00\", \"description\": \"Trận ngày 18.4\"}','My',2,67),(9,'2025-06-15 12:28:54.199374','update','{\"match_time\": \"2025-06-24 12:22:00\", \"description\": \"Trận ngày 18.4\"}','{\"match_time\": \"2025-06-25 19:28:00\", \"description\": \"Trận ngày 18.5\"}','haha',2,67),(10,'2025-06-15 12:32:26.821341','update','{\"match_time\": \"2025-06-25 12:28:00\", \"description\": \"Trận ngày 18.5\"}','{\"match_time\": \"2025-06-25 19:28:00\", \"description\": \"Trận ngày 18.6\"}','haha',2,67),(11,'2025-06-15 12:33:44.527028','update','{\"match_time\": \"2025-06-22 12:15:00\", \"description\": \"Trận đấu hay\"}','{\"match_time\": \"2025-06-27 19:33:00\", \"description\": \"Trận đấu hay\"}','test Dat3',2,66),(12,'2025-06-15 12:39:24.895022','update','{\"match_time\": \"2025-06-27 12:33:00\", \"description\": \"Trận đấu hay\"}','{\"match_time\": \"2025-06-28 19:39:00\", \"description\": \"Trận đấu hay nhất\"}','ahahaha',2,66),(13,'2025-06-15 12:41:38.358026','update','{\"match_time\": \"2025-06-28 12:39:00\", \"description\": \"Trận đấu hay nhất\"}','{\"match_time\": \"2025-06-28 19:39:00\", \"description\": \"Trận đấu hay nhất\"}','ahahaha',2,66),(14,'2025-06-15 12:43:28.753575','update','{\"match_time\": \"2025-06-25 12:28:00\", \"description\": \"Trận ngày 18.6\"}','{\"match_time\": \"2025-06-28 19:42:00\", \"description\": \"Trận ngày 18.7\"}','hahahah',2,67),(15,'2025-06-15 12:45:24.700493','update','{\"match_time\": \"2025-06-28 12:42:00\", \"description\": \"Trận ngày 18.7\"}','{\"match_time\": \"2025-06-28 19:45:00\", \"description\": \"Trận ngày 18.8\"}','hshahaha',2,67),(16,'2025-06-15 12:49:17.130168','update','{\"match_time\": \"2025-06-28 12:45:00\", \"description\": \"Trận ngày 18.8\"}','{\"match_time\": \"2025-06-28 19:49:00\", \"description\": \"Trận ngày 18.9\"}','hahah',2,67);
/*!40000 ALTER TABLE `match_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `order_id` char(32) NOT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `order_status` varchar(50) NOT NULL,
  `order_method` varchar(50) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `order_user_id_e323497c_fk_customer_id` (`user_id`),
  CONSTRAINT `order_user_id_e323497c_fk_customer_id` FOREIGN KEY (`user_id`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES ('03ef3180572949f4b15344aed2e7be51',1000000.00,'cancelled','online','2025-06-13 19:18:56.636025',3),('0584432255674fbb95f7ac3ee7ea5cea',2500000.00,'cancelled','online','2025-06-14 10:40:28.648327',1),('063866157c2142e6ac55001bd834de9f',1900000.00,'received','online','2025-06-16 07:19:15.771556',1),('07e8e8dad1684914b116055e5e0d208a',1100000.00,'received','online','2025-06-15 12:58:05.298023',1),('0d95d00884114cd287435a8ba7dfa63e',1185000.00,'received','online','2025-06-15 10:04:20.787562',1),('10aff3e0b89e4202a9ed3a3db3b05bb1',293000.00,'received','offline','2025-05-05 02:15:15.479292',2),('159e511a85de4897b5a8dbb1bec48133',1250000.00,'received','offline','2025-06-16 04:50:08.426078',2),('1d9af26a28d647ac8c299c612fcb9b9b',85500.00,'cancelled','online','2025-05-05 01:04:36.471917',1),('1e33d6d7be984e748618ae9b49b41f64',1900000.00,'received','offline','2025-06-16 04:59:12.630330',2),('20d85a309fd0407f8a759ac334fa2953',1185000.00,'received','offline','2025-06-13 14:13:35.754849',3),('25331d41f10c49f48d36419c3899b286',3600000.00,'cancelled','online','2025-06-14 10:04:45.345952',1),('29a92e1c499b454e97c6fb99edb313d8',1000000.00,'cancelled','online','2025-06-13 18:58:06.104909',3),('32bcfebdbb234c27935c72985a1a9a6e',1100000.00,'cancelled','online','2025-06-14 07:38:01.310766',3),('33f7af899a5e490c9e5b5e0b5cc01baf',1200000.00,'received','online','2025-06-14 10:02:03.014332',1),('3a9004bb1c4d4ffa9d71952e2cea24ae',1200000.00,'cancelled','online','2025-06-14 10:41:54.437555',1),('3bf476b367074012b31fd912b02eafa3',1185000.00,'cancelled','online','2025-06-12 03:58:42.410646',1),('3d80bee55cf94a8aa0a68611de2524d0',1100000.00,'received','online','2025-06-13 19:47:45.619129',3),('3fead25b3521446bbbcf62c7fe0f178a',1100000.00,'cancelled','online','2025-06-16 03:56:02.644494',1),('43dd74ce2920465c826dffcebd7615b9',3000000.00,'received','online','2025-06-13 18:22:58.037361',1),('4bdfd197cedb4be6aced562fedac9002',970000.00,'received','online','2025-06-16 07:49:56.455881',1),('50a1da5aa0344a2980ce228aca912e37',2200000.00,'received','online','2025-06-12 06:34:11.335669',3),('52899571a1b9469c84d8599b61ed3f8e',1700000.00,'cancelled','offline','2025-06-14 08:03:34.330197',2),('5452ca00c3ed4821a959701f8e476aab',3600000.00,'cancelled','online','2025-06-14 10:40:22.411892',1),('55459939c33f41f1a9cc8ab511f6eb92',3000000.00,'cancelled','online','2025-06-14 10:39:53.967040',1),('59453bee67724d33b7abf32e509198fa',3000000.00,'cancelled','online','2025-06-16 03:55:52.782369',1),('5d691b4469ce4eee8a257a149e5f6108',1200000.00,'cancelled','offline','2025-06-12 03:53:15.811976',6),('63a8ec2306ef413caf1e32f5f4073f08',2720000.00,'received','online','2025-06-12 06:21:14.033106',1),('69250b87dd6e454298fbaaccd5e631f8',1185000.00,'received','online','2025-06-13 18:57:04.621730',3),('6a7a5bb6633645f6a9327d9cbce66e6f',6800000.00,'cancelled','online','2025-06-16 03:55:12.781538',1),('6b81645fc7224ba49d0fdf1b23881e04',5300000.00,'cancelled','online','2025-06-16 09:00:50.355450',1),('703725af5e1e432a964ab26180aceb25',1360000.00,'cancelled','online','2025-06-16 03:55:28.647220',1),('704840b6875845d8904b2e88aebde7d5',1235000.00,'received','online','2025-06-15 10:09:59.910737',1),('710a22c3a03e4ebb8fb5ed565a219382',90000.00,'cancelled','online','2025-05-05 00:58:44.911391',1),('71282673a9b44e2fb99c22d589ccb5b7',3800000.00,'cancelled','online','2025-06-14 10:40:49.787147',1),('74018f94cf6d4183b4eca11474060dbc',1250000.00,'cancelled','online','2025-06-16 03:54:46.678008',1),('77182d73dbf64736933e04948c0a22ad',2720000.00,'cancelled','online','2025-06-14 10:41:09.269535',1),('785ed697f13749318c72fa13bb71b7fc',1185000.00,'cancelled','online','2025-06-12 04:02:42.166481',1),('7c0aac36e51c4d6ebce0c6da6345a69c',1200000.00,'received','offline','2025-06-15 12:09:48.032415',29),('7ebeb4033859429c86b8ba328cfda1e9',3800000.00,'cancelled','online','2025-06-16 03:55:21.057694',1),('981a9da6634849e9829a418cd7fec6ec',1200000.00,'received','offline','2025-06-12 03:23:36.710059',3),('9dda0ccabfb44aa2b795a6d6683177cb',1100000.00,'received','online','2025-06-13 19:50:58.279341',3),('a3dc667fa4c24d59afbb3ea7e3d077b7',7500000.00,'received','online','2025-06-12 04:28:04.976930',1),('b0c14698e72f4ad2aa7df8aa033e31c8',172900.00,'cancelled','online','2025-05-05 01:59:28.302162',1),('b2d0874a3b9a46669dca939339866671',2370000.00,'cancelled','online','2025-06-12 03:56:50.555661',1),('b9902886aba94b6bb9bcfc17bb424b11',2000000.00,'received','online','2025-06-12 06:32:24.252184',3),('bb4f1063ed3f42ce9c6c32edd2e1d3f5',1185000.00,'received','offline','2025-06-14 08:02:39.557467',1),('bb89d1ceff6d44e2b56f44ea2d9fc4ad',3000000.00,'received','online','2025-06-16 08:48:12.128164',1),('bc6d9f603bd54979a9ab8341a7e6bb1f',1100000.00,'received','offline','2025-06-16 04:55:36.349917',2),('bd816f3674854f209e26abc984b9c29d',1292000.00,'received','offline','2025-06-15 09:11:36.492966',3),('bdf3dcab635240f89e1e75e856fa0a3e',2200000.00,'cancelled','online','2025-06-12 06:34:11.575975',3),('bf0e938e5a6042c0bea1cf4ece269c7a',3400000.00,'received','online','2025-06-12 06:28:14.038942',3),('c1b19006b7a840179de06ffba08830eb',3400000.00,'received','offline','2025-06-15 13:16:42.712764',1),('d15936ece09a40a29821ac0728543a79',338000.00,'received','online','2025-05-05 02:51:01.058287',8),('d1713e6aa2f24639bd967e6f5a819c09',4080000.00,'received','online','2025-06-12 06:24:31.566776',1),('d1d5aa4a79214a9ebd60bcf8a087e899',1360000.00,'received','offline','2025-06-16 04:56:06.029191',2),('d2e41d82bebf4aa683a8281e7b060f6b',2370000.00,'cancelled','online','2025-06-12 04:43:49.813757',1),('d7237cdbb58543a8bc6e17511f47a744',485920.00,'received','online','2025-05-05 02:06:15.471729',1),('db74d1397e854d118a44e8c6a6d6381b',1200000.00,'received','online','2025-06-12 04:05:24.832881',1),('dc39e80b27fe4433856710d3271c8b1e',2370000.00,'cancelled','online','2025-06-12 03:48:53.180659',1),('dc68ab73cda84eaca4549e3b50ebc2e7',3300000.00,'cancelled','online','2025-06-14 10:40:07.330871',1),('dc83d42260124a598569a29301822942',2500000.00,'cancelled','online','2025-06-14 10:04:54.938177',1),('de1c862036c94e3d8dc67c0e4ba1fbcc',3000000.00,'received','online','2025-06-12 04:24:13.886612',1),('dea3e8651b8c43a5b5a0221c36348549',1000000.00,'received','online','2025-06-13 19:42:29.408294',3),('df800a0388ed4bb6b8bcea1ffa243cf3',2370000.00,'received','offline','2025-06-15 08:04:52.712703',1),('e9d42e6bdabd4d41a900862762ea2234',1500000.00,'received','online','2025-06-13 18:29:40.703608',3),('ef68868550a743ada81e15bfdb03d249',1100000.00,'received','offline','2025-06-15 17:18:23.759314',33),('fa8fc272854b473fa2e1ba47ae9a4add',1000000.00,'cancelled','online','2025-06-13 19:05:21.408968',3),('fb0bad6b219040e2a4a99594466fc400',6800000.00,'cancelled','online','2025-06-14 10:40:41.350745',1);
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `detail_id` int NOT NULL AUTO_INCREMENT,
  `qr_code` longtext,
  `price` decimal(10,2) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `order_id` char(32) NOT NULL,
  `pricing_id` int NOT NULL,
  `promotion_id` int DEFAULT NULL,
  `seat_id` int DEFAULT NULL,
  PRIMARY KEY (`detail_id`),
  UNIQUE KEY `unique_order_seat` (`order_id`,`seat_id`),
  KEY `order_detail_pricing_id_461608fe_fk_section_price_pricing_id` (`pricing_id`),
  KEY `order_detail_promotion_id_30d78bbe_fk_promotion_promo_id` (`promotion_id`),
  KEY `order_detail_seat_id_e767a2f0_fk_seat_seat_id` (`seat_id`),
  CONSTRAINT `order_detail_order_id_b97dfbdf_fk` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`),
  CONSTRAINT `order_detail_pricing_id_461608fe_fk_section_price_pricing_id` FOREIGN KEY (`pricing_id`) REFERENCES `section_price` (`pricing_id`),
  CONSTRAINT `order_detail_promotion_id_30d78bbe_fk_promotion_promo_id` FOREIGN KEY (`promotion_id`) REFERENCES `promotion` (`promo_id`),
  CONSTRAINT `order_detail_seat_id_e767a2f0_fk_seat_seat_id` FOREIGN KEY (`seat_id`) REFERENCES `seat` (`seat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=413 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (293,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADCUlEQVR4nO2cTW6jQBBGXw1IXoKUA/go7ZuN5khzAziKDzASvYzU6JtF0QRnl0kEGVO9QAbz5EJu189X3Tbx4TH++DgDAQUUUEABBRTQc0K2jBbGHiCb2Y3ZGPvZ/NTMzG6HmBfQjhCSJJIkaWoEXYGkggYaf4M0NdrcN3zzZwroK6C8OAANuUUDLNPiVz8bAO5BjjIvoN2g9t250f1pfQ6MNyBNyL7kkwL6P6D3M0Lkiyz9finQ/WkFcyvyUeYFdBjUSRoAuwGM11cj3S8ys4trWJLKceYFtDc0mplZX6+m+0V2A0gT2I3ZS42jzAto76jxJmULCtC9+revsW/Q9oZ9zQtod2ipPgH3B0AjDfXg1SddQUNX/OaoPp8aqnrE1Mi/86EreFohFaQJL0alCUKPeH6o+ohOwt1DJ5E8i3w4TQofcQZom0ekAQzaArlH5N7k7y6n+5sX0O5Q/dl3SzKhodahQLOGk8VRhI94fmidEWWrOHi6AEtakSbwrkfkEU8PbfIILy5gaXdtUk4fE+EjTgNpyC3e9oTZpHsL5Bb9uhbXrxj7Rg/QfuYFdEDUYIkLW7GaRrXmXENH+Ihnh6gh4UGPSDVMVL8R6yNOA3n1aYCJ3GLe/s49gqZYGhAwm8bbKmZ/82cK6POQtz1/bgJGHWMPjL5Yplm6X//HMwX0BVGDVY+ooWN7WKuOiBrPDK3rLMvmFUviUDYtjbrSLmbEk0MPM2KqHU9vdj50QUOPOAm0ClHbVdnVZaxpRVei93k2qCvYLZstulQPLkklSZBbzK6xqu4MUM0s6/CLqx7hjmJNLyNqnAXa7OlKU+MCBHTSsksjtyzXDjEvoP2hN6cw+IW1h1ETTciX0CNOBNU9XWbX4nmEL81OE0una9GzjzEvoN2g9zt4gLkF2iKyofFagG7CyC8lVOwzQvkikl4NDxi5hXQ30xB5xCmg6iM6wWYzX+6xNBQMZhMIS7+bGja++TMF9Blou18D1nVzb0v0/R8EpNivcRLI4p/JAgoooIACCiigf4T+AvB4jDdJjb6IAAAAAElFTkSuQmCC',90000.00,'2025-05-05 00:59:23.538993','710a22c3a03e4ebb8fb5ed565a219382',273,NULL,65),(294,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADBklEQVR4nO2cXWrcMBRGz60N8yhDFpClyDvokkqXlB3YS8kCAvZjQObrgyTbmRZKSfEE+/phQDM6IDF3Pt0/jYl/fsZv/86AQw455JBDDjl0TsjK08LYAcxm1s9mZt1ieWhmZv1DlufQgRCSJKIkaWoEIUFUQgPN7oPdvOGL78mh/wHNRQA0zC0aAOIE+mkt1gNZQR61PIcOg9q7sRHeWgNg7DHin6LTL74nhz4D3VuEmG+y+PKUILy1gqUV86OW59DDoCBpAKwHGJ/fjfh6E6PdskpISo9bnkNHQ6OZmXX13fh6k/WA/ZjAepYcajxqeQ4dfWpszoIgAeHdILybxg7TfsKxy3PocKhEn0AOLoBGGmikIag8Q0jkF3n0eXZoZxHZBIaQyG6FJlYrgTJ0izg7VH72mooyQJCI2Yv8MIxyjbgCVC1iS0jSKCenNFXdyDnLCbeIq0FzC4SEfnZg1jUivrZAeDfrg0efV4D2p4aUiuNQ1AJymQOaUvVwP+L00GoR2zul3LUdJ/Xo8FPjClD9kmvFsxjDVIOLIg/kUqhbxPmhXV1DozVi/A4GYNAkYDEIqbU4daajl+fQ4VDtj5igpiIStSuizoneH3EdaKcRBjfBfJMxd6hoBBghwdivyewvvieHPgNVP4ISa2gI+piPSFU88FjjCtAaUpRkwy6VHddjohws7lleAdr7EaqxBqySsRY3SqedW8TZobXzdp+cyiHoVubI8ybPR1wB+qgRa11jq2ptdfEJ14gLQDXWCMrRBFGgsXuD8fuERYHlDEVIdfIX35NDn4H2yerd+VHzEVsWYvMxXSMuAO3udJUeqsWyCzGaWSmKsnif5XWgTRSGuZgFsNRrfSGRU1f9Y5bn0PFQvdNl9pzy5c/SH6FVKLw/4hLQ/Q0e4osBtEnMhpifEnFYWpifkmexzw/9ZhHjswAWEzTJCKkURZkXr31eAPrtbnjcuqnyBfG7NiuPNU4O7e9rFH+y+dii3+xq5W4R54dMf59z//g/kznkkEMOOeSQQwC/ABpauxDLoUrSAAAAAElFTkSuQmCC',85500.00,'2025-05-05 01:05:07.174063','1d9af26a28d647ac8c299c612fcb9b9b',273,6,65),(295,NULL,86450.00,'2025-05-05 01:59:28.314745','b0c14698e72f4ad2aa7df8aa033e31c8',273,6,65),(296,NULL,86450.00,'2025-05-05 01:59:28.318691','b0c14698e72f4ad2aa7df8aa033e31c8',273,6,89),(297,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC+0lEQVR4nO2cwY3bMBBF34QCfKSALWBLkTpISUFKSgdSKe5AOhqg8XMgKcvJadeJ5ZVGB0OS9WASpod/Poc28eFj/PZxBhxyyCGHHHLIoX1CVo4GxhZgNrOeq5WzuT7Qb9I8h54IIUmikyRNQRATdEpoiBLE8sbqueHF++TQv4DmEgA0zA0aALqJfGY9kCPIVs1zaDPI+pjKtz9ak4fF//kkh74GJJ1PopuC6HTJYiKHjJdonkNPg6J0myEY3y8GBDHaKXtYktJ2zXPo2dBoZmZtvdudT7J+LrOG9VxzqrFV8xx6HpTV4s3KFiQgXgy4GmOLQbz3ul+8Tw49ApXsE1hUZJCG+kI3BWmIifwizz73DtUREaXqQiSKC7FcdlOQNIH7EfuHys9eU1BJKerYKK5V9aXyePEYsXuouE7j9wTECWNuEswtYn5LRpzQaCGJuX1+8xx6OnQfI4I01DwUVjrCY8RhoEVZhiomJqpcgEVHQF71cB2xe2hRlglpYlnfqvEgB4U6VDxG7B9aVq+CrNgO10bMDRThEBLddG00tqGali/eJ4cegerPnlCnjtURVLxrjxHHgWp9RC2NKMIhq836zDIYXEfsH6qzRkxo7BuMGGQ5+yQk6369JSA1Bovb/eJ9cuhxSMPcUPTkuVm9rZ/vCchVNEHWb9I8hzbwI5ZpYlnIKE7lraCunvmssWvobqVLqlKyisqVHzEsj/iI2DO0Vpbli18WO1f5R/Bc42hQvFguwwaoxmWirn6lVQ3ul+mTQ49A2ZJqsD6msmljbMF+6FI2bdi7V9UdAbpTltXPvvkRWVZ0ixXhs8ZBoNWeriIcrgZRKvfmhnJvk+Y59HxoFRQmFlEJlEXRBMwn9yMOBNU9XbkCe2whl2Z3SrlSe6U7v0qfHPoM1Px5Ixdf0yQxGxoNanHVW3IX+5BQ2c4FBOXUozubaXAdcQjo773h3DKMxO0yW1eea+weWrvYJTxItxL9u8UNr7M8AmT+z2QOOeSQQw455NAnod9/rIpaK3Hz3AAAAABJRU5ErkJggg==',86450.00,'2025-05-05 02:06:55.559518','d7237cdbb58543a8bc6e17511f47a744',273,6,65),(298,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC+ElEQVR4nO2cwY3bMBBF30QEfJQ72FLkDlJSkJLSgVSKC1iAPAaQ8HMgKdF7CRbO2o40OhiSpQeT8OBz/gxtE58+pm+fZ8AhhxxyyCGHHNonZOUImJ0BkpldWKycpfrA5SnDc+jx0CBJiiBFADppTCdBP5dLSbqFHjc8hx4PpSIAdmExs7c5n0E6SSNgZuF5w3PoedB0Bkhm+nnuskbY5Us+yaH/BEoBSTPAYiVAvuaTHHpFqK4EvYAEmr5HgE42xDM2xPJAW8l68Tk59A+gyczMzmA/rgG7pADQCfLZkq3Gs4bn0KM1YhMATW+/TSRgPdOtQrz8nBy6B2JzlVLsxCCJvFb0M9BL5YVyV+OLz8mhe6AcERopvkJjjQNJ9XKIXa5WeETsH8qrhtG/G6SADXFBpDAzXToZPYi0WAu9+JwcugeqGlHloUoGMKjIQ15EclnTNWLvUHGfw/UkG64BivsEJutkAJrehMES9OjhOfRwaNWIIhRbzpDLVI0y9K4RR4CK1xgiaKQYjpv3OjGoLiceEbuHqvtcTWb+9uNNFzS7jtoA9YjYNdS4z6wR+SzHRomSnGjSz+4+DwCt7jNig5YALCZYaso5LkHQzTb88m74EaDGfcImD3EtYcayarQPv/icHLoHWjPGrT7Z+o9SlNDN4RGxZ6itYg+xW9NLlbJ1STnnbEY9IvYPVfep1mbQOIxVN0bwzPIA0NoNXwKkM9DPawbZieEa0PQ2B6N/rzdefE4O3QM1jYytZlmWjthmGVVGXCN2DjWrRq5LrfXsJrPMh9cjDgG11ekcG2tfY90pUWpVvmPmEFCzhwq2OnVdNW5a4l7FPgJ0u2p02jpdNVS2nXauEUeAmt5nVoFxvZMv+zWP8E7XIaDw4dro34OqD4W8yS5vllnMd8wcEupkl35GYyo/FS8/30je6ToS1KvurowA6SSz82LS9VSSCXrJLk8ankMPgz56DRqTWd+roeJ5xBEg09+f+Xj4P5M55JBDDjnkkEMAfwC2BdHdiPV0lQAAAABJRU5ErkJggg==',86450.00,'2025-05-05 02:06:55.583312','d7237cdbb58543a8bc6e17511f47a744',273,6,89),(299,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADDklEQVR4nO2cS47bMAyGP1YGslSAOUCOYt9sMEfqDeyj5AAF5GUAGexCDzsp0GIetTM2tQhiJx9CwQL5k5QiyrvH8OP9DBhkkEEGGWSQQfuEJI8m3ZRuFJGOSWAUSZciItJtYp5B60OtqqoGkG5sAB/Rt7NTkYuq9jhVVdV7aD3zDFofGrMD0N7HfKsNoD0gHTB7kG8zJ4M+AjUP1wIu6iDA0LlIG77qlwz6npD2/ibyGpzS6i2JCe2fxjyD/jtUfIRXYATBO5XhchMFpzKIS+phWcl68jkZ9AXQICIiZ6C9NtBeT5o0ZhtAOqaUamxlnkFr+4jZAehwdoC/CTAJwxnJHmQL8wxaHWKRVSYV6Uu62eOUNjjV3seUhKQctH/yORn0GSg/ZA2UZx4gLQvVvA7SstBArlvYijgE5BTGk0qXPMMk6V4bnIKPSOcjOev4LnMy6CMjRY1UjUpxIaKanILTRRDRgEWNA0FelfZ6UgZpEDlPy9Sj+ojNzDNoNagqyywgwcciF6DqCJLfMB2xf6gEguQAnOaXmlfkT0tgsaixe6joCI3kl+DK0w8Aqe0ZmRugtiJ2DS2iRq49pFIEUBdDVhnBfMQRoFqPKDoie4tco0ijLgbTEfuHajd8EmU8pdaWMJ5RcFHany8RiI1ArXY/+ZwM+jwkcilpBsDc/ta3SwTGJukI6TYxz6ANcg1gqSNKCpoL2HfvLGrsGirK0leRUPLQu75G8RumI3YPsXQA4b7ZOZcncJZrHAV67GuUmmXtfFOaG9b7PAb0Nx/hS+kqjbm8/eRzMugz0LJYXb3FXI9IFaq2liIsahwEWpzpGi6qwCTgVfMpjbEh39vEPIPWh2an0EMVlUBtfMHYIN025hm0PlTOdMnrtYHhDHl/hMa0UzslqFuZZ9Bq0OOZLobLTWivTVRGIZ3uwgeE8SVaFXv/0B8rApwKPp3giYL/1dD+FJRxElsR+4eWPc2afZaEI9av2P6Iw0DL8xqLTRK+7opYtDTsvMYRINF/f+dx2D+TGWSQQQYZZJBBAL8BDgqhJli/wNgAAAAASUVORK5CYII=',104340.00,'2025-05-05 02:06:55.608496','d7237cdbb58543a8bc6e17511f47a744',274,8,92),(300,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADF0lEQVR4nO2cTW7bMBCFv6kEZEkBOUCOIt2gRwp6pN5AOkoOEIBaGqDxuiApKe6iyE8lxx4uDEvwhwyhweO8oRgT7x7Tj/cz4JBDDjnkkEMO3SZkZbT5pg2zmQ2cDWazfGlmZsMh4Tm0P9RLkiLYMLdASOhX18jsSdJII0nSW2i/8BzaH5qLAGgMqdzqI2gEbABWBfk2c3LoI1B7cW3QJE0GTEOT6ONX/SWHviekMZzMnmMjep1yMaHxasJz6L9DVSOCgBmM0Mimp5MJGtlkTa4etp2sK5+TQ18ATWZm1gH9Swv9y4NyjdlHsIFzthpHhefQ3hqxCoCmrgHCyYCzMXVYUZAjwnNod4iNq8xVZKh2c6QRfWykMaRsQrIHHa98Tg59BqoPeek4rGkhlTzIaaFI6Vt4RtwFtFYKjejj2WyoGgEhYUNIFNfxXebk0EeG1pH1QAkpi0KjzSKiiK8adwOV3vX8ICZrMevOW+uxaMRB4Tl0TGUpqWhEKRdgqSPIuuF1xO1DdSEIqr6CUji8WU5Kyemrxu1DW68xBolSWUI2F2QTkljtiGfETUNVCmJTm1ChLBgsyQCuEfcDLYtDtRkjbF6XyGNJBq8jbh8qO13TAHkPHJpkzB2CJln/+zEBqTVYut1XPieHPgP9pRGKS+8hltoiX+amtmvErUMbr1EefFh7VdV/6M03z4ibhpb6IAG1Z8nGYSz9iBF8X+MOoG1G9JH6zEOxm7B8uNe4D4iLJWEVirVRUbZCI64RdwAtb96eTcyPSYCYuleYfkasVz60AYRUf3zlc3LoM9C2WV3Ugk0/opqQ2orwVeNOoO2ZriABZ4MglXtzS7l3SHgO7Q+tovDL2qWoBKgbXzC32HBMeA7tD9UzXfYcgamD8n6EUn5Tu4rHMeE5tBt0eaaL6elk9C9tErPVznaIWK07dw3Pod2hvzKC+UFGyCd4khFeW/rfhpjP5hlx+9Dlma4y5g7rx5PB3CJIbT4Gund4Du0Obc9rsHSj8gHxUDxn7V/5eY17gEz//s3l8P9M5pBDDjnkkEMOAfwBI/qc5fSkaT0AAAAASUVORK5CYII=',104340.00,'2025-05-05 02:06:55.639314','d7237cdbb58543a8bc6e17511f47a744',274,8,93),(301,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADBklEQVR4nO2cQY6jMBBF/x+QsjTSHCBHMTfoI0VzpLkBHCU3wEsk0J9F2UB615NpyJDyAsUxT5RFya5f5YTCl1v/4+sM4JBDDjnkkEMOnRNibjXQswZbG5xJNjPZpnJDe4h5Du0PRUnSAPCmkeowk226CEg1AFSSJD1C+5nn0P5QKgtAXiMqob9OkIZ8g60gR5nn0GGQOgBAIqVhJhCm8t0/fpJD/wfEmyagv04AUAl9811Pcui1oSDZUtA3laR7DSCRQLqILQBJ03HmObQ31JMkGwDxnuMIu9wGAKY6SB5lnkP7QdBjs8BBmqAuTLDF41PrXnxODj0DYesHA/KlA4A4VJsBxKG4j3vEmaHykpHfPuJQaf1OXdh+sryFe8SZocc1ohKAfMmhZCh5qSj3iDeD2IaRiBoJhNESVnn/UFEiB5rn0D5QyUOmi9ATKInqSuhZWU95YC43v/icHHoGspcspIaKmmvmXQNg1Ewh1RPi0IAIg7i3eQ7tDm3VZ4dKiGv0ULJW6koq27XG+aFFayDHjkCOHkxcWFtyFO4Rp4cWrSGZ1ljUZx43RYqcnnCtcXpok48wP4gDsHY3u4blr9wj3gUKI/PpmCDxpglsSxfxfrEqKNuDzHNoN8i0BoEa6D9GwkRmakpJPBGIv2ciCnCtcX4Ia8wgDZXWoDJHlmvha91JXnxODj0DPcYRS13DfGOtaxTP8cjy9NBGa+Tq5sYjctdyFK413gMqa4RtExPWg5Xl0G1xkE0m68Xn5NDzEG93Zq0RSwGUvEp2Tp9NvhxknkMHZbE3uSo9VMhzMtMjy/eBNr/pWn+5AVRiGyaURMXoa8QbQFsNYfHkcrqyW+6Ja/Dpa8TZoeIRA7LwNB06ADnGDOsZKq90vQNUf+rbqYj+IyetCBBC+jnRRrt9zXPocEi/eBFv9xpsU20SdBtMHGyeQ98OlbccBCABBGYKaab6BgSCQKt1hOUPil58Tg49A23qGgCqUg1fJSiQz0fkCofHESeH6P9M5pBDDjnkkEMO/SX0B1yPtNp87wBYAAAAAElFTkSuQmCC',104340.00,'2025-05-05 02:06:55.671385','d7237cdbb58543a8bc6e17511f47a744',274,8,94),(302,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACeUlEQVR4nO2bTYrcMBBGX8WCXtqQA8xR1DfIkXI16yh9gIC8HJCpLEpyuzOEmSEepwVVC9OW3uKDolw/UovyGUvfPoWD884777zzzjv/N16qBUgiQpKAXBcRe4iIyPVEPc4fzEdVVc1AzIPKz7wKjKrAoKqq+sh/tR7nD+aXGqFyHQswFnRegu1ZYJ+rx/lj+PB2aQ2apl8IDCjLuXqc/2I+TSA/bxfVmbVl3f+ox/l/4lv8jgo1VgeV9PIqGhUEYD8CeTb9zn+ITyIiMgHxFiDeLipXy7+rlc/n6nH+IN7idxeh6aXQ1gr6GL3Pp9/5d8yan5gBGFTnsVAfwG5DVVXnZ9Pv/DtW/QZAa42IeVCiNifbmvu3Q776VzOoNq82126v2eO3U775d2flzdo8br+eTb/zH+Nt1hwgTYOSplVIE9ivePP6uVPe6mdhLEHhVRTWYP1RvAnARYWxBInzGXqcP5bn/gUGBmuGdL4XWe3h3+cu+S3XFmC859paMNeDpS0nu38749kd/sUM9/rZdrdO2P3bJd/mGy1+qUOOLWqtZ2qR7P7tjN/Nr+5hahvzfWqFx2+n/ObfQR/it2Dxa4WX97+98o/zZ9qsKkNzN5aY3b9d8n/OquxqjlmmFtGMnn875dt8w2woynJRYA3KWAIs30t9PUWP81/CxxawIhPIdbko5mmbdJytx/mD+WW74WyHhK9iJ/2769Cn6nH+GP7N/ck4gyYZVOItFE0/MsDauGfT7/w7tqufa5NUWyPs1kamHgd7/dwzP25jjFzzr2peRaRdxzpZj/PH8Pv5M9uFDUvCDJvP/fyoU178/93OO++88847fzr/GyJdHEmheoXbAAAAAElFTkSuQmCC',91000.00,'2025-05-05 02:15:15.992483','10aff3e0b89e4202a9ed3a3db3b05bb1',273,NULL,90),(303,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACh0lEQVR4nO2bQW7bMBBF31QEtKSBHiBHkW/QI/VMvYF0FB8gALkUIOF3QVGWG7RBAEW1gpmFoZhv8YHJ6HOGtImPxPDtQzg477zzzjvvvPN/422JAOSAmQXsms3Kh5mZXQ/U4/zOfCdJSgBxNCnNBlECGkmSHvnP1uP8znxeKtTsAhAn1OdQ1pbCPlSP8/vw4c03OWDEVwwaRD5Wj/OfzjeSbq3UM1fX/a96nN+Bj5J6gC6B2ctodNV1JU1H63F+V34ws8V6AbpbK7sW/53L9vlYPc7vxBf/3Qwph5fRRAbBhB7WDtDj/Gfwtc0NqKcRw8topabXhUP1OL8XT2luO03QaaKacKPNn8RpaZH7Z9Pv/L9jLcxGNhhATBhxNA3WyDrNge5X6/ONc/KlftXXJ9aB1Sb6uD49m37n34klcakRXWp0fyGXrPZxQkrr/8Gz6Xf+ndjkl1iH0MV/EwCN3H/Py2/fz/2ay5LQWtOlsL1+z8iX/ZURExATGq6tIAfumRaMpmP0OL8v/8Z/y/u5DiSL//a4/56UX3fN61OpWknSxJL40iJ7fs/HP8w36v75bsd/dE+e37Pxdb6RL2XgzOLEr4FOs2n4kao7H6LH+X35Wr+J2uYmWFqjWG/llFWv3xPydX9Vo0ydlz0XLIfA0f33pHztj0o0k8gXrOvnIOIUIH+fgDl4f3RmvqsFa1dAfW4Fua2jq3S0Hud34jf+W2ZVxKlcyFG/+i/g88kvxJtZK/t5C9SjI79/9VX4pYhHY7gA3W25GL0cLD29fucfova/UUAGDZfXQDk1yhejbLKO0+P8vvxmPknJ6v0QiTrOkp8fnZU3vc9swn/f7bzzzjvvvPM78L8B/nHtloF9GvcAAAAASUVORK5CYII=',91000.00,'2025-05-05 02:15:15.999555','10aff3e0b89e4202a9ed3a3db3b05bb1',273,NULL,91),(304,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACh0lEQVR4nO2bQWrkMBBFX40NvbQhB8hR1DeYI+VMcwP7KH2AAWsZkPmzkOR2dwiZEMeJQ2lhcOstPlR/qaokm3jPGH+9CwfnnXfeeeedd/413spoAWZjtBY7R7P8MDOz8456nN+YD5KkCSC2EKbZoJOARpKkW/6z9Ti/MR+LQ836RnbuEhpim+eqsffU4/w2fHv/Qxhm09j/xaBBxH31OP/J/NiDPV1O0sBcd90v1OP8h/jq306QvRpbGB+fTUFgAOsWyHfT7/x/8aOZmfVAmBoRLifZOZZ02szM9tXj/EZ89u9Nk3I2EUGQ0N3ct9Pv/BsjFz9hAkotlIAuoQG4mZA0fDf9zr8xSnyvj6mRNDUiqAaZLpUS2eN7MJ5izAk0VP/mx0AJcom5x/eAfI2vpNKwWrx6HUMnj+8x+cW/TelPhgk0dIkc1aFLZHd7fI/IL/lVk/17Dfc1tfL99wfwsxEuZmb9bPkVapBDbmftqsf5Tfil/hVGl1qNv8HCkNrsWrqE4Nm0jx7nt+Vv6qOJZa9NZXaolbDvv4fkqYe7tRYCqAlzolbC5S/g8T0a/6J/NXTlLL+Ww5L797j8an3Oq3JY+pO5ydFpnVh7fA/GL+f7cyviQ1mpiS1GN8nAIPwxPL86JL/qX9WdmPV1rLA0tnz/PSKf/VtPd5skYo+ynbvUQnxI5Ndd9Dj/KfxiWLPHhJ3jSRBPtXU17a3H+Y34df6cr25M9RBpyaTz8PX5R/BjD3aOJ9nTpV1Vwl+lx/kP8S/ux+b7OTwbY99AuBiEAc+fj8nf35+sK3IjiL2Rk6z99Di/Lc+qKroeGOWjBZrauvL7G0flTW8zq+HfdzvvvPPOO+/8Bvw/RvcKaZ0rfmUAAAAASUVORK5CYII=',111000.00,'2025-05-05 02:15:16.006571','10aff3e0b89e4202a9ed3a3db3b05bb1',274,NULL,95),(305,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC+klEQVR4nO2cTW7bMBCF35QCsqSAHMBHoW6QIxU9Um5gHsUHCEAtDVB4XZAj0U6BInUhOdJwIZiSPoSEx/PzSEaIL7f44+sMYJBBBhlkkEEG7ROS2rpyU4ZRpFxEbj9tMjyD1ocCSTIBMowdAJ/BMxzLgzMcSZK30HrDM2h9aKwOgGef9Zm/Cn/1gAwAFg/ybeZk0L9A3V1fAJcZBUAcHCWk//WXDPoe0L1FML59CEJ6zQichMDUEeNWwzNoM8iTPAOQAY6Ip6sg9o6I8kIZAJDM99B6wzNoNQhtxghHhPSni75QEs0nn5NBj0AlaixSNmPvAPirAD4DtXurdT/5nAx6BGp9RHEFXsvNpvr0uRQhpQY1H7FnqH7JTKo4NGbhM8g0v5dgUeMAENQOHGs3OSIwo97zrJdA8xFHgDRqeM6tegYNJ461q/fMIg4BjR2KgB2lg0ivImVgBuKJlMFb9XkEaPYRWQVsnzVdwJw9pCWcmI/YOaSBQB0Az14NpD7Qi0WNQ0Hh0hVjKKEjXDoA4yJxTyLSO1v7PACkP/u5W6UIbYEZtdZI5iOOADXBQSvN3GyXKLYxG4PlEfuHGh9Rv33O/kBVq+YV8xFHgapSmUv1qW0SxH7ZLOPKKuh3mZNBj9YaZSEDcLX0CBom1G+oyzAfsWfoRppkhiaVbbfNKMwi9g7N6xqYV7Ucm523y1Ko6RHHgG5qiCJEuXlVKwOLgdja5zGgZp+lAF0WwIGx/wDiW6KE8yRl1QM+68tPPieDHoF0f4S2UnUsegTZ5pgWNY4CNWe64okEMEkRrEoxWvTsSTYankEb6BGLU0iToGQPpdU8oi6YbzM8g9aH9EyXDOMLy0ku6QH5mQBEkeoythqeQatB9yd4AEyCcOkyMQoYTxmATxCMr5lrD8+g1aFPFhF7lwFchYDLAg8gvAuIcRKziP1DrR4x75LSgkM1y1njtlpj/9CnM13zxvy6G1c3ZBdR2yxi95Dw7+/cN/vPZAYZZJBBBhlkEAD8Bkb7s82dUqfBAAAAAElFTkSuQmCC',112000.00,'2025-05-05 02:51:42.738156','d15936ece09a40a29821ac0728543a79',276,NULL,74),(306,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADBElEQVR4nO2cTW7bMBBG35QCsqQAH6BHoW7QIxU9Um5gHSUHKEAuDVCYLkhatJNN7MI/8mghmJIfQkLj4cdvqIjy7WP+8X0GDDLIIIMMMsigbUJSj6FclCmJlJPI6ae7dM+g20NBVVUjyJQGwGd0j9NyY49TVVU9hW7XPYNuD6WaAHTvc7vnD6J/RpAJWDPI04zJoEug4awt4LLOAsyTUwnxf/0lg54DOo8InX/9FULcZYIuorAMSrpX9wy6G+RVdQ/IhFPmnwdhHp0yy5vKBKhqPodu1z2DbgbRK0acEuJXp/aFIjQffEwGXQOVWWO1snUeHeAPAj5DbZ563Q8+JoOugfocUVKBb8vNbvXpc1mElDWo5YgtQzUigmYImlGNUMPCH5tQP9mssXmo/ux1NaKiawESnYLXeirxYhGxdehEWfo+UbQbTmuzXbOI2DTUHryvYaH77t6qIyxHvAzUHjKuPPjiYtdqxlE9RGjTiUXExqEWET7XB78vwuGYD3w72azxGlDxIyTEBfCKhI8hE94HIO2OLuUyAK41H3xMBl0DNYcq7VRIY7mo8wgCCCEuA3inEt5H0Vt3z6CbQ52yrAIy0m2XKEKz6IjiW9issXGo0xG9HxGrlDxxK0xHvBAUPt5UJn8Q5p9H8cAizOO6WcaVKuizjMmga13slh5ctwTtT8eUYTliy1CnD5oHlaE4lZpZTYmqKCwitg6dKMZjxXPdebuWQs2PeC0oSd0QQfOqCHoQSANFYEDdg/s0YzLoEqjPEZ1PXTZEtDJ5OVZ7+8HHZNA1UF8NL84E9H6Eaq8xbdZ4Fah/p6sIh0VKPXSWAUgDwCJ36p5Bd/Aj1qQQF5EJ1+/GLQIjDch0n+4ZdBdlKRMgMjotb3LJCPI7ArOIrFsonmZMBl0Cnb/BAywD4WPIShK0WJg+IqRdtkrX9qHPEZHeFDiIgsuCB8K7oKTFap8vAH25+mx+RPMsuzqYrTW2Dn1+p6v5EWXVoW1DdjG1LSI2D4n9ZzKDDDLIIIMMMuhC6B/0v8JhPfZuBAAAAABJRU5ErkJggg==',113000.00,'2025-05-05 02:51:42.764808','d15936ece09a40a29821ac0728543a79',275,NULL,78),(307,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC9ElEQVR4nO2cW2rjMBSGvzMy9FGGLqBLUXYwSxq6pO4gXkoXMGA/BmT+eZB8STowtB2c1j56EJKdj8j45FylmHh36368nwGHHHLIIYcccmifkNXWlIt2GsxKZ3Y9usvyHNoeSpKkHuw0NEDM6ExQuXEmSJJ0DW23PIe2h4aqAHSOeboXL6bnFuwELBrk2zyTQx+Bmpu5QcjqDOhOQZb6//VNDn0P6FYi1P38baT+MZM0mmBsxHCv5Tl0NyhKOgN2Ioju6WJ0bRCdPchOgKR8C223PIc2g1h7jASR+r910weKo/nFn8mhz0DFaiypbHVtAOLFIGao0+tc9xd/Joc+A611RFEFcQo3V9FnzCUIKTGo64g9Q/Ulq4eShaijSQ7KFOrIrcbuoelnH3XlOCgj9UEQVbtyzSVi79BKR0x2oQrDZE5CvVs6l4i9Q5MfEaUiB+fVvcWPcB1xGGh6yQBJee7qteo99FQj4n7E7iFWxqFEGMVxyCsHo3RuNQ4FJV3MfikDQwPptamj2kYza4PXPg8Areoa6ixkK6MWDDBSPzYQgyy9tKatl+fQ5tAbP4IymuMPmPwIyf2IA0CrN13mcyFjCUEXoXE/4jjQ0BQdsd4xw2h07bJZJpQq6Ld5Joc+As0ZqqAaX/ahJLCL3lh1s8pwHbFn6KrSNXkPlEylMktSYnI1XCJ2Dq09xnUhY9p5u5RCPR9xDOhKIkqsMVe65ulSFHUdcRioHNB4qLbiuYWyqy7pYjA0mD35rrojQJNnObWyc2rJR0hrH9OtxlGg9Zmu4UE6M1rxKDpb8tmj3Wl5Dt2jrjErhX40OxHWu3GJteBhp/ssz6Ht6xpDC+kFjCjo2h4j9ljqH6EzgChs6+U5tDl0e4KHdB4b0muTxWCoe8pA7DGGx+yVrv1DbySia3sBFxOEbEQgvRhiGL32eQDoTYZqObKT5pzleUpYeayxf+jtmS6p1jXmvZd15PssDwGZ/v2Z2+b/TOaQQw455JBDDgH8AYsGxkaAhXzSAAAAAElFTkSuQmCC',113000.00,'2025-05-05 02:51:42.785087','d15936ece09a40a29821ac0728543a79',275,NULL,79),(308,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACj0lEQVR4nO2bQW7bQAxFHysBXo6AHCBHkW4W9Ei5gXUUHyCAtAwwwu9iRvLYQeMGVVSpIBey4XmLDxAUOSRt4ivW//gSDs4777zzzjvv/O94y1ZDbzVmVmPdaJYeZmbWbajH+ZX5VpI0ADAZ7TAZUAmoJEm65b9bj/Mr8XX+HBtoX8HaoUEggIgYwaCKG+lx/pv5/jli1kxGf30r/0M9zv8VX3/8qRKMJxmQ4ndLPc6vy8/+DYLky7GORng32nM+K1sge9Pv/B/xvZmZNUA7AO3lJBhrrGNK5fO2epxfiU/xe9OknEyMk0F4N92d7U6/8w8sXX7aAYBKOocIhIjOVOWBJOm8N/3OP7DSvyECyauVaBWR5m/piuz+PRhPjsuwdDCCJCnOB1Saf3P/HpW3l2GyuYk1mXVUsm6sIVXSw8Z6nF+LX8IUdAbSWzklYWDOxAu3N/3OPzBdLZdWWrrO1yKrkuffQ/LMw4OqeEiKZK8OpHD2+D0wP7+BY+pvWFfclCTrttbj/Lq8dUwGS0EFeb6gn81k0qXGug31OL8Wv9x/K833X8hJOMz3X4I8/x6TL/sb6aE4V9JLVVVch/em3/nPrZgPqn+ONYxPgvCWG9N981ZDGHx/45j8HL9FEFdpU6e4BOfA9vg9Hl/MjwQizwGDsPZSQ3sGIywHe9Pv/AMrl+eoVDaxgGvh5fn3yPyyP2ndsp/zolxEe//5uPxt/XydFUXKmRJ4/v1f+LTQfpK9XMxSa7IYN+xfv/OlfdifbF8bxNgYhFjTXk6y9lLPazp70+/853a/P5mL6CCM8UkGZE9vo8f5dfn7+vm6mjOf5ial18+H5O/3J5X+lZImhUD65vnXeeedd95559fkfwHu2dHgzrVLRQAAAABJRU5ErkJggg==',1200000.00,'2025-06-12 03:23:37.442534','981a9da6634849e9829a418cd7fec6ec',284,NULL,96),(309,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC30lEQVR4nO2cy23rMBBFzzwJyJICUkBKUToLUlI6kEpxAQ+QlgZk3LfgR3Q2QZBA9jOHC8OKeGAKHM/nehgT3x7zn+8z4JBDDjnkkEMOPSZkafQwD2A2XIy5XL6uecLrTZbn0PHQKElagDG+dFXGqYlOkqRr6LjlOXQ8tGYHMA8AXCzaRrkRPcitlufQYVD/6drGU79pHhYZYIJug/VWy3PoDqBwNns79UjaYNQ5Zw+//kkO3SOUfUQQsIJm62Tzywasz7Lx41kGUCtZd/5MDv0CNJuZ2QD2tgDjqcdeq2mXWGrcankOHe0jdgeg+eVsgg0IZxMr6NpD3P0zOfRzyGwgOgpY+1hX6H3oBGGjmnKb5Tl0IEQUGrTk3Y81J8R3msIGBCleSpKmO38mh34CkZSnkBWquPuxzEg3GJdOkja3iAagbBF0iiYwLl0xgX1sSIv7iBYg9j3fA0ZtAgtoAjRF5+EW8eBQ/tqT4kIco7ZkBzGSxHedW0QDUIoaMYskbzxhq8JJTj49arQAVT4ieYYcHKriQktXprhFPDhUao0Ndn8wxXvJSrz6bAmqqs8YK6awpTyiZJZ76eE+4vGh/LUPRaYCdqUy55idPLNsBKo1y+QZih6xeB7RIHRVUiy7y8iaZfVSVCu3iEeGSn/EXxNB2DhdeggAXHrg0sdQMg+Yjl6eQ4dDlR6RNMuQfEQKEzG36LzWaAUqFlH0iF2SKgVHyjvB84jHh+o8okjZefe3SsVODfxuEY8OlV+60khNElfuYU8v3SJagaozXePpqYgSEqyprwq4eJ9lO1B0AAv5BM+aO2+Tir0B65Pi3/6TZ3LoR1A+uqUpnE3vL1I+3dUpNWCGs/uIBqDPZ7qiexhPhlgNxo8hNmIb67Of+2wAutYjsnA5VRNyux2uYjcBZYuoftzY5QldKdu4it0CVPQIADrtmmXuyvZe7LYg09dzPg//z2QOOeSQQw455BDAP7hP3s01akhfAAAAAElFTkSuQmCC',1185000.00,'2025-06-12 03:55:12.375325','dc39e80b27fe4433856710d3271c8b1e',285,9,74),(310,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADC0lEQVR4nO2cQY6jMBBFXw1IWRqpD9BHcW7QZ5ojzQ3gKH2AkewlEtGfhW2gs5vpEekOxYLgwFNsUaoq/7Jj4q+P6cffM+CQQw455JBDDj0nZPXoYTIzu+Z2Mvt49ZDuOXQg1JePOALkF4yQMMLSaxq6pT6V65Ud3T2HHgbl6gA0rrdiorkMoHiQR3XPocOg/q5tBNBkwHTFiALI/+GXHPoe0L1FCG49Mb0sRN362vz1qO459DAoSBoBu+aLmF5ng3yRmV2KhiVpuYeO655DR0OTmZkN7dv4fpFdoSYTcCtTjUd1z6Gjo8YmZQtmE8wGYTZNQ4f2DxzbPYcOh5Ck+r6rPwCgk8ageoxhoZxK84uPyaHPQNUiYqqZgsawUNIKJXZWUptuEWeBgtQUh07EdDMIEtOrREydICxNrfgmY3LoX6CWR+Sh5Qq5XyC/1BnG9AaCBcjD8d1z6HCopQZQIkTJHsZyr1MJE9ICUZ5HnAFaLaLTJkrUdIFN1O4kpWYgbhHPDKH1IKb24mnzCooxqCaa7iOeH2ovuZjAQvEWZeqRgGoRy3rlFnESKF8Euae4h58DmA2diJqtXqWba5YngD5UuoKglLZKxXOwUgWNv6wIl1bWUXzxMTn0GWinWW7pZYsaNa3YPeJR4yxQTGDXMJv0vrmNmzG9LkA200hXq1/fZEwOfT6zTPsmUdL+lDyzPAPU6hqrBlXqGm2GUUQJpaZMuB7x9NCu0lWaYyl7bvPQrogSrRjmFvHk0Ooj1JLKJlvvfMQaU9xHPD/U0sg8ILIh8svC9PYbprckiwKDvqzYP7x7Dh0O7VTsXfyIH2TrLb30qHEWaLeniyAB6/oIM6tiJq5ZngG639NVogZ0RZKqNhAWtjUTX35MDv0PKK9bt15na3WNFjWKowiz7/s8AXS/gwdyj8X3fhG5eoiyjcd9xEmhmDppDLNBUybM7CKNnkecCgqqy6emAeyae+xasoceSbMxDZ37iBNA+/0abEvr2hL9DyUNX2d5Bsj8n8kccsghhxxyyKF/hP4Af5NoU1bR2CsAAAAASUVORK5CYII=',1185000.00,'2025-06-12 03:55:12.403734','dc39e80b27fe4433856710d3271c8b1e',285,9,75),(311,NULL,1200000.00,'2025-06-12 03:53:15.826192','5d691b4469ce4eee8a257a149e5f6108',285,NULL,74),(312,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC90lEQVR4nO2cQYrjMBBFX40NvbShD5CjODeYIw19M+soOcCAvQzI/FlIsp2kYWjSJGm7vDCWo0ckUlT9Kkkx8eUr/Po6Aw455JBDDjnk0DYhy1cNoQWzdrLyBHYcS4fjU4bn0OOhTpI0AF26VUlxqh9rgEqSpEvoccNz6PHQWBxAaAGYjO5kZsfmbOqB5EGeNTyHHgbVV23rTnVUaAcZVJFwfLvNT198Tg59L9Sczf6caiSdjU7noh6+/ZscekWo+IhGwAgKVsnCIUL4PQjGdxnA2lO8+JwcugdirRiplETlza106CSpf/E5OXQPlHzE4gAUDmcTRKA5GzCZLj3Ey8/JofshsxYIZgZjnfIKfdiboMkeJHV5zvAcenjUkBSRFLmIEBFoIsksuqF09qixZahYxDC/aCQ6RaShkvpGgibbi1vE9qGVjyiuoFr7g2QWVO4j9gKtc405YGR/MFQ5nPQUb+G5xuahYhHNHBIgSQj1ZNsgrWsMlVvEDqBsEVk43BgIJPew/tQtYtPQhVxYdIS0qlAl95DqV24RW4dmp6Dy68+hAyjawrPP/UCr4JBqD53yrYSJyGIq7iO2D7H80rk5QK5LlWZWm64sdwHN9Qh9oh4gS4gmp6BuEduHVvWIlG72JblYG8hF6HCL2DSU90d0PUDztzaYDBoAppq89gmElvz06nNy6B7oWkewFCD6pDbnqtXgucYeoFWFalnnLFecdYSUd2q7RWwdWhcps3bMieeyAJo6drOhuEVsHyqLFpG0Y+bYxHxUIxzOdhFTnjE8hx6uLC23qkhoq5ibjbDUY3yPwFS7stwNlELCML8ea+xYPsgCY3xTevdD5uTQXVA506WeyfRxkAjtlJ1F2oCZNuI+Z3gOPQy6PtOVihLdyRBjjYJVUakyMb77uc9dQmONPtpl8/W0OhCann7enBz6wrVa05xrD0vtumytK3tnPPvcPHR7pkvK6xrzruzSz/di7wEy/b/P9eX/TOaQQw455JBDDgH8A/qItLUzMU8cAAAAAElFTkSuQmCC',1185000.00,'2025-06-12 03:58:29.023441','b2d0874a3b9a46669dca939339866671',284,9,97),(313,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADGUlEQVR4nO2cUW6kMAyGf2+Q5hGkOcAcJdxs1SPtDeAovUHyiBT070OckE4fVl0kmBbzUBXKJzka1/7tOCPEl6/519cZwCCDDDLIIIMM+pmQ6NUBs4jIGEVkxCrNrYiIjKeYZ9DxkCdJBkDGngT6BL4NjvDBEYAjSfIjdJx5Bh0PRQ0AnOqf/LuIyGMRTgByBDnLPIMOg7qne0EPcBYA8+iS+Amf69MXX5NBe6BnjyCwdvDhnuC5it7+Ocs8g06DejInhzHeiPmxCObBEbPccowgmc4zz6DDII0RswAAnD71f24U/94l8eEOAKucY55Bh0PZIzapQGARAosA/SKYBwjxpCVefE0G7YHQVJU+bI8dOcExl6VTn5B/kCSnF1+TQXug8iEDAEorIssKMoEM9b0A7VuYR1wCcuQUu/wbfFilaMzNS1LpVnyXNRn0P1fOGjlh5IJDO5UleDiNID7AssYFoKYfQcQuCfoAzgO0uPDhDngCgj6Vl198TQbtgYqyzNqxKApftAWnPpX3QhWaL74mg/ZAJWuwdYbsIFqEOK01GCxrXAFqP/hcXBRZQQbHHDfIhKwozCN+PKT/9m1TokhJvQVyWWrK8hpQ1REfGhB1XCLriOoMpiN+PlTThOOmFLasob5BbUVYjLgMlDc7HwlA3ArSVfgmHUQGHaSS8RzzDDola0DrCt3IyFWHz4Eioe1avfiaDNoDNbXGVnhiKz208HQfGhUvviaD9kCtcJjgVGPmzc7tFrAu9lWgWkPUNFGlZO1CaMMqwGLEhaB4IxBFdzPmAcA8OMpvLgLEDiIPm6q7AtR0qNo2Ve1H8Dl4WIy4BNSc6dIjO6sAPamnNHJFWoctv8WaDNoFNU3K/MDpBHbVEZpYzjHPoFNqjRIekPfFsx/4JpMkU5YXgJ5P8MBPayf+vUtE7EDEeyIACOLdYsQFoE8eMYsjdETfJUGf8jgVEVfh0eYZdBpUG1HoE2SMHWTsF+EUu1xwlM2Nc8wz6DCoPa+helKHpnQqgnWqjnZe4wqQ8N/vPF/2zWQGGWSQQQYZZBAA/AWg8aGi5JogvwAAAABJRU5ErkJggg==',1185000.00,'2025-06-12 03:58:29.043295','b2d0874a3b9a46669dca939339866671',284,9,98),(314,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADDklEQVR4nO2cTY6jMBCFvxqQsjQ3yFHgZq0+0twAjpIbwDKS0ZuFbSDSbLrTTX4oVkmcT7GVyrPrVRETX76GP19nwCGHHHLIIYccek/I8lVj3WRm1oB1Uw1MZvk1M7PuIdNzaH+olSSNAEGCqUaf56sxnCX1VJIk3UL7Tc+h/aGpCMBgZpKuZh2VYDIDwMzqx03PocdC6dtvLzW0I1j3a5/k0NND6kMEQkQ9wHCOv/RJDj0nVHaCIGACg5Os/XsSMJvay0kGsHWynnxNDv0ANFjOMGjHPGIdlaxLT+aUajxqeg7trRGrAIgJIFxNQ1PBcL6abhXi6dfk0P1QMiByNjEXKWA2mPL+kWSke8j0HNoRIhkNixUhKaatIw8oLm5FNiXUP/maHLoHYnWepLEqjxQ3oaI+SOrLmz0i3hoqXzJkKehDJEsG5BS0HSuljNQj4u2hjUasTze60Yeyp7SSctA8+ZocugcqP/sgpXNEvwz0VMrJaAkL14j3hzYHyHx2HBfjkmqRh+JjekS8PbTViFYqx4URsmSEmM8R7bKfeES8M5TPESkYkihsK99FLdiGhUfEO0MlIlIcxI2LnZLRdqT4EfJd4wjQUum6moaukg0NiKnBCBENDQBz7ZWuQ0H6bCDXwMNa/p4ttVQNdpJtCl8vsSaH7tMIKhkYakcEVNHafsagjho6gKnZf3oO7Q4tDlWl1XagXV1srQ00Xtc4DiSNs9FeaqwLEYZm20unfqqBcPX+iANAS0Gr0tpQly0pcl3jZsA14s2hsmuE4ln2iynRp4PmUvUI7lAdAdqUttbYyAOl4lmKXK4RR4Bua5/V0gaR6xop+2w3jRMeEceAkis5gn2swQCoT6ZEJN/s9ZjpObQ/tLmnK9/tmZOL6SQGM1vt7ZdZk0M/AakPEbNzRLqcZB+6WuqUWIPm1dbk0Feu+r+vJrsyORNj3iuGcyzFjSdfk0P3QJtq+Lbzdsw9VFkeQm6h8JPlYaD1nq58gKyU3MslGQUWH/M11uTQtyDzfyZzyCGHHHLIIYe+Cf0DeWqBMVw8p7oAAAAASUVORK5CYII=',1185000.00,'2025-06-12 04:02:29.658957','3bf476b367074012b31fd912b02eafa3',285,9,74),(315,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC/UlEQVR4nO2cUW6cMBRFzytI+fRIWUCXYnbQJVVdUnYAS5kd4M+RQLcftoEklaoqLaTw/DEZBo7mIZz7rp/tMfHHbfjy5ww45JBDDjnkkEPnhKy0FgYzsy6ZWcdsm0MzM+sOCc+hHaE2/4k9QHrGCCNGmFoNt1EQRiA1EwC2d3gOHQalIgDql1NxnG09kRXkqPAc2g1q3xwbATQYMHwbRRRAOio8hw6HpHE2+z42It6LmbDuX3yTQ58TQpJElCSNjYhjIwgT6oMENPnE5rr+k9+TQ38BGszM7FY/jfcn2fd7C3EE65jzUOOo8Bza20espWzBwwSP/PQ13BogvK51f/J7cugjUMkaQNaD2hrlrBE1oT7UF3nWODu06RHFOIQJCJI0gjQu143gPuL8UO0RQdlUbpWBppwgy4NrxBWgWo9IBoSHAe0E6VlEzcVMkJ4E6bZ/eA7tDpV/+zy+rBpRC5dlMCppIuuGa8TpofqQKQ8+d4ZsFyD7SZaihPuI80PbHtFD7gzVOCwtKwiuEReDoqb67t4CyYzBWhi+TjDcGv0C2i88h3aBNlKQD1e1gK2FII6uEVeANlljHWTWaY71Kp/XuBwUJiC1WJdHmmask1x9mPLURxGP/+SeHPoIlMxqXWptszHcZoPUAjSy7qDwHNoNWqrYdTSRfURYUsfiMmKdEvescWposz5irVizmkqgmMoefF7jAlDtEePyzKtxyG5zrVV5PeJaUFg0Asq8eNTD9OM2m3VhwjrIL//NPTn0IWg1kMBwI5ek8opLUi1THRaeQ3tBr4rVNX+s9Yi1PLExmp41zg9t9nSV1DEbBKl8lsVj9nWW14FWUfhhpfYAwFrMJC+SOCY8hw4Za7xbmB9UF+tDndzwrHF26O2eLgAs3ttJJEPD14eR94KmZ9eIC0DvekR8eRJliX4zWbw/yeKLIdJs2js8h3aH3u/pej3g6Jck4lXsa0Db/RrUxddlLV1YeslSx/QecXrI9Ptr3jb/ZTKHHHLIIYcccgjgJ5PKnPJSx2ayAAAAAElFTkSuQmCC',1185000.00,'2025-06-12 04:05:13.919907','785ed697f13749318c72fa13bb71b7fc',284,9,97),(316,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADCklEQVR4nO2cS27bMBCGvykFeEkDPkCOIt2s6JF6A+kouYG4NEDh74LUI8miCFJIqTRa2JbNDxjC45/zIG3i09fw4/MMOOSQQw455JBD54SsXg0MZmZdMjO7T7a9NTPrDjHPoR2hpjy1PUB6YMQRI+ZGpJuMOAIpZABsb/McOgxKVQDUbz6cTH1qsA4oCnKUeQ7tBjXv7o0IGgwYupCtFYh0lHkO7Q699wjB1NCOj0yryert76PMc+gwKErqAevSTQwvT4N0E4PdSg1LUj7OPIf2hgYzM7vP77avN1kH2M8RgKmkGkeZ59Deq8ZayhY8TfA0iE9juAe0HbCveQ7tDiFJ9ftux/XtIPVRopUEMaM+5jJY/Tefk0NfgapHtGNQDSZiprzSCOWhp76idY84O1R/9lJGGldlyLAVikwd4h5xdmjRCKjyQKi32ujGIhnuEWeH5jgi1qWjfPt9+Syo6IaUmYXCPeLk0FyhSk2G+DSRDFoBQzfVhAOCID1kpf/xzefk0Feg+WcPFI2oa8WiB3GNMnzVuAI0R5YjrH4wxxFACS+XB/eI00OzCyjPGrFIRokxSwixeIl7xNmhN5GlaiGqlB2WUsRmnNcjTg9tep8aLMjaERnpjiBkg5AhPbLBUsz+5nNy6OuQ+mRmXcxA2jbIi2QMLxn1hNL9+k/m5NC/iCOWSGFdOuZrG2V88zk59BVo0+laC1GU4tSyIaJUNMH7GheANulmbXcx1yOWnLMM9FzjGtCbAkTJMMKmtVWSkFKoGHGNuBZUj2TcQb/uwHAPoh0ng9Rg9uK76q4ALd3wOYDkbT1Ca4VqGeMacX5oc6arBhOTQZTqKY2SkU6+z/I60CoKv8pBneoWNbIshYqb3kL7mefQgbnGskli3lq35Brz+uGrxqmh9yd4gMloX5tcdkoQn0bbTw2kh2vEBaCPHhGFlb0zhMzQNTBYEKTJvK9xHSjOPfDBrKab3bztUn09ueEacQFoe16jxpNh2aL/oajt2ef5IdPfx7y//J/JHHLIIYcccsghgD8fUZxHRLdTJgAAAABJRU5ErkJggg==',1200000.00,'2025-06-12 04:07:18.874225','db74d1397e854d118a44e8c6a6d6381b',285,NULL,74),(317,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADHUlEQVR4nO2bS27rMAxFD58NdCgDbwFZiryzojuzl5IFFJCGAWTwDfSxkzdq0+bjUIMAiXUQCSGky0tGlC+P+c/XGTDIIIMMMsggg/YJSRk9MkYRkQFkjD3AIhDrhPEuyzPo9pBXVdUA4FQh9ujHsIiM8U2BTlVV9Ry63fIMuj0U6wEwi4iqnkRGl2AeygQR6e+3PIPuC+Vf3x/fVDUs9a74jW8y6OEhnVwCXEIngPmQfumbDHpMiKwPio7osmbAh051AlRDp+WlzZsefE8G/QA0S8kw8KE8kffQqYyAjCw51bjX8gy6HZTV4mplKxHAnUTnoUPnw0nAnXvdD74ng66HsgFRsomlHgXuJECn+bPZ/IiXgLKOyHrSa3sJRUJspjQxYTpi11BTlgnVAEVPamK1pEr+QQufB9+TQT8CdVoyTZeA2OdLRCdA3o/9JiyeZ08GfWeUo8BVF9uXq6FpyZKH4i37fAloIxK2xQ1Ap1zNSJuqh90arwLJ6E6S74rRpXxDyAibusbWvXyKPRl0jR/BqiNmAfyxB9ynKLEH4gA+YLXPF4BqrtHM6umi8p1HcbZNR+wfqtKAlnOG9iCsOiJtMlKLiBeASi+EvCnzQA4LkUPJQ4FS4bjT8gy6PZTrW+4k8h62j0UOCZ2ys93C4jn2ZNAVkH4MpbFSJ9aS+CKlSUJ6IFrt8xWgZla3ooVbhYNqPTx0IzlNR+waqg6VVrPBh1rI8LXgQS6AOlOWrwCde5a1oU7XOKBTnZzmiLDsc//Q9taY6Db9dbXjsjkTrh4nFhF7htqtcVHfqn7E5Ep9q3ZPWETsHMoudk0iuqTEAYWlF+jqrPg3MUvrvnvwPRn0A1Crbub22yIh2ri4P55jTwZdBbX/dPnQafEecp8luVN7bdJ+mj0Z9B2ov3hfm69Tr8Q3FX/sk85jlyQXQKfbLs+gm0OXEYEPC/hpQXCtyQ5gPqTedMT+oRoRToEIgvsE4oDOo6DzEBCvi+An6494BYiznLNaUrkx31WbamNqW/a5d+j//3QB2bhs77SlHnZrGGSQQQYZZJBB6/gHclJdSWLfpZsAAAAASUVORK5CYII=',1500000.00,'2025-06-12 04:25:09.800215','de1c862036c94e3d8dc67c0e4ba1fbcc',287,NULL,108),(318,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC/0lEQVR4nO2cS27bMBRFz6sMZEgBWUCXIu2gSwq6pO5AWkoWUIAaBqBwO+DHijMoggayKz0OBH14YAqm7/vw0SY+3eZvn2fAIYcccsghhxw6JmSlXWA2MxuXerB+NVhqh/Euw3Nof2iQJEWwMUgQEvrZd9K0PAnoJEl6D+03PIf2h5YiAJraoyGuZmN4yw+ygtxreA7tBl1uro0Amg2Yf2RNECxf8EkO/Z+QFFezl9iJ4dXMRtbqPXzxJzn0mBDZPyh+RCeG2BU/YqKrLkSsfsQgSdODv5NDXwDNZmbW17vD65PsJQJDBBtZc6hxr+E5tLcfcU1lC95M8GZZKOa+Q9sO+w7Pod0hNlHlEK+3O2kKxUwUIxJS7uxW49DQxo+AIGkKiXymCPkwUc7cjzg+VH/2IZXvnKwMzbNsCSvJNeIMULUaQZKUAErAUadKUQuGiM+IE0DVasR6OQWpJi5vAk/XiDNAbKRgowdq0yKk2i92no84AdQ0oitCcc1Q5anSFrncapwDavmIHGEAJBh+XYClR4RYzua+S7sPz6HdoY0UQEtbT/lZ14xIcs/yLNA7zzKUL/5aLlH9CF/XOA1UV8ODgOUC83dh2WCQzUTJaM5jO33wd3LoS6DVzL6n28dmdsFGVgM62Xiv4Tm0F9Sy2DU5VZY0UjYd1yzENmv14O/k0L9AbaVrG2TWy1SK7IZYy+3cjzg8tNGIuqD1rmJmiF1NSkSPNc4AbWdEy15ubAXvlkJdI44P1VhjeVapkAqguf8N84+IABmLASHVzg/+Tg79C1SUobWSjdJWFK4HtxrHh/LPvhZQdqmqxXoRQTAbwPKcyPd2Hp5D94KaKOhnD5Q4tLWQgLy76y7Dc+g+Wey87NlKLEs1VavCbObErcaRods9XRB+G8PrJYnF0GxdEqwXWJ5dI04AfZgRw4QoJfpdsiH2OYENy2ruRxwf+rCna5t7aFmrWojrscbxoe1+jWvR7bZEv2318zrLU0Cmv/e5bf7PZA455JBDDjnkEMAfZz7BS0YBhQUAAAAASUVORK5CYII=',1500000.00,'2025-06-12 04:25:09.818202','de1c862036c94e3d8dc67c0e4ba1fbcc',287,NULL,109),(319,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC2klEQVR4nO2bQY6rMAyGPz8idQnSHKBHgZvN1chReoCRyLJSKr9FHKCd1bzqQac4m5aknxqEFdu/jSg/HvHPzxlwyCGHHHLIIYfeExIbARmSiEgHMswLZU5EZNhlew5tCIXy0Y8A6QNoFSGFrLH7ChZ3piYDIFtvz6HdoFQPgCgiqnoVGVJApLuVBREJ+23PoX2h8vT7qVH6S/i+/hvvyaF/hHRsM9BmdASI5/yf/smh14ZaVR0BGdJJ6S8nJXY3Kd8AVDU/Qtttz6GtoSiWYdBPtiKfUzMLmreSauy1PYe2zjUWKVtJAO1VNJ4zGs9XgfZe637xe3LoeagIEJZN3OpRkEQgnbTMRdcjDgGhZUxN+aTXXFzHcvnwEx1f/J4cegaqD37C7GDEoshiAiOWf9QFt4g3h+oBoHmdeGoJKhuFNpsyURbcIt4dqg8ZVr6inBs2mrpanIhbxJtDs9eY44ipLow05fAodqCTe40jQOszAuaYoc0AjQWaRb9yr3EIaE4koMYMsFwupmIHhVvEQaDYgY4pQOwahVYVUi1ylcgyBWTYZ3sOba1Z2mi/Av1oCpWSPrL0egvE81UUrqJbb8+hnSCrYaQApFC8hsg52+WItVTttD2Hdss1cp2bwFwHTZErPfs8FlQKWuk0SxGN0k+1whE7sDLHPttzaBcVexGr19UMXRpovK5xBGhVxrKJWY/oV4JV43rEUaB1XWP9bemlM2MwtcIt4t0h7moYwBxKVvVyXm1doToCtCptPdiGeZJW5zTDz4jjQMs7XTVcyKWvykYKECVUUftX3JNDT0FzdVM+ywsaFmiaCbRW7tprew7tkn3Wxpi7wtdiB17pOiakehEROWdULydVvYTasZ+88/a4UD9ZXUMGWL3d5XHE+0Nzy/WdTGU9uA+5hnuNI0D3ekRTa1611XY955WuQ0Df3+miFjLmeZtbfvfi9+SQQw455JBDDm0D/QWqBY97+RxhkgAAAABJRU5ErkJggg==',1500000.00,'2025-06-12 04:28:41.918528','a3dc667fa4c24d59afbb3ea7e3d077b7',287,NULL,110),(320,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC/UlEQVR4nO2cQY6jMBBFXw1IWYKUA/RRnKv1kfoGcJQcYCSzbAn0Z2GbQHox6mkNdEOxSIThKUaUfpW/7Zj49NH/+jwDDjnkkEMOOeTQMSHLRw29mdltMLMbk8FQTs3M7LZL9xzaEKrTV+gAhitGEzGasVbfRhmNgKEaAbCtu+fQbtCQBUDdfCnEyWDIMZMUZK/uObQbZDdAr1ZD31YiaPxPv+TQ94Tqp3PBVBPidSTcrZy+7dU9h3aDGkkdYLfhIvqXd0sa0dsleVjSQy1+yDM59C9Q1og+1YxVbg1vF1mIVyzEK8Bk+3TPoc2hFBEPK1vwboL3FALq2wotb9i2ew5tDiFJ+X2H+GiupI5KhFgJmhF1zZhuVvfNn8mhr0A5IoJGCMovPpUVKqfqACkCwSPi6NCsEZWyRjQ5QNQ1krpGSSNSm2vE4aGiEbFSDoE5NkIJFSlWkiIeESeAykum5IV5HMoiGEpi8Yg4PrSsI2jGVbkAqS3fFyt5HXF8aJk1kkZQBhfrdEKInjXOAM1ZIwtA/og5iZTaAtSR84dHxKGh5FBZ0GQwXFOKUN+CQTVauBvQ/K4txNa0dfcc2hxa1xHZhUjlQtaIkZxTioK4Rhwaylkjvf1H6ojLUjJ7lngdcSKof5Hs1rybXtvV9b6djHC/JGfCbvt0z6HtNeJhXErKuSKJR1UySfTK8gzQcqZrNqtJ5lTxKPIQFHxe4wTQXFlmPVgVDrNkFGfbNeL40HruM1tSxbEuGvFsZn7zZ3LoK9BsTa4tqSbPfZbpLig5xSPi4NCislxUFA8/Ys4puc0j4hzQYk9XmtdgMmgkM7N508a82PJHPJNDX4IWohCBHBbzhp5mBIaL1tB23XNolzqiFJWaV049ZRKvI84APe/ggaGFcK9HMRhANZL2gg5X14gTQB8iom+rkbxEvxotdJMR3gwxTD73eQLog0OV19LBY+CZRxi+PuIU0MrFpkTEYol+fCyp8nWWZ4BMf7/n+fB/JnPIIYcccsghhwD+AIx80xxkpQ8VAAAAAElFTkSuQmCC',1500000.00,'2025-06-12 04:28:41.934775','a3dc667fa4c24d59afbb3ea7e3d077b7',287,NULL,111),(321,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADGklEQVR4nO2cUW7bOhBFz5QC/EkBXkCWQu+s6JKyA2kpWUAB6jOAhNsPkrLi94CiNWon0ugjgSwdmIJuhjOXw5j442P89ucMOOSQQw455JBD+4SsHh2MZmaXycwuLAZTOzUzs8tThufQA6Gu/EoDwHTGiBkjzp3GPsuIAqYwA2CPHp5DT4OmGgA0rJdSXgymqpkSQZ41PIeeBtkF0A/rYOyDSJr/0Tc59Dmh7uZcsHSkfJ5Jb9ZOX581PIeeBkVJA2CX6STGl3crMWK0U/GwpGu0+CLP5NDfQDVGjCVnDPXT9HqSpXzGUj4DLPac4Tn0cKgo4mplC95N8F4koLEPaHvDY4fn0MMhJKm+75SvHwdpIIiUgyDOaIhzuVnDJ38mh+6BmiLi9cdMSSukpoMBkDKQXBF7h6oiUgapxAO1mjNKGlaVJHmMOAJUX3KNBxKUuYISD4AgKQdJGVfEAaD2ktfJYWh1KBsxqMYNV8T+oTZrrO98gJYuADWtoM0pnkfsHtrmEQNQKgxaXUHKoSYTJdVwRewdai52nDuIPzsjZkivHTD1aHyZgcnQ2IdmWn7yZ3LoHmiTR9TTHDZ5RPUo4ozHiINA28lh41VJtbgYihiu6aUrYudQ+7On5RE39kQpQa82lSviGJB9bwHALh+vj/1ipLdTcSbq1S/xTA7d51Dl1j5Vi4t5nTpC8a+uU4fHiF1DmzyiJgklx2w6YM0jBvB1jQNAaw/VYjD1kN5OMuJP03gJsjQgxj5gKfdtUfyTP5ND90Bbz3KNB82xbjGiGFYZjxEHgD5UnxkorRGxLXyltSJlzS1cEXuG1rVP/b8fsV31aIcrYv/QZk9XaZpiMYiSmdm6aWNttvwSz+TQXdCNSQmhdmAPQE0mppM+Qo8bnkOPh9qeLrsA+tGDWU9tmxnNDOK77/s8AHS7g6eVoN0sJgMIM2Uv6HT2GHEA6D+KGF8EtUU/zJaGxUivhpgWcz9i/9CmmqhLW2sduhaebTHMXewjQNv9GqUh4mplx6aS2lLlfZZHgEy/v+f28P9M5pBDDjnkkEMOAfwChcamoU9S5rsAAAAASUVORK5CYII=',1500000.00,'2025-06-12 04:28:41.950230','a3dc667fa4c24d59afbb3ea7e3d077b7',287,NULL,112),(322,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC/UlEQVR4nO2bTY6jMBBGXw1IWRqpD5CjwM1GczN8lBwgEl625Khm4R9I9yqTHkigvEgDzlPbouSq+qoiysPD/3qcAYMMMsgggwwyaJ+Q5NEiQxAR6UCGOpGeiYgMmyzPoBWhNv3pR4DwAThFCG1U313bHHeGJgIgay/PoM2gUA4ALyKq+ikyhBaR7pYmRKTdbnkGbQult99PjdJf2u/z77gng/4R0tFFwEV0BPDn+J/+k0GvDTlVHQEZwknpLyfFdzdJVwCqGr9C6y3PoLUhLznDoJ/yjPyemipo3lKqsdXyDFo715ilbCUAuE9Rf46oP38KuHut+8X3ZNDzUBIgcjZxK0dBEIFw0vTMmx5xCAjNI0KvMYcL/ZQnyjNV1anJF+OL78mgZ6D8ukcgvfN0lcyi3I4l9TCL2D9U1AZ3bSElntcWwofiuwbBXVvpLyeVNLHy8gxaHVq4hJRm9MWNlC/kg4I+ORE7I3YOUd5+o7NzSBMjTQ0wVFUn8xoHgnqN5LzCxRQ4yEAugOI77tTL99iTQT+Ua0ykj4WUDSzciZ0RB4BkAHQMLTLQKDhVCCWS7Kcm3cqwyfIM2iL7zHawiCNStKml8KVVmbAzYs/QnfxUEo7iNTTfjm7Wr8widg5VabJ8pGcTZNdBNRXLPo8EeRHRP9KS/QeN0k+lwuE7yGWObZZn0PpnxHwKTCw9hOrcQGN1jSNANY5gkXiWwKEYyKxfmUXsHlpaxOhmaXLupcvGkKoeFkfsHlqo2Nl1lKwji9quVjicKVRHgGq4kEcWICh6REpB64SdEbuHkixZkogmKqFD4dYKNOVb4SPipXbfvfieDPoBqC/BhAwuAuSm2yxhpjii+o/32JNBz2WflPJFCS+/2oFVuo4JqV5ERM4R1ctJVS9t6dgP1nl7SMifc+etyDk3Scy/7spO5N32ZNAjY65rLFvrJpjroYuShnmN3UNVjwBgjiMazXEEVaOwStchoO+/6QJSIaPeKcS72Rffk0EGGWSQQQYZtA70F9P6l8S5+sGnAAAAAElFTkSuQmCC',1500000.00,'2025-06-12 04:28:41.966856','a3dc667fa4c24d59afbb3ea7e3d077b7',287,NULL,113),(323,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC9UlEQVR4nO2cQY6bQBBFXwUkL7E0B/BR4AY5UpQjzQ3gKD6AJVhaavSz6G5oT1aTSbADxQIZ4yc3cul31a9um/j0MXz7PAMOOeSQQw455NA+IUtHDTCbdfHmbGbn2ayb8ge6pwzPoe2hVpI0gpnVqGc266aTYKoBKkmSHqHthufQ9tCUBaAdwToqMVzuRquAelKoPG14Dj0N0s9LACYz6ZpCwLp/8U0OvSZUf7g2GmC4hBqogg3n21/6Jof+DyhHRCNgAtr3nD0M3+8GMZmA0sl68Wdy6C9Ag5mZndOb1lHJflxPymnFHEuNZw3Poa014jcru7mbhktAw+VuSUGeMTyHNodIVWUTkMblEqAdq3iDdiSeYg3av/gzOfQV6CEEJKlvlI6eKl7GYIivPCL2Di2Z5a3WYFWwdgSDKhjNzaI8QLqx+fAc2hxKGtEuU8dHZaASZN1wjdg/lDLL4TyioTuJdnwjv1cFoxkRkyGYs6C8+DM59BUILQc0etSDAFBJPRDvukbsHioiQhqrHAfNGiAB9U1qbnitsX8o5xG50ix+/b6R1OfqU1LwiDgAlH/kJaksJhGIsRHjJZ48IvYOLQ7VmkyUsZF1I62ecI3YP8RDHACQpIB2rJSqz3gC14ijQNl2CEjjbOonM4ZLwDqI9nayLJ4yPIeek1nGWgPWpDInGKup7bPG7qEls8wGxBIbhV25phU+a+weKjpdZR4xJl8qN74CXmscBCo1onAlgSQUD21ynzX2D8VWhbVXy+2L6S2Qep8BmE4yAKO51dp6eA5tDj242HH+eLAiyjLDM8vjQMWernZc93RVsq5R3sbT3H2d5QGgYn1ETBykbFL2ZKOiXSXDNWLv0OJHkArPxbGOSyxjAxTyRkCPiKNB1kW7MktGP9Vk62r2ncAHhNIiiWuNddOyVTxWHb7v8wjQxz1dBhjt+2wazhVGM2LFRzYenkObQ+Xq/NT2XNrfSn2NYjWV5xG7h8z/mcwhhxxyyCGHHPpD6BfZOcmVoLxeYwAAAABJRU5ErkJggg==',1500000.00,'2025-06-12 04:28:41.982882','a3dc667fa4c24d59afbb3ea7e3d077b7',287,NULL,114),(324,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADBklEQVR4nO2cQW7bMBBF31QCvJQBH8BHoa/WI/UG0lFygALkMoCE3wVJWXYKFIELKZGGC9qy9RASGg9nPocx8ek2/Pg8Aw455JBDDjnk0D4hK62Fwczslmpn9vhuk+E5tCLU5pfQA6QLRhcxurHVcBWQLiOkZgTA1h6eQ5tBqTgA9fNX4a2F4TpiNyB7kK2G59BqUPt0bXSgwYDh1mAh/q+/5ND3gJ4tQjC1hHgZCZpMMLUibTU8hzaDOkk9YLd0EsP13RjOjRjslDUsSeN2w3NoNQhJmnXLRoT4t67eECSp/+JzcugVKK8adylb8G6CdwMmYzg3QPeodX/xOTn0CrT0EcsospH6TiJIgm5EfTfmm91H7BoqFhE0UoKJrr5ThNo1+dJXjf1D9WdPeebVM4zkz/pOKgYi9xFHgrJnGIHUAum0iCelOFn5YqPhObQaVOOIbqxyZc1DyamHSst+w33E7qHykBXnUDJSwwWWorYUq4G4RewZqhZRTWCRXCxanGNMt4i9Q3OuUWJHikxVTSCHnPfg0y1i71D92Xf1mZcOgGXOWazELWLv0DKylEayMhHqWlHyDx58iVvEAaDwdlLOOfPWVjIDGjEnHAxmVpzH95iTQ69Aw3myvOMZ7lucTAbJTH2WIhrZbZvhObSJiq2+OoUsZYe6TJSVJHpkeQRo1iEbQffbCP1kwEmUYpkzIl3EcMZKPeYXn5NDr0DVR8SSZjD7iHLZLXdG3UfsH1rkEDmvmJWJexJSMpGI730eCZosJxyDtTCcyV3WrkktZlevqjsC9CBWPzmKyGN4OavdX3xODr0OLc50hdiInHh2RYWoG+GTbTQ8hzZQqOYNrZ9noIhT895nLpw46RFab3gObZBrwL3u+l45VUJOWMrbvmrsGXo+wcNwHVsLb+0okpXTXfksaLq4jzgA9MEiQo8oJfrNSNDUEn4ZIk2mtYfn0OrQQ31EnLe2InWF6Ko84fURx4A+nunKdlALcZdbGl5neQTI9O97npv/ZzKHHHLIIYcccgjgDwcZt13YvsHxAAAAAElFTkSuQmCC',1185000.00,'2025-06-12 04:44:59.636891','d2e41d82bebf4aa683a8281e7b060f6b',284,9,97),(325,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC90lEQVR4nO2cTW6kMBCFvxosZUlLfYA+ClxtjjQ3gKPkBngZyejNwjbQyUij+REkUCxIt9qfUqgrz6/Kdkz88TV++3MGHHLIIYcccsihc0JWrgCjmVkf683s+dUh4Tm0IxTyj24AiHeMdsJoU9D4EBDvCWKTALC9w3PoMCgWAdCwfNS9BhgfCeuBrCBHhefQblB4995oQaMBY99g3fS/fpNDXwN6nxGCOdBN90Sn2QRzEPGo8Bw6DGolDYD18UWMjzdjvDVitJfcw5KUjgvPod0gJGnpWzaim351qwM6SRo++TM59C9QnjXWVrbgzQRvBszGeGuA9rnX/cmfyaF/gbYasXWRjTS0Ep0kaBMa2pQHu0acGqoZkb/9BLSJbCs0Qb01+a3PGueHyp99/rqnVRkSrEKRE0SuEVeAso8wKBYCCAniXRDveUwtQW/7h+fQ7tDGR+QZYqh1KLn0KBqSdcM14vzQZtbYekyVtFib2tJUE8Qz4sxQzQgltmmx1BWbfKmfekZcARotYPaQrI+hLHIRzRgtkCuR8dboGdovPId29xHdUnAs/WxgW3PSTa4RV4AW99DURhTwlCBpO859xJUg6TVAzo1oVl7VgoPRzIp4fJ1ncugvIWmazfq2mMp6zQbRTEMsqWL9IeE5dICPmBbb2Eoa2lTdQ21F5I6m+4jTQx/KzaGtDexNRTo12hgMz4gzQ4tjXOaKqhEastvcroy6Rpwf2mbEMk1oWdWqS6FFLVwjLgQ1ghjQ9xsw1lvuXRMDZg/fVXcF6KlZvYjC2o/Y2st6uUacH9qc6SpdiNlK79rMIFefsx0UnkP7Q4sorL0HYFn7bBMQX3xd4wLQ0o+Add/1unOq7LMEVvPps8apofcneBgfKVj3GpKIVk535bOg8e4acQHoQ0Z0P15E2aLfJDrNge6HIeJs2js8hw6DNmvgYH0MWN8mGG9N6WP6/ohrQB/OdJUd2HWf/nZJw/dZXgEy/X7M+8v/M5lDDjnkkEMOOQTwE97JkL1SlmoWAAAAAElFTkSuQmCC',1185000.00,'2025-06-12 04:44:59.663839','d2e41d82bebf4aa683a8281e7b060f6b',284,9,98),(326,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADDUlEQVR4nO2cX26jMBCHv1mQ+ghSD5CjwM2qPVJvgI+SG+DHSEa/fbCdkGqlVbcVpGF4QBD7U8bKaP55HBOfvsKvzzPgkEMOOeSQQw49J2TlaiH0YNYvRrCWfCPWCeMu4jm0PTRIkmZgyLdG0CVs7BJAI0nSPbSdeA5tD8VqAEIPwGIMZzNNdSBbkL3Ec2gzqP3wbsO5TQr9LIMmkW9xL/EcegCou5i9nVskXYxBlxo9fPs3OfSIULURnYAICtbIwikB8VU2vL8qD+winkN7QcHMzHqwtxkYzi021jk2suRUYy/xHNraRtwMgMLpYoIEsFQV6O5r3Q++Joe+AmWNMLoZwggithg0SaFvkkHRlzxla/Ec2gnSFM2gk7LXgMVs7C5WnmoyupN4Dm0IUStPTalQ0UkMSrlMpSm/SpJSnqzpwdfk0FegGkfE3qBLrYhtglgyDHJ5wvKU7cVzaD+oEcP5RWb9Ypqqw4D8BISTZONe4jm0FVS8xtUvlH0NJTTl0VTnzU2Z517jmaESGug+cKCrMYPmpoYQMx5HHABaaURRBoopyApSNELShNuII0DVa8xN+c2hkaY81tSsI09xG3EEaJV9FgPQpRJHZDcxA7f+CLcRTw9dNQIg2wiALt3ParIZcY04CqSJJpuHEi6cX1YtVTnr+N3vJp5D+2SfJZRcuY6Sa6xKmB5HPD107aFaWkHChvce6G6fLZZdSegpT4++Joe+Al1zjVqDysHE1X+U1KPxXONw0E0PoEaRtYR5HbBxL/Ec2gpaZ5/XDdASVNYUNF9DrWW5jTgAVLe6E2anckpDU2zz/laOO3cUz6HNodWZrnVRQoJoBrGFVZPdj1iTQ1+CSqYJwGKaYovlziklSsEqvvhu+IGgenQr5xXhJBH6mnoEs3WnxE9Zk0P/A30808VwtnwT0WB4f02CpS19VRuL59BjQPrdg1lfXm2Ecmh8/OZvcujhoLseqrkUom71iFufjFexDwL9Ze+z7HnVrmyttsldI54fMv17zsfL/5nMIYcccsghhxwC+AOvrFcmHcioHQAAAABJRU5ErkJggg==',1360000.00,'2025-06-12 06:22:14.030524','63a8ec2306ef413caf1e32f5f4073f08',288,NULL,74),(327,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADLElEQVR4nO2cS6rjSBBFT3QK3lACL6CWktpBLampJb0dSEvxAgqkoSHF7UF+rHo9aAoXstsKDYyd1oFIHIRufNImfvua//p9BhxyyCGHHHLIofeErFwdzGZm41pfbNgM1nrD+BTzHDoeipKkBWzsJegT+vFNIi5BQJAk6VfoOPMcOh5aSwDQ1L6KVzP9qJEhR5BnmefQYVD35bPRg2YD5jEkiwJYn2WeQ4dDXz1CsHXE5ZKI2qx8/HyWeQ4dDlWP6AWsYPHzIpu/3UysFxkEwQr7StaL78mhPwDNZmY21NV4/ZCNAHEBG9lyqvEs8xw6OkbcA4DgZoKbAZsxD4ESQZ5hnkOHQ+yyyrjcl4M0EXL2qalP5BdJ0vTie3LoEah5RFAuSkx9Anrt/CC7hRZK3cI94gRQXMhiguwby2bE60dxFbKXpFqt+H/syaFHco15CGj+/rMz6BKsl6oc1i5ptpBgHY43z6HDoSoNejXNINXCZdURUoIo1xFngIqOiJKyetjJBSg6Ivc1liY1XnxPDj0CVY9YQnOB2unKV40R0oLHiBNAux8e+hIoiAvc13LcaA1Q94i3hqpHKJWEo0ULSkaa8kOkeIl7xLtDO2W5L0DUcYl7c/yuN9wj3hra9T4tXj9k9EHGOiAICfoFixMwj63a/eJ7cugRKHuEgSFIaB67VL/cDLA8LiEIKfvGq+/JoUegpiypxepWyo5NcmYxsbiyPANU+xp9rUFNebnWpXIe2tSm64i3h1o9AjRRapa1h1GHbksX1HONM0HZD25mfy/UPFRNUPQ30wTY+CTzHDoMqrnGOkC8djmb0Dz8hPn7AnECgw6jT/XmF9+TQ49ArUJVrhoeaj3i3vWI7R5/arw/tD/TNQSRE89eKjMTa0dZe4p5Dh3/1Mh1hvWCYDPlORm2Nqmd2M9MvPieHPoT0NqObg1BzEN5l58aOVD0Nz/3eQLo6wke4qdBvHZJrAYQkgDMY8Q5oH95RO5m5BH9kGjqQaybeV/j/aF9T7MMRKRdPSJP0cir2OeB9uc1uBcp64j+LvH08xrngEz/fc/Xy/+ZzCGHHHLIIYccAvgHjUV1q2s/HJwAAAAASUVORK5CYII=',1360000.00,'2025-06-14 10:33:17.627700','63a8ec2306ef413caf1e32f5f4073f08',288,NULL,75),(328,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC/ElEQVR4nO2cQYrbQBBF348MXsrgA/go8g1ypJAj5QbSUXyAgLQ0yPwsuluWPYEwzCBPpOqFQKN+uISK6qpf3SPz7tF9ez8DAQUUUEABBRTQOiHlsYNOks7D24sk6fwS8wJaEMK2TWPb7itDbdN4xC351u4rz+a1X/ydAvoMaMgBwO30KLlFeZAiyKvMC2gxaPd0L2pwJ6A7A40Bhk/4pYD+D+jZIwy3HU1/HGl82+XbX68yL6CXQbXtFtB52JvudBUMe0vaJw3L9vg68wJaGuokSYfy1+ayt84ATQ/ALZUarzIvoKVXjbuUbbjKcE1f390BeT5hWfMCWhzK1ScwxQMAKqfqs+kru61H0sVRfa4dKh+5HoHZxTM/SG7hHkKPWD+UPSKJU4DbolBlP7DnqlXEiI1A0umq5AcMu3RJ4aE7gFtucjuEQrUFaBYj3FLZbalD02hmAnbEiC1A5SOnHsaYVeyULkAOFGleX0VfYwNQ6XSlPKJ0uih1BUxxwz0RIzYETXUFAM3lIZloLhLdofITtJx5AS0GlTwiFRd5cSh5RJUfpFqjjxixBWhaNSDXGkDZLkFWrSZniDxi/dCkYhs6ZblaDAcM1ajuZERtlOcta15AL4Ik7dAPjw8bYwAYpCJKVLn79X+8U0AfVLE9qzVyPnnfblfKkcgj1g+VInNygdTXKElllid6HoSKL/5OAX0EmmeWT3pESzU1PKrQI7YG1S5BYdiVCsNXSaer3NZ5u4TOLzIvoMWgWVVZmt73DRElhUijLCwRI1YNTQrVw9ef6RF3f5nmhEesH5qd6codjpvSSvJTUu6Qc4t9lhuAsvjQtADDcdpYmdyiSBP1CAzH6GtsCJqObp2pTHcA6ZDb33SSoL7Guc8NQM8neKD+LZrLbjSDcKdqdPe9RxEjtgG98YimxeQt+tWopj+i5iLMcFP0NdYP/eVs+DjpEZ4d58qCVdQaa4fm5zVyPllNm/XvXlL0q/CI1UPyv+c8j/jPZAEFFFBAAQUUEMAfiDyWomkUXpAAAAAASUVORK5CYII=',1360000.00,'2025-06-12 06:25:08.887488','d1713e6aa2f24639bd967e6f5a819c09',288,NULL,74),(329,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC7UlEQVR4nO2cS46jMBCGvxqQemmkHKCPAjeYI7X6SHMDOEoO0BIsI4H+WdjmkV1PjyCCYpHgiE+pyKW/HrZj4ttX9+v7DDjkkEMOOeSQQ+eELF0ldBWYVZPRWRmfsWbIDzSHmOfQ/lAtSeqBOr4UMeO0BlBLIUnSFtrPPIf2h4YsAF0FwGTUGtFnVoaoIEeZ59BuUPk0tvpejuqqXgYgKEYYjjLPoReAwsPs414iaYRaj5w9/PdvcugVoawRQcAA6qyQde8jMNxk9Z/brBYHmOfQUVBnZmYV2EcP1PcSa1aPTbHUOMo8h/bWiEUA1L0/TDCmIcNk2irEy/8mh34OmVVEoYChjHWFPiuwhlyHWnWYeQ4d0I/oJ4MgxagBk1kTHpbumIz67lHjChCx9ZSaU4UgSNQa4zD1pfJncdy++G9y6CdQnGTqnlhuSn0xD/PVhuQ07hHnh/IkU0jqC6ll7RvxrqWIbhG73e4RZ4Zmj4A05z3ECNGSfAOyv7hHnB/aBAeyWxBSzgBZHjxqXATKkxyk1LbOUpDulvQS14grQNs8AiAktSDGCo2kWqN3jbgCNFefWQDS+tZIchBY16GuEaeH5nSBVeEJIXex2/jumeVloG0/YlaLfnaBHmKi2XoecQkoa8Q2e2jDSEovcyGyhA73iOtAsfBctshM87oG0FWTr2tcAMpRQ7njsPQj5j4m5ErENeL80HMesYkVueqYO1SeR5wfWuURcRx9o4e8AJofnDMK94gLQEtIgDBiTRhRO5TQvWfdONA8h3aHNme6ijz7QVI7pH1VpETzCPMc2h+aM0vqfjK1Q4k1+RhPalgNb7LmGPMc2h/KZ7r0aW+KsaKrCllDobQBM26yO8Y8h3aDns90Qfgy6rshBkMMt1Hd768Shpuf+7wAtKo+c+96Wc2Yd8yEtG3Gq8/zQ9sOVTGXoMsmie2CuXvE2aHV2icrFQhpV0TykpAaVu4R54fM/5nMIYcccsghhxz6R+gvkEDG4NG7AVcAAAAASUVORK5CYII=',1360000.00,'2025-06-14 10:35:42.190401','d1713e6aa2f24639bd967e6f5a819c09',288,NULL,76),(330,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADB0lEQVR4nO2cTW7jMAxGH8cGsrSBHqBHcW4wZ50bWEfpAQrIywAKvlnoJ266GBQt7IxDLww41kMkiKHIT1RMfPkKv77OgEMOOeSQQw45dEzIytVDMDM7L59vZmZ23qV7Dm0IIUlikiTFTjBITEpopjxKsdOq3fzgY3LoJ6ClOADN7VU2i/oie5C9uufQZlB/92wMoGBAOAOTAJYf+CaH/g/o3iIE154pviQmXfvy+Gev7jm0GzRImgE7LycRXi8Gy0lmdsoalqS0X/cc2hoKZmY21k+nt5PsDDBFAK451direw5tvWrcpGzBxQSXPPsKI6Z1g22759DmUMk+geYPAOiUs88pdtI8JPJNnn0eHaqTTCfNg/Lsl7Ci2kE2C0VwPeL4UPMR3cosshRx06VuqpX7iMNDTbMsngHyWkH1B81bKOIW8QRQWzVYy9Zzez2tBGz3Ec8AlUlW7PKmxdo9QIkjcrvaxC3i0FD92Q+pbmkMEtS8AlrI6avGc0A1jqiLQ4ksY3EKK2OYaU0efEwOfQda6xFQJ37OD52Kdn2zEreIo0OffISUqOUSFNWqGYPHEceH6t7nkIDlJQGdjGVE0CULr8IYhEETsx98TA79ABRGgCF9KIwBYDEjjGU5sfM+3XNoFxWbKa43MkoyWteSdfD54GNy6DtQjSxv0mQugyhBZY4xp1jL7TyOODz0IbKst6xH5HQzdkWUcD3i+aDwmsqtCJcXM3u9mOahlEvYecfuObQJ1HKNiwGGWPqkML5D+B0FIIMeY0i18YOPyaHvQHVf4xZA3ukRNby8xZi+ahwayj/7WkDZJcIYZXDtxSAIBlWouPauRzwN1JyCZq5W9sW51mN9Wb866SO0Xfcc2h5qR7dydf4IZmPdIQ9mBsPFz30+AXR/ggeGd2N665NYDAXrksLviLG8uI94AuizReTF4WJ5X2OKL9j0Zojlah5HHB/6dDY85xqRkmaUJsnrI54F+lgf0ermWol++weBbBZuEYeHTP9uc3/5P5M55JBDDjnkkEMAfwGJNMgFbu+isAAAAABJRU5ErkJggg==',1360000.00,'2025-06-12 06:25:08.933470','d1713e6aa2f24639bd967e6f5a819c09',288,NULL,77),(331,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADDElEQVR4nO2cTY6cMBBGX8VIszRSH2CO4r5BjhTlSHMDOMocIJJZIhlVFrb5aUWKRh1BB4oF07h5GiOKz59dRYvy5a3/9nUGDDLIIIMMMsigc0JStgZ6EZH7UHci20+HdM+gHaEm/wkdwHBD8BHBp0b71iXBR2BwCQDZu3sGHQYNRQC0m78KmtCOKX+RFeSo7hm0G9Q8HAsetBegvwMhovJP/pNB/wf0GBEKU0OIt0TQqVGYGmU4qnsGHQZ5Ve0AuQ9vSv8+Cn3rlF7eVO6AqqbjumfQblDRiD6PDK60ho83lfDZJAnxBjBtRo4XvyaDnoFyRCxL2QqjKIwCfhT6FgG/Xet+8Wsy6BkIVdVyv0Ncmp1q51UJ0al2PpF3qqravfg1GfQMVCIixNkp+ES2FRrJcVDOi0CwiDg7VB571YRqnJVBE1kecrwsp1hEnB1aRQQhjx9uJRna1UlIbbOIODlUbzJQPUM9LLGxCIVpxBWgWSPK4JDtZahRsvERTs1HnB+qj31WBqf5xlPnFVDbstE0jTg9VG/8JgSKZ4iuRoTO8WIRcXZoLQUd8OAj8pwTn8xZXgVaO8v5xpfpZlzaNvNQi4gzQ6s1y2ohdDNq+DqmdJhGXAfKGtG/j6LdsCTIp+2hy1nQ/+SaDHp6FbvuSiKjrlTOc9NozvIK0HqGkbMZuQzCzZ8oprIDy2tcANpqRDWQxTjMPgJsrnEVqEaElowneT1C09pydr5OPUwjTg9V3zi0ED5KpZT27S/ov8dcSiO5LN+nevKLX5NBz0CrvMYiCqv1iDAnRRejaRpxZig/9rWK0iXAJckV2F5rAeZwS+S2nbtn0FHQLAqrRDiA3CmJLxjedAvt1z2D9ofqO13yI4L+bEGkpaxR9CK5EFfuB3XPoN2gxzd4gEkIn01SBkH791EI3dTAcDONuAD0h4hwiVKi71J+y68XpzBMYj7iOtAqBz4JDA1y92P+BQHt/CgirTONuAC0fl+j+Mma15hL9Gs9jdVZXgES/fs5j5v9MplBBhlkkEEGGQTwG4khpBPXC88CAAAAAElFTkSuQmCC',1700000.00,'2025-06-12 06:28:46.164971','bf0e938e5a6042c0bea1cf4ece269c7a',290,NULL,115),(332,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC8ElEQVR4nO2cQY6jMBBFX42RegnSHCBHIVfrI80N4Ci5ASwjGf1Z2AbSmVl0p0XSUF4giP2ELUqu73I5Jj5d+l+fZ8AhhxxyyCGHHNonZLlU0Ddg1kxGPz+ex9Lg/JTuObQhhCSJVpI0BK0eO8J/Kl58TA59BzSWCaBvAJiMVhG9N1OqSDPIs7rn0GZQ9eHZ2ksV1TeDDECMb+nu4Tc59DOgjxYB9dVoL1UUTBWtJhPjs7rn0NOgWlIH6N3eRH+K0DdBML7JzoCk+LzuObQZlJVlLkG0w78upYEry91DyWssoWz1p6sJIsl/wGRQ38a6X3xMDj0CJYsw6gH6M4ixwiDM8jLEVZOtu+fQ5lDyGtIQBHVEGkpNO5QLtZLrSG3da+wZKh+5jgBB+esr8jEuJUW3iANAs9cISSqIsYowNkB9NQGotxCt/dNs3z2HNoeK11AkrSvyb9l/pLuOIHW1R7GPAM0WkV1H0hFtsoMlChGy1HCL2D20jkck7bhozFQRyk7X4MryUFAWlWan7D/sPFbzHDGZWRNS9PLnjMmhr5TVWqMtiwt1qS7PDJBqfY44AlScw+wmUhRCa0WxGIPriKNAKTtmTpoqiVSg95IVYefR8yOOAN0IyLLSzP5jWITmTUqVzxF7hlarzxK2DkVWaF3WKuPFx+TQIxCrz51C2fMliQll21gau0XsGlrrySU/grr4D+rbaIVbxN6h+xWGlq2tsuO5Dma6RewcWinLfKnvFp6pLLLCLWLP0HpfI08PcR2PoGhMt4hDQTdnukJJoasldWMFpFDEZDfQdt1zaHsoTQAD0F6yCdi5VOT1R8nK/iljcughqJzpyin6J6kc+aygN7OSiPuc7jm0GXR/gofJaC+GGA3B1Wg7MMbfxZ28+Jgc+nZI703e11jtZqQp45vf5NDLQeV71wJGMOpY0Q6/o7XdVAEh0jdDaqWtu+fQ5tDdmS5Y4tlFbea9cs/FPgJk/s9kDjnkkEMOOeTQF6G/J+Su1BLf3awAAAAASUVORK5CYII=',1700000.00,'2025-06-12 06:28:46.185773','bf0e938e5a6042c0bea1cf4ece269c7a',290,NULL,116),(333,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADEklEQVR4nO2cwY3rOAyGP64N5CgDr4ApRelgS3qYkrYDu5R0IB0DKPj3IMtxMofFQwAna9OHYGLrAyiEIH/S1Jj442v6688ZcMghhxxyyCGH9gnZfPUwmZmdc/uw4WaQ24LzW8xzaHsoSpIS2DlIEAr6HjpJqZOd6SRJeoS2M8+h7aE8BwCNy6OYwGy4mUagRpB3mefQZlD/9N0IoMmA6dxBHPlZn374nhx6BXr2CMGtJ6ZfhaibzV//eZd5Dr0NClJNDud8EtPX1SCfxGSnGiMklfeZ59DW0GRmZkO7Gy8n2Rmw3wmAWy013mWeQ1tnjbtUEFxNcDUIV9M0YBAetcSH78mhVyBWVWVM99udNNKJmLq5GB1DqYs1fvieHHoFmj0iavm5Q6HKCqn5wQhIiblv4R6xZ6h5RAKgE4TZQYip9aVigrXTfPieHHoFajoi18LTIPcF8oCgYISEoPQiD9ub59DmUNMRYe5ia2x1KNBpbm8/JZYP35NDr0CLjmhvM1ZygaYe6rrUHMQ9Ys/QKkawBIXZN6rQbMGjfrhH7B1Cy1X1ZHWL1FxgrK89y/KXe8TOoVXWWP/m9VmnexKZvcQ9Yu/QkjXKLCqlshqXgFDW61xH7B5assacMDSGJR6kJWS0+sNjxFEgMztJY7jaw8ObMQ1gvy9mdqarb7/+J3ty6OWe5UNQWKeOtsSV5RGgB30QlgmIVmFUHRFTG7dzHbF76KFDBaz6EePSsxxb1eExYv/QKiXMbapw71i39sQSKDxGHAzKZsRLj74HYBq61rXKPUxfPlV3BGjVs7x3Jn6IykVqeNY4CLQ601XzBzeDIM3TlblnvvcW8xzaHroHhe96UKebJ7BHYG5c5pOf6ToAtJ6hWuRlbVxWjZm6pQgpriwPAD2f4IFsEC99EdnQ9FXQ9HfCyL88RhwA+ukRdMUIVxN0xeKlLxYvhsg309bmObQ51DwiCMhAHAHygMXxajVGQOkNulZ+fvieHHoFWp/XoB3QWI/oJ2gjVT5neQTI9N9rni//z2QOOeSQQw455BDAv+nNvxhxuP8XAAAAAElFTkSuQmCC',1000000.00,'2025-06-12 06:32:52.692221','b9902886aba94b6bb9bcfc17bb424b11',291,NULL,62),(334,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADCUlEQVR4nO2cQYrjMBBFX40NvVSgD5CjODeYIw1zpL6BfZTcQF4GFP4sJDlKejE0ATs45UVoy3pQJtWlX6VSTPz4mn79nAGHHHLIIYcccmifkJWrh8nM7DTXDztcDeY64bSJeQ6tDw2SpAh2ChKEhP4eOkmxk53oJEm6h9Yzz6H1obkEAI3LoyGC2eFqGoEcQbYyz6HVoP7h3gigyYDp1MEw8j0/ffF3cugZ6NEjBNeeIX4mBl2t3H5tZZ5Dm0FByovDaf4Q0/FiMH+IyT5yjJCUtjPPobWhyczMDnV0OH/IToD9iQBcc6qxlXkOrb1q3KSC4GKCi0G4mKYDBuFeS7z4Ozn0DESTVQ7xNtxJI50YYleS0TGkPFnji7+TQ89A5UtWBI1B0hgSWVZI1Q9GQIqUuoV7xJ6hJkZIsZPGIDEolVtJysEjj7lH7B1qsk8bxouJuU8wf+a1wggRQerFfFjfPIdWh2qMCBJZPdQ8FOhUytta4obHiL1DPHzdeTDLBap6yPNidRD3iD1D9d+eVjvm5CI/CFV35g/3iL1DNddQqycZYnWBMW97puUv94idQ032mf3gXkc0cSN7iXvE3qFl1ehKjBhDatolIKRmnuuI/UNNrlEiQ1jiQVyWifrUY8T+oSZGZLmwlKRudcxa3vZc4x2gRlneBYV26ahe4sryHaC2ij2GknhCDRn5NktO8H2NN4AaxXhTD2Wz87ZM1KzDY8T+oaZmWXKNJesoTVPFQep2l3vEzqG2ij1y2wBNVVRq6clftIV7xJ6hO2Wpu32NRlQupQhfNd4Eas505aYprgZBKt2Vc08Z28Q8h9aHbkHh73FRDywHekIit2ZvZJ5D6+uISA0PoRQpa/WyW1YS1xHvAD2e4GH4MhjOfRKzoemY0PQ7YrmvamXzHFod+uYR01EY4WKCLtlw7pMNZ0PMV9Pa5jm0OlQ9IgiYgeGrTzAfStvldEy5z9Kgq4e6XvydHHoGanvpqAc02hb9CLWlyvss3wEy/X/O4+W/TOaQQw455JBDDgH8A4l970Zasj6jAAAAAElFTkSuQmCC',1000000.00,'2025-06-12 06:32:52.710565','b9902886aba94b6bb9bcfc17bb424b11',291,NULL,85),(335,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADA0lEQVR4nO2cX2rkMAyHP60DffTAHKBHcW627JF6g+QoPcBC/DjgoH2wnT/TwtKdJZkmysNMk/gDGwvpJ1lTUb589T++zoBBBhlkkEEGGXRMSMrVQC8i0saPHyIi0u4yPYM2hJr8FTqAeEXwA4JPjYJC/6oIuASAbD09g3aDYnEA2i1ejgJRshlkD7LX9AzaDGru7gUP2gvQt04lKEDca3oGbQ7dW4TC2BCGayLoKOX2ba/pGbQ5hKqqElRVdXBKGJyCT2iHU8DlF4tx3ZOvyaD/APUiInKpT8P7i8rPAQgDSMuYU429pmfQ1lFjLmUr3EThJtlR9BcH+HWt+8nXZNAjUIkaQPYH9XKao0ZQrUHEpzzYosahobLJqokiEnwCfHmmOkDREQOYjjg+VC1iKCoSvCpBi1nMt8VAzCJOA42iqjfRLjZAbIp76AD9dXEK0SpUZ4Bq9jnU4NB51UXhMixiivmIM0B1k33REflhlgvMRW1XqxVmEUeHFjriPrnISYjX4jeyxjSLODq09hFVT94HkVrCNIs4PjT5CGCqQqxiBSytxCzi6NCyQjVtfD3mAPCJ2RhMR5wGynbwLkIuSsT6Vzn4UqUXkeI8vseaDHrkXKO/uJQ7p/JBRr5G0V5c0v7yu1FwSXKv1ZOvyaBHoCoNAMIwaceajNaD8LR6++RrMugRaKEP5tMMsqjMqUc1hg7sXOME0LpmCZ92zHSA1SNOBvmEyOvsFChl645RpPW5FRtpd5qeQZtBU9SoSeaiJOWLbigjJ21hPuLI0NQfsdr9uR4RauNEPfMyizg4lLPP2kDpEuCSwNgoXqEXgHhN5GcbT8+gvaDJKcy5Rh1RhCbEF11D203PoF1yjZJmUM63ZuGQB07xw6LGoaH7X/AQulEI701SYoP24hL5t6Dxaj7iBNAHiygbfxMFlwgKhDdBiaOYjjgP5GspG0Da2CCtvwn9ZZQSRGZt8U3WZNC/QKvT8LlI6afeGZ0bqazP8gyQ6N/H3F/2n8kMMsgggwwyyCCAP5u2szOT+tqvAAAAAElFTkSuQmCC',1100000.00,'2025-06-12 06:34:42.147941','50a1da5aa0344a2980ce228aca912e37',292,NULL,65),(336,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADA0lEQVR4nO2cy23cMBCGv4kE+KgFtoCUwu0gJQUpyR1IpWwBBqTjAhT+HEjqYV/iOJA20vAgr5b6ABIez+PnyCY+Pbpvn2fAIYcccsghhxw6JmR51NCZmd2GjxczM7vtsjyHNoTq9CO0AMMVo+kxmlgLBN13YVBFAGzr5Tm0GzRkB6B2MTkaDJbMIHmQvZbn0GZQ/e7eaECdAd2tkgUBDHstz6HNofcWIRhrQn+NBI2Wb1/3Wp5Dm0NIkgiSpL4Soa8ETUQtlYAqTSyea598Tw79A6gzM7NL+TbcX2Q/eyD0YDfGVGrstTyHto4as5QteJjgYclRdJcKaNZa95PvyaGvQDlqAMkflFEpRY0glSDSxPSwR41DQyWP6AEaSW0T8ycpIvWQ84gePI84PlT+7KcEsm0kgiLpE9NtMhC3iKNDq6ihCJALjvzbb8oleQu3iKNDq6gBZBOYplNZqkhxFG4RB4dYuYKcOOR0gVnUropa4RZxdGhSqGKuNebiIoUTjxqnhPTrAkWpBMK9BoZ68hGj0V0qraDtlufQbip2qTTbNFdqzlRw9O4jzgAt8wilWgNmA4EmhxM/1zgZNNTA8JITyNwVMR98SXRmlp3Hf7Inh/4GSucali7Nw1YHGKOpsyqqu7zVgipa6rV68j059BVoUVKsdKnIfEKe9Yh59sn35NBXoKVmyaRHpKRSkZJHlGzT84jDQwvNMklSmvSIuWMmTfRea5wBmiyiWjVSzYo1sHAe7iMODy36LMVwofTJvEH3o4cgMIY6dexvvjyHNoeyK5hGThwmPSLJ27OI5T7i6NCi+iS/qFPJYKxFI+gMYLhG0ncbL8+hvaCFin2vAaYzDHJrNgwvfq5xAmjZH5H0SUoj1RQ/0oNT/PCocWjo/Rs80LwZ4V5HMdSosyqS3gUdru4jTgB9sIjQInKLfhUJAsKrIYbRPI84D9RM2gNgt6HGbs3D6C6j5SCC90ecAVqp2LNIWVr0S0uV5O9rnARaH3b+2fD/TOaQQw455JBDDgH8BoQNsFzgR3IGAAAAAElFTkSuQmCC',1100000.00,'2025-06-12 06:34:42.167973','50a1da5aa0344a2980ce228aca912e37',292,NULL,89),(337,NULL,1100000.00,'2025-06-12 06:34:11.587092','bdf3dcab635240f89e1e75e856fa0a3e',292,NULL,65),(338,NULL,1100000.00,'2025-06-12 06:34:11.590368','bdf3dcab635240f89e1e75e856fa0a3e',292,NULL,89),(339,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACf0lEQVR4nO2bW2rjQBBFT40E/pQhC8hS2jvIksIsaXZgLcULCKg/DS3ufPTDj0wmBGRhQRVGRu7zUXCpruqusomf2PjrRzg477zzzjvvvPNf8VasB2KPmfXYgdkg1rXDiv44vzAfJEkTMO6BMM0GdLIDnSRJt/yj/XF+Ib4v33EP4Q9YEOQPzHnVoEsr+eP8o/nYY7afzcx2nw9Pz++/89fW3/8w7jtE3InxMJuI6/rj/GP4QdIRICjB+Ho2e5dkB0BSuucf7Y/zy/AlfkcDoAPiS7Jw2smILwmYbU1/nF+Wz/pe5dnxNSHibDCkVmmt5o/zy/Lkw0+YAOgkTZ10HFJ7bQuSdHw2/53/xopudIKhKh2ayGHqVB6u7wb5ou9dEDdpdRwkghIev5vka311AMbXfKthCqceQYJ2ybGSP84vy9f8m+O3q8XUIMGQqAcnz78b5eu+OyTKI/9cSqvyOiQ8/26Sr/l3gpp/y4WGVEsrHQd5/G6Tb/tzjd+Lqm0hn4Rd3y3yV/Vz3pDvVM2hO+H6bpPnurl7ScIXVSco1Zfru0H+un6GVlBl61RaC74/b52Pfa6q7H2CKujZzPalkrbDqv44vyw/nI3RdvmSUjr1lNdYBrNKYD+r/85/Ybo1oNMl4d49fH/eGt8mrADoksa3CWDulXvC8SUxWmsTPpv/zn9jl/rq+uibG0aplc5eX22cj23CGYDhbPptOzGaGWMeh17TH+eX4f8xX0cZfQ6aDYaPXldNpGfz3/n/2yd9ATS+fZhy1o07WTh6/t0oX/UdBMQqYzj1WNDcG8PZ5+s2zN/cT1JncWjzV63n4PXVJnnz/3c777zzzjvv/Or8X67pB6siAznQAAAAAElFTkSuQmCC',1185000.00,'2025-06-13 14:13:36.604801','20d85a309fd0407f8a759ac334fa2953',284,9,97),(340,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC+UlEQVR4nO2cTW6jQBBGXw1IXjZSDuCjwA3mSFGOlBvAUXKASPTSUlvfLLob44xmkUmCE1wskB14ohCV+vmqsYl3b9Ov9zPgkEMOOeSQQw7tE7KytQBnsyEfPJsN0QxiPWG4iXkObQ/1kqQZzKxFI2czs0MuO22gkSTpGtrOPIe2h2INAP1cXABCQmNIaKS4ys3Mc+hmkJ6OCYhm0kvxEhu+4koOfU+offPdCMB0TC3QJJu610+6kkM/A6oeEQREoH8+CGIL0++TQTwIIqyVrG9+Tw59AjSZmVlX/mgDjezx5aBaVpxzq3Er8xzaOkb8JWWHk2k6nozpmCgR5INXcuhnQJSuMiSkefkK0M+NyikzuQnJPej4ze/JoY9A9SEHSWPI8aBuc7PsQGOQsm7hHrFniPr0uY4R1Q8k5WKCXu4R9wPZQCOmY6qaZUgAjZg6YOoaabydeQ5tDumpg0tzkbepA4hF1Ia8u4V5Dm1fWZaUsK4j6JVy9ZArS7yOuAuodp/xIUF8kBENCDNM3SyIhgjC8qeNzXNoc2hVSpbwMJNHW7X1SLkPlZS8+7wDaN19al7c4jL5rh5Rdu4Re4eu64iqVY11QUSNFkuD6h6xd2jxiLIM4lJAFs0yLDkF8Bixf4irULBI2TPUaLGWK90j9g8tHlEqhVWaWJTtyymeNfYPvX3cpa/IvlELzdVR94i9Q1mPMMIMxA4RwfpnAM4mYpus19nonx/S5uY5tDm0dJ9pqSNq6igTz/WY3LPG/qESI/oZGbQYNABNsqxUcpABGOG1dc1y/9D6f39RL8unizh1dcBjxB1A/3inq7y0kRfiEk4++7wfqNdFlUx5OK4xtujJzIpb3NA8h7bXLGfKQGs9/q7LZoDqNJ417g2yxxczpqOqKBFOVpSJSzr5Yffk0EcgPXWN6F9abIgtNrwpJm5snkNfDq1mn3kaXvIHdfBF83ZxlWeNXUPrFzSWmqEUE1W6qmuxfcXMPUDmv0zmkEMOOeSQQw79J/QH7VOuobitP/0AAAAASUVORK5CYII=',1500000.00,'2025-06-13 18:23:58.165663','43dd74ce2920465c826dffcebd7615b9',287,NULL,109),(341,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC+UlEQVR4nO2cUW6jMBCGv1kj5dGR9gA5CtygR1rtkXoDOEoOUMl+jORo9sE2uOm+dNuFFoYHFOx8woiJZ+YfO6K8+5h+vJ8BgwwyyCCDDDJon5CUowO4iwy58y4yRBGI9QvDJsMzaH2oV1XVACLSoSN3EZFTDjtlwKmqqr6G1hueQetDsU4AfSgmAD6ho0/oSDGVzYZn0GaQ/r4kIIqoXouVyPA/7mTQ14S6h2vBA9MldYBLMp1fPulOBn0PqFqEVyAC/fNJIXYwPd0E4kkhQqtkffFnMugToElERM6lUQacyq/rSWtYcc+pxlbDM2jtOeKNlO1votPlJkyXRJlBPngng74HRMkqfUI1zJcAfXBavhLISUjOQccv/kwGfQQqL1k11dfta4sGN59AR6+adQuziD1D1Q5wSh8WIcrpMinQB7KIZRaxf6idI4oa5epEEconmDVLs4ijQNPZqQyxJBe1DSAWURvyaZPhGbR6ZNlrAnyqFY7aVmcLAIsjDgFVrxEAcKojkN8+XvPlkn9YrnEcyCdU9Zb9go5RJBdAB5+QIXaoatpueAatDMmAU6Zc3XTZOcgQ26KHDPGkMmwyPIM2iCMCTcyQE46Slr7qMK+xe6jVLOfEs2gPwWmJKHBVxzSL2Dv0RoPKbQGqlbRypVnE/qFZu651jSxT+apn544qa5rX2D/UZJ+NZpnlStycgppmeRjosdhZnYirUkRwRb/qgzOLOAD094rnCK0TWdIM8xq7h7LkIH24l7Uz01MCcEnwisBJBUDwL52uPTyDVofa337xH3NJ3Le+YumwOeIAULOnqw/Lnq6yaSMvxMXfrPZ5AGiufdYQYl4vVQQrqELFkod+8Wcy6CPQK4WqLpFZFCoe5EqziMNB8usqwnSZsw5/k6JMLFuEv9kzGfSe43FPl04Xhf7aJemffybBOwUfgHhef3gGrQ49xhG5MZdC82c3r7Ayr3EEqNUs57ffCFZjTkEhd5hF7B4S+2cygwwyyCCDDDLoH6E/+xzhEvtgx8oAAAAASUVORK5CYII=',1500000.00,'2025-06-13 18:23:58.213085','43dd74ce2920465c826dffcebd7615b9',287,NULL,110),(342,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADA0lEQVR4nO2cQW7jMAxFH0cCsrSBHiBHUW4wRyp6pLmBdZQcoIC9DGCDs6BkO5nFoDOF09rUwnAbPYQGWIr8pCvKh1f+8XEGHHLIIYcccsihfUJSVoTcgkg7Sb0DuQx1w+Up5jm0PZRUVbUHkl2CwhCx30FQVVW9h7Yzz6HtoaEGgNwCMAmpn4QsEe0AiyDPMs+hzaD48LOkaxw1t70KhPETv8mh7wo1N5HXa0RVb0LSW80ePv2bHPrKUKOqHaBvclLyeYQsJ5XLcLLsQVXHR2g78xzaDCqnRhYAApL6F0i/4mh3ZU3yHPMc2hwyj1ikbM3nmyiMQDOiDKDrDdua59CTIJEWyCICQ7S6Qt9qcSGXectzzHNoQwjTGZKOQKNqegQASUfTIyyFSH3ZrN0XfyaHPgHKclLSNUI+zw5CUJGzagkPjWeWR4Dqn31TLiZXWjywu1A+LdHCY8TOIUsVJF3jCIOguUUUxkipMCZRhjiSfyqSum3Nc2hzaI4RtbjooKQQ3WpX0BIyPEbsHaoeQbALENR8Y32cLDmme8RBIIsRtyJEpT6o9cBfe6zMEGmDyuVJ5jm0GbSuPi2LtGgBQHgsSz1G7B+684hlSGKRInqKq5R97hE7h1aZZQkPNcd8XMkzy0NAxSO0D2qHA1WUqNGiShEd7hFHgKjTcrXMSHMxmuoxscoyPI/YPbSaobL+Zm7fIzQATBGYYv0A0a3Nc2hzqGaWd8dE1armk4TgKvZRoLnWmAuJ+eiwjud9U9TziN1DqzzCpupWNWctQW0VL3GP2DmE3q+qTFQ9wvqhcwRxjzgItHqnq1QdUFKIocxVsRq2/BbP5NB/QYtcaW/wDBG5MIm86ixYDSfvaxwIqu90lRH9syq5rRqFDWDOfbDv8kwO/Qv0+E4XMEXSVVAboBGA5j3C8OLvfR4A+sMj0jWiuQWBcrGV2+AzVAeAVnrE0tyo81K1H7r0wbzW2D006xGA9TX6pQF63ybX0TXLA0Cif9/zuPw/kznkkEMOOeSQQwC/AR2qgZ/HCvdFAAAAAElFTkSuQmCC',1500000.00,'2025-06-13 18:30:14.607457','e9d42e6bdabd4d41a900862762ea2234',287,NULL,110),(343,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC40lEQVR4nO2cQW7jMAxFP0cGunSBHEi5wZypR5ob2EfJDeRlABl/FqRkpVm1KZxUphaulfghMsJSX59yhPhym/98nQEccsghhxxyyKE+IbE2ALOIyHkRkTNWaboiInJ+yvAc2hEa9E+cAGA5QTAmCMY8EMuJEgkIEDIAQPYenkNPgxZLAJy298ar8OPdXtMM8qzhObQbNHzqC0aAswCY/yZKTD/1SQ79DuhzRBBYB8R0yogXKd1/zxqeQ7tDIEkikiRTIGIKBMYMTiPJCUHfaK6bXvyeHHoEsoiwViLi7lAu8IjoHtJZY7OyCVyFwFUArIL5PYDtBfsOz6HdoTZHtCoy6IRhSUEnkawXe47oGqoREWjCYcwAyhmZAMQUaGceEb1D5d9+ZJELI4nIjKIxrUvSc8QRoJIjtsxQ5KUuPQBLD3bwiOgdKqtP/fZR15wANBhKK4nCI6JzqNER5kIARS4Ajdo0t8IjoncIWwJATJYjNDZsOmFxqJLPGseBOC1vpiKxDEC8DNAzbWMG5vfAG2i/4Tn0hLWGdopwqF2dNSJtJeI5on/oRllWUWllDsDsCdzUPzwijgCNGZx0mggEFhE9i5c39apERMSSxy+5J4e+A1ldY5aQJd7v1Bc1KpYBnM8hi+61evF7cugRyKQB010ho62Ql4nFdUT/UKsjInN9OZBkhq1DE26Mihe/J4cegWpEAFAJoTWvjC1loLGyPSJ6h5ocUcpdlh70UAvh2zrUI6JrqPEsizVZc8RYShraqrbwiOgZKsqS9dtvRCVg9na1InzWOAjUPNNlVdBV1NSeZfOzV3nS8BzaH9pMyg+pNhVWUXlppsSb1zUOALVrjduN+VvZUy+s84fPGl1Dn5/gAZYBEi9DJhZB2VyVIFhOniOOCNk69Gp1DWAVxIsIJ9cRh4DununSrbYJdSNVKKa2u9iHgO6e6aqeZdERwFbr8IjoHxL/ZTKHHHLIIYcccuib0H9iRtzYjzBy+wAAAABJRU5ErkJggg==',1185000.00,'2025-06-13 18:57:39.664207','69250b87dd6e454298fbaaccd5e631f8',284,9,98),(344,NULL,1000000.00,'2025-06-13 18:58:06.113279','29a92e1c499b454e97c6fb99edb313d8',291,NULL,62),(345,NULL,1000000.00,'2025-06-13 19:05:21.421569','fa8fc272854b473fa2e1ba47ae9a4add',291,NULL,62),(346,NULL,1000000.00,'2025-06-13 19:18:56.649538','03ef3180572949f4b15344aed2e7be51',291,NULL,62),(347,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADAklEQVR4nO2cXarjOBBGT40MeVTgLuAuRd5BL2m2Zi+lF9AgPwZkvn6QZfumB4YmTZK2Sw8ONjlEQsVXf3JM/PYY//l9BhxyyCGHHHLIoWNCtowORjOzfjKzntl2t2Zm1r9keg49EerqRxoApg+MmDFi6QRBQCgwhQKAPXt6Dr0MmhYB0PDrd6wHqoL8gV9y6L2h7u7eiKDRgLEH0n9lp2++Jocege4tQjB3pPxRSJo7wdyJ6VXTc+hlUJQ0ANZPFzF+3gwIYrRLVQlJ5XXTc+jZ0GhmZtf2NH2/yPqpw/7NYD1zTTVeNT2Hnu01tmBBcDPBbdn98YpB/BpNvPmaHHoEQpKW/U55exykgSBSDtIQC/UiSRrefE0OPQK1TQagbfwSVmy3gJSB5BZxdGjViNAuUSKpQMpBJGkRCsk14gxQs4hYmgBUX7EkFxqi2si4RZwAapHldJExXRExo/EKBkG2xBZzRxpKK168+ZocegRaNCJtQpFZ1WIragdJzYm4RhwaQruRWaIHtryCIA1Rqydxizg4tMs1lo3XuvsZWOQBqm24RRweal4j05KLHLT5is2JuEacBLrXiGoMaU0udvWIFm+4RRwaqumDpXwFpq5YEixZB6EYMYjxW67NcT17eg49HdrXI2jlyi2O2Bcz8VzjDFDzGlFLfllbGq1g1S5LCdPjiONDa3xQ2JJMaoahUjVCWqNN14jDQ2uusaUZrR4xrG2OLQV1jTg8tLMIadffKru+Rm2Feu/zHNB6znKuR2QEBY3XHzB+yyLluYPJgOh9jTNAX6rYW61qK2prH2O61zgLtH+n61OiSkaUGK0Dpg5WGflL1uTQQ9CuSFl3PywnsNdAE6aLvkLPm55DL+9rtHhyaZPDzn+41zg0dP8GDzAb6XtXxGRotFDqWz1MH64RJ4B+sYjxUxjxZoJQqG0OgmCazfsa54HWtmeNIqcO6+PNGK8g6WaM1+AacQJo/74GWy9r63mpHdb3s9jngEz//5374f9M5pBDDjnkkEMOAfwEYhCi+90cu9IAAAAASUVORK5CYII=',1000000.00,'2025-06-13 19:43:27.575706','dea3e8651b8c43a5b5a0221c36348549',291,NULL,62),(348,NULL,1100000.00,'2025-06-13 19:47:45.631610','3d80bee55cf94a8aa0a68611de2524d0',292,NULL,89),(349,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADA0lEQVR4nO2cTW7jMAxGH0cGspSBHiBHsW82Z+oNrKP0AAXkZQAFnAUl25lZ9WecNKYWKST3IRLMUuQnqqJ8uKVfH2fAIYcccsghhxx6Tkhq65BxFhHpQUaoXRsTERnvMj2HdoQ6+zFMAPMLEBVh7oqm/r3TdFZgDgUA2Xt6Du0OVYtg7mF4BZKAwlWADgFBAQSqWTz8mhz6dkhEOhhyUIb8X7/JoYeHdIoFiAWdANK5/MP8tDU59JHWdo2owAwCJ5Xh9aSkEVHmk2lYWyXrwdfk0DdASWqGsW4T8jsHlRGQkaulGveankN7+4jVASgzQLyIpj6g6XwRvfUQD78mh74OmQAh0kFNMwDiRWA+qYxcxdzIeJfpObQjhKqqMthHQVWLbR2qOdSxKRbrWpsefE0OfQWivuUMqnkdK1Qrya27/rJbxDNDi0VUf2CJp+agmxTUWixuEQeA6q5BVAWC7R91DNApVg/SNha3iCeH2p99XN1DezCxaJbNLNxHPD/UXjKYbK0Ti3BJ0E1E4bvGMaAWR5ijuI0x4+I8gHU7cYs4BNTKIEjnJayYm8Q95GBdGe80PYd2g5oekbeHXPVBDk2qjFWocB/x/FDLNQi6HctQdw1WecIt4jiQTvEimxiztqvIGAsifTCjkfEu03Nof2jIQUnS2YkntMRTJ4LqNHfA7GefR4AseJRhunZKzABXYZguohBUhjcB4rto6r2q7gjQRsVepQiLMYcmXdWdxPWIQ0A3J13rsacutXSxChWWhLiK/fTQkmuwnGqF5jLMW+iSgrpCdQRoq1kutlEf2AHotnrCfcRRoPVOV62O0WJ1VdVvzB0k6Vr3R6zJoa/kGuudLiECEFSA1jUxM+8/PYfuBs2tiHJ4O2nVHqzOsrNK7e1dnh+yJoc+A3V/9TX1CMTSba9qzC9F7CLgtO/0HLo/NOT6IXIuFj1YS+ficcQBoE0t9qb4WjMbXapVzHj2eQSIm5wztBe/Vt5aUKmbPNQt4qkh8f9M5pBDDjnkkEMOfRL6A6SYZW6clD2PAAAAAElFTkSuQmCC',1100000.00,'2025-06-13 20:01:40.354619','9dda0ccabfb44aa2b795a6d6683177cb',292,NULL,89),(350,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADBklEQVR4nO2cTW7bMBBG31QCvJQAH6BHoW+QIwU9Um9gHcUHCEAtA1D4uiCpH3dRBAnsVBougojygyloMvPNcBgTHx7Dj48z4JBDDjnkkEMO7ROyMloYzMwuY/1htv3tKctz6PFQkCRFsEsnQZfQlUaE2AhoJEnaQo9bnkOPh8biAHRd7nUJ/eonAyB7kGctz6GHQe3dtdGBBgOGCxAEMH7BNzn0f0D3FiGYWkI8J4Kmtlz+ftbyHHoa1Em6AnYZT2L4+W4MfSMzO+UbktLzlufQo6HBzMz6OhtuJ9nrrYUQwS5MOdV41vIcenTUWErZgncTvOe3r6HHoNvWur/5Mzn0GYhVVhniMt1I10415+wSunYpf1jXb/5MDn0GKhaRyw71xWdZoUi2Eik29dItYu9Q/bPPyrJ4BoJSdR61YLXMuUUcALLXm1l+8YwtMJ5yJNF1bCmmMnqF6ghQUZbDz9QatMnoYtWTNMlyhYqpJVxTNYlv/kwOfQaao0aiSMlIlQvUonbIOqKR64j9Q6tcoxSiZo2ZJadqwpE1plvE3qFZQM4+Ynn7sSlqU5EiJtwidg+tXEG2g6wi871GpXbdJdxHHARa6YhiFkqrdok8so6Yg4hbxJ6hkj6EiGwwgPEsY+wRNMmgSXnjC+Zq9zd/Joe+Cgqaa5arMZm9xhJO7PLE5Tn0EGhVs1zrySWIxCom5tDhUWPX0KpYnc2ijGIHxTZiVZuuI3YPbXa62Caj235bzzWOAW2yT5Vtz/WuFlAKVhH3EQeA6lbF2Od+Ww0voKF/g+HlrSUIjLHF6Hxf4wgQ2o48Odcjiqjc1LPdRxwAWp3pgkbAZNBJZS5vhE/eZ3kc6M4pFLMoVYjaOHHyM10HgOZcg5xklkyzWzqnlkiSXFkeALo/wQNMRri1SYwtGqxJGl4ixnh2H3EA6C+LGPomUVr0m0SIZyzcDDFO5vsa+4c2jTG5WWYOItqUqbyKfQxofV6j6Mm6rzHXqkrjhJ/XOARk+vdn7of/ZzKHHHLIIYcccgjgD1ZBrgrBpFnzAAAAAElFTkSuQmCC',1100000.00,'2025-06-14 07:38:49.643299','32bcfebdbb234c27935c72985a1a9a6e',292,NULL,89),(351,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACUUlEQVR4nO2bQY7bMAxFH2sDWWqAHEi5Wa/mHCUHGMBaBpDBLiQ5ToKZ6aBpGhVfCyGx34IAQfKTks35zjr++BYO4sWLFy9evPiPeKtrBJIZRxuxQzIrm5mZHZ5oj/hH8bi7O9Hd3efBfQoZ4gzAUJ9dkOnV7Bf/e3yqEWoHAEKG6Of6rAT2U+0R/7f4tHOOb8DRdvfN0+vbL/5TPs6LEU8794nFfPrX9oj/I/62/kLI+BRye6H6+z/wRzMzewPiaef287RzO6QRYCny+bn2iH8QX4TTVZ1dzEkA4Wx+8+7l7Bf/xWppGFgbopqky9/1hfJzhzzVcZ6B4N68OjjRc4NKuyT/9sc3/85D0VIQtuFM9MxlyCH/9sZX/07Fl1eTrO2LjPzbJd8GU2HGSfvspH02wrkJ5vBufrShqaxXs1/8F6vl56tKXLveKrI2ga347Yyv+rnU2hk2Cbn8WuW08nOPfPNvaFtc26W4iui6yb/98et8sjW8U1j/lkmlu0+g+O2T34yZa4QClyapzDcUv93y68HuYk06v4+QDAiOxSmPgPRz53zIbeMyn4RyEgyL7uf0yV/l5/l6HB3cbzjl5974teutazOr8laTNX/ul1/7X4Cmn+uQo006Lof88m+nfGxDLDskM0gjdSuF+azz/T75bcHdxmptfTeg8nOP/Hj3JGQMBrd4MiDMAEvjXs1+8Z+ve/+mfS6nRuVqTqqZ2Z9jj/jH8nffLxQZFZp+rtJZ5wud8rf6uVzS8XY1p46epZ975U3fd4sXL168ePFP538B+PNIl5Jndh8AAAAASUVORK5CYII=',1185000.00,'2025-06-14 08:02:39.991662','bb4f1063ed3f42ce9c6c32edd2e1d3f5',284,9,99),(352,NULL,1700000.00,'2025-06-14 08:03:34.336555','52899571a1b9469c84d8599b61ed3f8e',290,NULL,115),(353,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADGklEQVR4nO2cXYrbMBRGz60FebShC5ilKDvokoYuaXZgLyULGJAfAzJfHyQ5nrZQyrR2SK4ejCP7kCu4SN/9SUz89Zi+/D0DDjnkkEMOOeTQY0JWR8BsALNhMSYLlAtze+F8iHkO7Q9FSVICKQHMJwGLQZ+xM50kSR+h/cxzaH9obhtA2RT6q9lr2r5oZuE48xw6DooJNNKJ6UWCOaDxv3yTQ3cJhV9m+ozFBJrOBlFg8e0o8xzaHWoe0QuYgenbe2AaEgZdBpYgZthmsu58TQ59BmKrGOlETL+7tBeiJI13viaHPgOVPWKzAUwvV9M0dEB/tTrZf8x13/maHPoM1PaIPkNMnTS2uzYHUmrRp+8RDw+tHiFJqi5QRrnrM0StvuEe8ejQVkdsXCDRNEOfAdbNwz3i0aEaa8RxCdDnIFgAusxkoJgWxPwVg9D0xp2vyaHPQO0goOalyp2Uaz47KlOf9q4jngGqp0Ys2rH5ATQHKdqiPXAd8fjQqiO6JiZKSNH0JL1UfaMFHO4RzwCVakafYRqA4iBzaBozLVbK5OdjzHNo9wzV9JKxeDmJ6dsSNA3vAeiyAVh867KV4vjO5jm0O1Q8wiBkQY00LaYFpoHqAjWFmdrnO1+TQ/8AiroazFYv9egAfR8W09hfTbp4f8QzQGv02anGlyWBfWup6urdiMcazwBt6hq3tEONQ1WTlOWpR59PBcXLqewMv8QVs5mUKC25R5nn0AHQYsRLaNHnHNA4n2oBdBpqtsLOR5nn0F7QpofKKFUtII5g9FcT83CkeQ7tDm1qn7fu/FtJ4+f2KdcRDw+hj+PmAiXMWGvgLbPtHvHg0JqhAqDLYu6y0b8Hi+PVarFj/pq5lT7ufU0O/QOoHAmpzcaSjepkr2t/HXPAzseY59DuOqIWtLo1M9GpCYemNktSwk+Np4Ni6mSvaTEmM6N07Cu3YPRo8xzaG9L4oa7BNNSKp53xfMQzQX1trbNz+1iDi8tJ+j5QmiQOM8+h3aDf/qar1DXG/lbcaN1UriMeHjL9+Z2fh/8zmUMOOeSQQw45BPADEMNKkaJouwMAAAAASUVORK5CYII=',1200000.00,'2025-06-14 10:05:36.289959','33f7af899a5e490c9e5b5e0b5cc01baf',284,NULL,100),(354,NULL,1200000.00,'2025-06-14 10:04:45.360353','25331d41f10c49f48d36419c3899b286',285,NULL,75),(355,NULL,1200000.00,'2025-06-14 10:04:45.363131','25331d41f10c49f48d36419c3899b286',285,NULL,76),(356,NULL,1200000.00,'2025-06-14 10:04:45.365407','25331d41f10c49f48d36419c3899b286',285,NULL,77),(357,NULL,1250000.00,'2025-06-14 10:04:54.956395','dc83d42260124a598569a29301822942',286,NULL,78),(358,NULL,1250000.00,'2025-06-14 10:04:54.961612','dc83d42260124a598569a29301822942',286,NULL,79),(359,NULL,1000000.00,'2025-06-14 10:39:53.981795','55459939c33f41f1a9cc8ab511f6eb92',291,NULL,86),(360,NULL,1000000.00,'2025-06-14 10:39:53.984867','55459939c33f41f1a9cc8ab511f6eb92',291,NULL,87),(361,NULL,1000000.00,'2025-06-14 10:39:53.988657','55459939c33f41f1a9cc8ab511f6eb92',291,NULL,88),(362,NULL,1100000.00,'2025-06-14 10:40:07.343083','dc68ab73cda84eaca4549e3b50ebc2e7',292,NULL,89),(363,NULL,1100000.00,'2025-06-14 10:40:07.347307','dc68ab73cda84eaca4549e3b50ebc2e7',292,NULL,90),(364,NULL,1100000.00,'2025-06-14 10:40:07.351738','dc68ab73cda84eaca4549e3b50ebc2e7',292,NULL,91),(365,NULL,1200000.00,'2025-06-14 10:40:22.433424','5452ca00c3ed4821a959701f8e476aab',285,NULL,75),(366,NULL,1200000.00,'2025-06-14 10:40:22.435817','5452ca00c3ed4821a959701f8e476aab',285,NULL,76),(367,NULL,1200000.00,'2025-06-14 10:40:22.438902','5452ca00c3ed4821a959701f8e476aab',285,NULL,77),(368,NULL,1250000.00,'2025-06-14 10:40:28.657891','0584432255674fbb95f7ac3ee7ea5cea',286,NULL,78),(369,NULL,1250000.00,'2025-06-14 10:40:28.661992','0584432255674fbb95f7ac3ee7ea5cea',286,NULL,79),(370,NULL,1700000.00,'2025-06-14 10:40:41.370775','fb0bad6b219040e2a4a99594466fc400',290,NULL,115),(371,NULL,1700000.00,'2025-06-14 10:40:41.375268','fb0bad6b219040e2a4a99594466fc400',290,NULL,117),(372,NULL,1700000.00,'2025-06-14 10:40:41.378916','fb0bad6b219040e2a4a99594466fc400',290,NULL,118),(373,NULL,1700000.00,'2025-06-14 10:40:41.381801','fb0bad6b219040e2a4a99594466fc400',290,NULL,119),(374,NULL,1900000.00,'2025-06-14 10:40:49.801486','71282673a9b44e2fb99c22d589ccb5b7',289,NULL,78),(375,NULL,1900000.00,'2025-06-14 10:40:49.805099','71282673a9b44e2fb99c22d589ccb5b7',289,NULL,79),(376,NULL,1360000.00,'2025-06-14 10:41:09.285354','77182d73dbf64736933e04948c0a22ad',288,NULL,75),(377,NULL,1360000.00,'2025-06-14 10:41:09.290084','77182d73dbf64736933e04948c0a22ad',288,NULL,76),(378,NULL,1200000.00,'2025-06-14 10:41:54.450719','3a9004bb1c4d4ffa9d71952e2cea24ae',284,NULL,100),(379,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACjklEQVR4nO2bwW3cMBBF3w8F+CgBW4BL4XaQkoKU5A7EUlxAAPFogMLkQEq7aye2A6wVCZg5CBL1Dh+Y/dRwyJXxL5G+/RMOzjvvvPPOO+/833i16CCpgzTMgqx6qXHeUI/zd+ajmZlNQJyA+NwBvRkQzMzMbvmv1uP8nfm8ODQ9FqAvSMMsAKqxt9Xj/Bfx1brQnPzf9Th/Xz4N7WI/9fB2cbx7/c7fxGLW3oAMAlB87iBOg4hPcJ3lvel3/lN8kiQNrLNyMJ0JBsy1fN5Wj/N34qt/Lw41cquqLA0Bu3Xv/vQ7/0HUxU+0go2E5a5vY9CXitQY96bf+Q+iLW77llUb63AwqI/BlnR7fo/HN3OO9aHl8uJp6Et74f49Ir/6d8nqVZKnsBib9XewN/3Of4qvVXOWgFk65w7psUB8frClU7mhHufvxF8XT7eVlo194WJs9++x+Vlt60gd+mEFyA9t/XsGdN5Wj/N34Zf+VT6Zos0y8qmQFAowizjOAPPC7U2/8+9HzZsgYOQB0b/IlrEiAEvDr6XNsTf9zn+GN5tA57WMilMba5N07tB5Qz3O34t/r381hbpcqqD3N47Ir/3nYKKf1m7z3FkaqMsl4ujf34Pyi3+nUM/nXFob16dywP17TP7t+ndakrx2nWuT0vN7RH6tnwEIxdIQiqArbSifCuTO6+dj8mt9tTSca1VVu1bNtRfO/Xs0nsusXD/CI+vdpeu8Nik9vwfju1fPglBIQ0D0QHw6FcVx7nx+PiT/Or+Wvk8oLudyDF5EUjDFcQs9zn8N36+b/Lmj7hSmYZY0BLOxf1F7u1f9zv85mn9TraADgllGDgUIpvgkPx97YF7+/27nnXfeeeed35z/DeAhyvS/T7P7AAAAAElFTkSuQmCC',1185000.00,'2025-06-15 08:04:53.371264','df800a0388ed4bb6b8bcea1ffa243cf3',285,9,75),(380,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACkUlEQVR4nO2bTWojMRBGX40EXrbBB/BR5CvPDbqPkgMEWsuAmm8WktoOyWQm0GncULUQ2H6LDypVUv3ExHds+vUtHJx33nnnnXfe+b/x1iwCOWJ2Xgyy1aPabUc9zm/MJ0nSDDC8GeklAoMEBEmS3vM/rcf5jfncI3Syk2AoPYiBFti76nF+Gz5+9mUN1jQu++txflv+g3+TFoPhFU0WPhbHz6bf+f/jB0kjLRdLLxHSvNScLansrcf5TfnJzMzOQJqD7EY7gKU+n/fV4/xGfM3P9zwscj+mc0CPv+2hx/lteWrxk1TQSKhP51oaJRVgKBWpNj6bfuf/YffitrlwBmkO6ndykMbqbvfv8fju36FAmuHu1Xv8sjY53L9H43t+nqHm4hqwBPUgLmjsnPv3aHyvf4cSRT7JksAArMb075NgmPfS4/zP8DnCdH2rA4V6CY8sxnRdE/euepzfhn/oXxmcxHQV7dbNJxkskTSCpXEPPc5vy7f6d7qWKFiMNIO1hLxYb0Iv/e/g2fQ7/7VVvxlDkAFoMtB0i8UglPbd+bW3OZ5Nv/NfW+9f5VgES6xPqzRfEPkC5IvqzN/z8xH5tX8lkebQ2xhD/wh9iOT9jSPya/yeERQgXwqwRE1njH4J+/17TH7tbwQ9tDE0v9/KAY/fY/KPw4O1k6Vx0EPXuXUv3b8H5Pv7uVooqvVvjn2iny8FcvT386H5dX/SbjnSxw2L9fnC3nqc35jv+5OS+n7sdA5iMrO+KbunHud/hjeziN2gHq1mmhffzzkm/zgfbI/oPtpv1ua//r46JP/Q32hVUT1AY9/U0bgu6bh/j8mv+5Nm14K11ckg0su6OrmnHuc34s3/v9t555133nnnd+f/ANoTu9M+afNoAAAAAElFTkSuQmCC',1185000.00,'2025-06-15 08:04:53.397709','df800a0388ed4bb6b8bcea1ffa243cf3',285,9,76),(381,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACiUlEQVR4nO2bzW3jMBCF31sK8JHqIKVQnQUpaTuQSlEBC0hHARTeHkjKsrOLJIismMDwIMPyd3jAYIbzZwpfOcOvL+GA8cYbb7zxxhv/P575NACwEgMbsMNKYC6/dSfqMf5gPkiSJgADL+LrtFJvrRMAJ0nSLf9oPcYfxDf5c26B8Bsg/AQBsWEYCQEAARdP0mP8w/mVZAvorXVi9/N6jP8G37x/5QTMFxFYKczn6jH+MbyX1JeX5MtCBCn5r6R4zz9aj/GH8gOZojLC2ABhvAiYczpNkjxXj/EH8Sk+75qUw0sEUmhGBOBvG5jPpt/4D04qfsIEINVCE6DeSylm6/qDJPXPpt/4z/DqfQTglxykMTeQRpIdnBAUwe5EPcYfxW/+61J+lVw3KEKanBAkAT7C/LdKPtdHQwsK/s92Hbts1fx1PUuP8cfy2X/hlXqRV4e9PlLhFMx/K+Rz3NXkdlaVpi3TSp4smX2r5Mv9qwiEyam8i0By58ml7Nru3yr5Ep9xTa2yO5f8avNps2+F/D5/TrXulj/3vjySuc2+FfI7/82+is2TJ2B3Mdv9WzGf+lfzpSRZM4mhdQL8Qmm8lOnDk+o3/iPeSb1fyhghXbgRGFqAnV9sP6dO/vb+dTdRGU53nMXn2vhS/5aDrcmRetLhWj2ZfSvk9/lVCtJpVhSR0ukw7ZfszL6V8rnqBdj5CHYp09KWOi8236+bn8uGc5hWAn5JS9AYyG0d+kw9xj+IH1pA/XwRu+S6sUyHf0aP8d/i/7k/SQAU5iZqoBPD2JQVnmfTb/zneK8839fYoCxsrOSrFuaex6l6jD+Gv8+fc8Ls8/wo29z6z7XytP93G2+88cYbb/zp/F+GbepFRax3AQAAAABJRU5ErkJggg==',1292000.00,'2025-06-15 09:11:36.708989','bd816f3674854f209e26abc984b9c29d',288,11,75),(382,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADBklEQVR4nO2cUW6cMBCGv6mR9tFIOUCOAjfokaq9GRwlNzCPKxn9fbBhnfShalMtKTt+IMLwKYM8+T0ztmPij9v87c8ZcMghhxxyyCGHzglZbR3MZmbjYmYjqzW3ZmY2HmKeQw+EuvJjmACWF4yYMGLuNPdJNggMQgbAHm2eQ4dBSxUATfuj4a1D1772FQU5yjyHDoNsBHS1DuYeGFLt++e/yaGvCXUf7gVrx5BeMoNWY5jWTixHmefQYVCUyuQwLhcxv96M2S7S1S6lhiUpH2eeQ4+GZjMz67fe4e0i+5GgXEbWkmocZZ5Dj5417qVswc0EN4N4M+Yeg/i+1v3Fv8mhz0BIUh3vId27gzRFqT6NGU0xl5c1ffFvcugz0DbI70a/hBVKFC/RBNRb94izQ9UjlIBdGRiUt9HfbiW5RjwDVOIIA9D8PQFLl2HpqQ8iCILufV/+mxz6DLT92RNUy5VbHgoEbS2zCYVrxMkh9kGvIcSQ2CaM5q0gKQV5HHF+qNUIpSCIW3IhSQxpF4qEa8QTQPvAwz3NKBnGPdpsnMY94uzQnn1mqh6k0MQR96yjeol7xNmhrUIV66UpOyi1i+NVS9wjzg59rFnWAkSCGlbQ6oZrxLNAZaSvrxIs7QK5ppixMd7MRoJsPMQ8hw6ILJVpqhAlrFDbmqzDNeLMUDNrFD+oLdS6FNAsbngccX6o0QhqclFTjzbdpCajrhHnh5ocohawo4o8lMtE+CUJcY94BmgxK5chUTfdzv1Wj2AxM3v1XXXPADXrGm0eqrso7BWq/R3XiPNDzZmuMn+wWpkrrtaxZaSr77N8HqgpUpbRD/vOyrDtq1oueg89zjyHDokjbKTuu9a1B7N+NfuhXHZqQylTHWOeQw+DPp7gYe7Bhrcui6VDs4XMMK0dLC+uEU8A/eIRxAR1i37IRjkgHgTLanq0eQ4dBsVaiKoHPZcOG2Pet2GvRhNb/Cff5NDfQO3aZ6lZpm1do9alwrbq4ec1ngIy/f6dj83/M5lDDjnkkEMOOQTwEzIPoDum3VHxAAAAAElFTkSuQmCC',1185000.00,'2025-06-15 10:05:07.539570','0d95d00884114cd287435a8ba7dfa63e',284,9,100),(383,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC/ElEQVR4nO2cQY6jMBBFXw1IvQRpDpCjwA3mSFFuBkfpA4wEy0hGfxa2CZnuTTczIYHywk2Ap9jqUtV3lR0TX279j68z4JBDDjnkkEMO7ROy1ErMajCrJ6OvwVrA2jG/0G4yPIceCJXxT9MBjD9JQnN8EzCVWXcWAQB79PAc2gwaswPorQSqq9l5ADMrUUe62mx4Dm0HNQOooxB9XUQXYe1/+SaHnhIqP9ypAtYMoL61GETE+A++yaHXgLJFVAJGoP/1u6SvB4xqgFlMLDNZTz4nh9ZASNL83y5EM3zW5RcaSeqefE4OrYGij1g4gP50NfV1ATCZGEH3HuLp5+TQGij7iCpAMxRSl6/S06FQ6iS5j9g/FC0i2YEkachPGgXiAyrF0JFefvI5ObQGSj5ilgvZR0C0A/LHhdG4RewZWqw+1Z9Cac0wARTB0jJjQhBKgzLLiSefk0NroBQIpNkzxHuBGD9irIgCw3XEEaAcNbSMEPFBR5FlRZUEhuuI/UPZRwxEpxAT2I1CVJbAcv3hFnEgqJC1VeD2EcY35dBRSJd6rnC8ypwcWguNJTS6mi71FAvf1lYBa8cSa0n3XmtODn21LXREEhNSDhiQ7lHMDzxq7ByadcSsIoGoMeEuPRFTFm4Re4fmLPaHLkmIvAhRh681jgDd1zUgGYMCi67z1edxoI/5CAVuV0tHgVvEkaCxhOY95bTVjSXqxre4ItWlnixutmw3Gp5DD4PmPVRXW2yDaARGFRBjDVDIFtCTz8mhNdC8h+q2DWIZK+6K47l51Ng/FCtdzNkoq1PoMDuFWUdMfoLnMNDtTJcuJ8VChrXVNaqHqDJihWOT4Tn0eOgWIZp3Mzu/JxOw81CkRQgxlb3J8Bx6/OpzYLm7ci6ApnACxDSV64jjQY0kOw+TpfN+ZLXZxbOgGw/PoUdD6kaLx8JTy7Hi1r3cnBz6DlRJKQd123wd1x9X06UGmsGr4UeAPj3TlasZ4e86mOuI/UPmv0zmkEMOOeSQQw59E/oDHutoEhqAgIUAAAAASUVORK5CYII=',1235000.00,'2025-06-15 10:10:38.500484','704840b6875845d8904b2e88aebde7d5',286,10,78),(384,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAAChElEQVR4nO2bTYrcQAyFP6UMvbQhB5ijlG+QM+VIcwP7KH2AQHk5UM3LosrVnjC/pNOxB2nR2PhbPHhIluRqE5+J+duncHDeeeedd95551/jrUZH+RkB5gFsXNZn4x31OH8rHkkSUZKUgojKQC8RE0gpaINMe9Pv/Mf4pWUoYdNS2wglp++sx/nb8N0f95oNYOky8xCy3VuP8/+WtxEoRTqmi2n6z3qcvw3fS5oATb3EPIB+Pkg2ApLyvfU4fxu+1udSlQlYPHeZ+NjlcgWXZzV6b/qdfzuKv9eOSvNDhvkhIyid9F31OH9bvs1HrQJTByJNfa7lOibw+eiQPBsvpby5rfNv6bSa53vT7/w7UX27Tr3PVhvldpPTe9Pv/DtRjUtBmnppTeLMWp/bOsv9PSBf37/XrVVMoeUvAGEt1+7vAflNf7V5CderdScNuL8H54OI55PM7CRYOpiHi9nYP9m2u96tfudfjpqm61cjKa2tVUxB1/2k91eH5Nv3hSBj6bJBKFsrwZNBnwAuK7c3/c5/hDcbQFP/ZFK6mNlDhtk6NHExG6/T0z71O/8RPp47KG/iBNBniOdTsdbGu+tx/u/5zXxUd5GStkNSa628fz4i3/xtCytC+1LYrC0Hd9zf4/Gtf64Bfa6rjebqmsnu7/H4Tf5SXr2q/pbRKJYldHZ/D81H1dG3noqlulqbrBTKSY7d6nf+taj7yUQryHl9kFYmyvP3q/Czndoh6Pp9X9Ny8vz9Gvwma+chCLiY2dAOYe1dv/PPY9079gIWYP6R0Tz8wuLZEEsH8fH7ehJ6b/qdfztePj/JUjZZ2er+Oa9H8Pam3/m3w/z/3c4777zzzjt/d/43lqz1G7cRvsMAAAAASUVORK5CYII=',1200000.00,'2025-06-15 12:09:48.441754','7c0aac36e51c4d6ebce0c6da6345a69c',285,NULL,77),(385,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC9klEQVR4nO2cQY6jMBBF/x8jZelIfQCOAjdr9c3gKLkBXkYy+rNwGZie2fR0N3RCsUkCfqJQKq5f5XIofPgYf32cARxyyCGHHHLIoeeEaEcD9okkrwB7wD6WcyTZH2KeQztCTXnpBgBILwCiQKQmC+kKACEDKWQAAPc2z6HDoFQngJGkpDvJNkNv17m4AcnmOPMcOhYq3343BfF1svjxPXdy6MdDGmIGEDP0dgUwtvmb7uTQz4QgSUInSZqCAAShm4KkCajvgjbjhh/+TA59ATTSMgx0k11hj6D6bi6pxlHmObR3rrGWsoUEAPFOjW0GxvZObQfsa55DB0GlAGHZxFynAswEUj03ej3iFJDpiKIeiljIJXRU9ZCxqoxyuI54ZqgqywkAqnAofoCoIi+r5LTB7hGngJacs2Sf6aISMMYrwL5ePcw8h3aD6s8+vgsdsklhiDUt7Tz7PAVUPQLB3GLJPjWUygRQJo8SP9wjnh3a6ohuspqlhY4qKzYxxT3iXFCUqYfu1mD1gzX1ONY8h3aExjZDQyLNLYpvLEXK1IB9asD+GPMcOmBdw8oO2wvL4kbJQ+VR4wzQVlna0haw+sE6BJ17xIkg9gDIVtLwbkDMpSgBIIj9Z+/k0GNAJbUcEkm2S2VimmkOkhpsZcVDPJNDn1vXiFa2tuSiRohNPaIEFo8a54Ck20WWc6amtE+xB2DOkC4C4t3niBNAqEXr/KeAXCtUQX9MHj5HnAIieZH1R5RFros0xDstnBQJEarufIhncuhzUWOdGeKd5HUmuttFGjDTFrmm2TtmTgCVrroqEELWSEDA3BAIIGIQkV4y7MK+5jl0FGRdUksvxLrIhZnbTOQY8xzaH1r2dJmOIEv77YAgjCTXZfKHeSaHvgLSusFPt4v4elucIXnn7Rmg5p9nu2EGlwJ26dgf29y4jnh+6K89XaUeMdUeKqtHLI24Xo94dmjpzgew3eBnfrA2YFrPnXvEs0P0fyZzyCGHHHLIIYf+E/oN6OlAZsEsWx0AAAAASUVORK5CYII=',1100000.00,'2025-06-15 13:00:37.282778','07e8e8dad1684914b116055e5e0d208a',292,NULL,89),(386,NULL,1700000.00,'2025-06-15 13:18:33.899411','c1b19006b7a840179de06ffba08830eb',290,NULL,115),(387,NULL,1700000.00,'2025-06-15 18:49:39.461488','c1b19006b7a840179de06ffba08830eb',290,NULL,117),(388,NULL,1100000.00,'2025-06-15 17:18:23.768947','ef68868550a743ada81e15bfdb03d249',292,NULL,90),(389,NULL,1250000.00,'2025-06-16 03:54:46.704923','74018f94cf6d4183b4eca11474060dbc',286,NULL,79),(390,NULL,1700000.00,'2025-06-16 03:55:12.791051','6a7a5bb6633645f6a9327d9cbce66e6f',290,NULL,115),(391,NULL,1700000.00,'2025-06-16 03:55:12.795569','6a7a5bb6633645f6a9327d9cbce66e6f',290,NULL,117),(392,NULL,1700000.00,'2025-06-16 03:55:12.800623','6a7a5bb6633645f6a9327d9cbce66e6f',290,NULL,118),(393,NULL,1700000.00,'2025-06-16 03:55:12.805416','6a7a5bb6633645f6a9327d9cbce66e6f',290,NULL,119),(394,NULL,1900000.00,'2025-06-16 03:55:21.070951','7ebeb4033859429c86b8ba328cfda1e9',289,NULL,78),(395,NULL,1900000.00,'2025-06-16 03:55:21.073272','7ebeb4033859429c86b8ba328cfda1e9',289,NULL,79),(396,NULL,1360000.00,'2025-06-16 03:55:28.661293','703725af5e1e432a964ab26180aceb25',288,NULL,76),(397,NULL,1000000.00,'2025-06-16 03:55:52.792303','59453bee67724d33b7abf32e509198fa',291,NULL,86),(398,NULL,1000000.00,'2025-06-16 03:55:52.796196','59453bee67724d33b7abf32e509198fa',291,NULL,87),(399,NULL,1000000.00,'2025-06-16 03:55:52.799761','59453bee67724d33b7abf32e509198fa',291,NULL,88),(400,NULL,1100000.00,'2025-06-16 03:56:02.654838','3fead25b3521446bbbcf62c7fe0f178a',292,NULL,91),(401,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACbklEQVR4nO2bQY6bQBBFXwUkLxtpDtTcIGfKkXIDOAoHsATLkUA/i+7GeJxkMhFDTFS9sGx4iy99VVVXddvER1b/5UM4OO+8884777zzv+Itrxr6BsysxqxZDKbyrj1Qj/M781GSNAJxqJHGxYjDRdZSSZJ0z3+2Hud35qccodaymLVBUgeoI4fzwXqc34evf/ZQfXOtgep4Pc4fwcfhInUsper+az3O/y1f4jcImIC+qWZgMaLAALYjkGfT7/wf8b2ZmTVAHMFaKsFUAyxp+3ysHud34lP8Pgwpw4xgJgf2cXqc/wze2in3v+pYTN+aJYcz5cWhepzfiyc1t3EECHPqhIljldphdWxfqHs2/c6/s4q/ldSlWcaMpGJoGm2E8tX9PRlP9i3Mm0jOJpdvN6fd37PxxV/IhnZBSgmZIKkrkyzPz6fk2Q6XwzqELvX39sL9PSW/+pvrb3k2k36uGy/Pz6fki78lK6f8nIrwWIno9ffU/LY/Sh+aV89n0sarK4eE7u/Z+Lv8HGZKQs6VuASx19+T8iV+0/n+dqqR6+8ayR6/Z+Tfzq9uqXkbyV5//wNeGmqsZTFpqKFvKt3uXx2vx/nd+DLVuO+E9Wq30mvtgXqc34u/m2+kTZZKVzSSJh1ef8/L54O/2AFMLxgBxPQiQFiaVB6nx/nP4af1hnO6P/lq9A3pYgcxFeYj9Ti/D/94f3K6yHqrZHEw1H+91oK5cM+m3/nfrwd/4/fGBIvRN9VscbjICNdyhefZ9Dv/znqYb6zbrdT/wmZm6furs/Fv98+bgVU6+g0zN+Pd37Px5v/vdt5555133vnD+R8iQwaNpTEdRQAAAABJRU5ErkJggg==',1250000.00,'2025-06-16 04:50:08.705705','159e511a85de4897b5a8dbb1bec48133',286,NULL,79),(402,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACe0lEQVR4nO2bS26sMBBFTz2QekhLWUCWYraWJWUHsJReQCQYRnLrvoFtoPt9kiiEQFQeWOA+gyuVrruqbEx8ZPS/PoSD884777zzzjv/L97yqLF2NLMWoLcaGMtv7YZ6nF+ZD5KkAegfI3o6A3A1oJIk6Zb/aj3Or8xPrg2XOi+FIT+YWX3Pf7Ue59fh67t3MVbRoI4GVbTwvK0e57+WNztfjaAIYbiaum/W4/zn+OLfRsAI6lsQ40NU/ygsPMOyBbI3/c7/f+T49gZAhYXhIe3KFi51JCdZm+lxfl0+xXd2qJKJzxWCV8vG3k6P8+vypOInKE4rlSRF1FEJGill0kGSur3pd/6NkapbDaCuiXmSItBEUnynItjjezR+6d9k0zKpK04mDB7fH8D3j7NrI9YC9HZSXttcj/Of55mbj2mTnqa5f1Us7v49Hr/In40m1jY9lZr4jNG8lDp5b/qdfx8/mhEuNalhFQagNzNrm3LwsK0e59fhc/48pc4ptUr7s6RcJM3c3vQ7/8bIcUsvy4I3u7aUSx7fQ/JTflUp+1dxWQl3jVLMPb6H5G/im/ybg5ytO1RKQfb8+Yj8oj4i6GZrnrqSQOXxPSZ/69+y1gFzauX95+Pypf9cxuImVupZyvvPx+fn+5PA9fb+ZM3ydGmf+p1/g59dC+VoIafOObTWbqnH+ZX40lweSMdEaa2DpWuD178/hg9DJWubCIyndD6oJzvJ2u/R4/yn+L/cjwXBNT0BlYzmpVzC2pt+59/HN6VJ2Z9LfkXzasDVCJeTf79wTH7Z31j0n8utjZx4TcP/fw/G/3l/Mk2VgIju+b3pd95555133vkj8r8BQ7XibFs0LlIAAAAASUVORK5CYII=',1100000.00,'2025-06-16 05:04:01.623281','bc6d9f603bd54979a9ab8341a7e6bb1f',292,NULL,91),(403,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACjElEQVR4nO2bS4rcMBRFz4sNNbQhC+ilSDvIkprszF5KLaDBGjbI3AwkVbkTmnQTt1OGp4HrdwYXxH0f6ZWJz6z526dwcN5555133nnn3+Otrh6Lqcciq1kELKb2WzxQj/N78X15CRNA+o5Iq2keFxlpBOgyAHaMHue/hk/NofMI9rysxvxUdhYz64/W4/w+fP/bZwvL92zzuAhAdrQe57+Yn0cAVmO23zf/f+hx/p/4toWDgFQ/aP7RyYLWYt/tEcij6Xf+Q/xsZmYjEBaw52sPpIuAtZTPx+pxfie++Hfr0CEDw6sxjx3V2Mfpcf4reIvUXhfKo6ducjO2xQP1OL8XjyRJU3FtBgYJhoy0dNJEJ8ICBEmaHk2/8x/hLQLS9SLp2tckHIcMpZJunfCj6nf+3dX8Wx+EpZOkamdpgeJu9+8Z+VJfWbj2GVKfBa+mejQJFqb8pgR7NP3O/2UV/2rpBIOkCdjk3/IDndy/Z+bnp1erqVdqHdGQsTjkGp8P1eP8rrzFdJHFIWM2rka49tTzydvFw5F6nN+LL/GZcA/DC2iia+WWMqX6ksfnE/Jtf1W73pKEtcBmzwGvn8/Ma0pmmlJPqa/mkfouLFA3/kA9zu/Fb+vnoNzqq1s7DK0ddv+eka/9L3RAGtE8vty+M4DVCJP3vyflm3/busfi+6lVycTu3/Py9/nJUj9LGYtAu0ny/HtuPqhWzfo5gsV0G80ZMszj6vf75+bbMYZFuA1hUQY7uDdJD6vf+Y/xmlpAlq6XehM8JZ+PPSn/x4hkWEYEK7bJusOLx+dz85urI6nG5zKpc6nzG8fqcX5Xfjtmtb5JuGXSrh1nPap+599Z5v/vdt5555133vnD+V+R0XcJwKiT2QAAAABJRU5ErkJggg==',1360000.00,'2025-06-16 05:03:42.660171','d1d5aa4a79214a9ebd60bcf8a087e899',288,NULL,76),(404,'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAACeUlEQVR4nO2aQY6jQAxFnwcklnCDHAVu1srN4Ci5AbWMVOjPoqroJKPRTGtoJiWZBUqot7Bk2eVv28RXnuXHl3Bw3nnnnXfeeed/x1t+WlgGMLMWs2EzCOVsOtEe5w/mR0nSChDMGNfNpFsnm2gkSXrmv9se5w/mQ45Q+5AEfcQmQDM5nE+2x/nv4kNO0ilTT//dHuf/hW9fPyyXiAidWKbNRDjXHueP5Yt/e8GjLzfTWO7cxxbIu9nv/F/xi5mZDcB4a7GJRjaFFpvYUvl8rj3OH8Sn+H1qUm4miEB/txzY59nj/HfwNoWsfzUDLMNmLEOjon+9fq6UJ6nbuY8wKiIpIq1NksPS2ohRSi/N72a/8394UvMieXAlOTl7em2Uwnnn3L+18ZTmVCPNvcS4loZVCthe5cD9WyGf41KKlPjN/auUs+kjOVO7fyvki3/TNRuBfv+7gmYagcdvrXzJz3uYzpB+vdzJHr9V8ln4jPOG0cfWRm0t9LHNurePLdD4/KhuPrRoDi0QOtlEngnrOjTS1fVvrfyDPkq1svZLeC45G5I69vxcH/8wP7Lx1kaDRkYwNN46lcFD5/m5cn4zXS93S/2ruY/Y1EfMBjC7xNPtcf4Qfs/PxYNjaU0mVZS/uf6tlN/7GyprVrvW/RRJrn+r5ff+JAD7VEExT5LG0vjw+K2Z3wPW8mi/S53oVDqfb4/zB/Nh33BmszTaT0t2ZsZiLfn0Xe13/kt86GQfulsRxl4/V8r/sj8JwHK5p4UrLZYxnWOP88fyj/2rfaD/NGSIPl+omH+tnx8EUSqnP9d13L8V8q/7k3p+kUZHfv8677zzzjvv/JH8T4GJ8X2nZDEEAAAAAElFTkSuQmCC',1900000.00,'2025-06-16 05:03:48.904424','1e33d6d7be984e748618ae9b49b41f64',289,NULL,78),(405,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC70lEQVR4nO2cUW7bMAyGP84G8ugCOcCOotxgRxp2M/soOUAB6bGAAu5Boq0EBYauhZ3a9IObOPoQCWXJnxRVUT58TT8+zoBDDjnkkEMOObRPSOrVwyQickl2E7l/tcn0HFoR6suPMAKkM8IQEYbcKyiQzhlSlwGQtafn0GZQqg5Ax7uPRX5meyX9l3yTQ98Lkgugf0r86FGN9dmXf5NDzwn1D+8Vbj0hnjMMr0IYb72StpqeQ6tDqKoqQVVVY6eE2CkMGdXYqY7UZ8248cnX5NAXQJOIiLzY03A9qVwA+R0BuJVUY6vpObR21FhK2QpvovAmMGSYXhAY7mvdT74mhz4D1agBQIjL4051HLQGjHHIlJt61Ng7ZDoiAkG1SAgYVFUjxQ7qOBviFrFryP7s6YqjqJ5Bq1nYLUNQ9xFHgOovufoDVSjJRXUKOtKVJKS8dYvYPTTriNZHWOHyIfF0H3EEaI4aUINDxOQCDzqi83rEASDzEYOJiVleantlPGocBHrMNSznpKlZmqOo8cMtYtdQoyxhVpHj/HHQXNPSYiVuEXuH5uCQG81g2xzt5rjvaxwLmuSkckm9lamSCDX/qNVLERGpBvI91uTQZ6vYVqxudQTFLIbMojvdR+waMmlg298mL7OFDruWyoRbxK6hWR9kU5ERqHnFLCuiKQr3EbuH7hQjcynbwsSy4eG5xsGgJLUhIlz7uXD5JsBNrH41d1x+kzU59D9Q02cp4XqqGnN6eYXpV1SCgpAEGLINfvI1OfQZ6L5Yvex8W9WqqVDNYzxq7B9qznTVKkSNFUzSA6mnPttkeg6tDzVFyrSYRe2PqH1V6aT30HrTc2ijna7SmG/bXQxqW6HQxA+PGruGHk/wUE7wXPusJEEnqZ3aQjq7jzgA9I5FdEpt0e8y5WAwoKSb6NrTc2gzyCoOhAhyST1ymdun5v6Izabn0GpQe16jbba0XuygrVl49rl/SPTfYx4v/89kDjnkkEMOOeQQwF/8G6TL5pgrkwAAAABJRU5ErkJggg==',1900000.00,'2025-06-16 07:19:55.722816','063866157c2142e6ac55001bd834de9f',289,NULL,78),(406,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADJUlEQVR4nO2cQW7jOgyGPz4ZyNIGcoAeRb7BHGkwR+oNoqPkAAXsZQAZ/1tIStzOZvr6YHdiemXH+QAKZUnqpxgTn77SP59nwCGHHHLIIYccek7I6tWVD22czWxkMZKZlUczMxt3Mc+h7aEoSZrAxrkD+owu80n2cwrShSBJ0ntoO/Mc2g6qUYF5gPgKgrx6rfRSHw1Ce/PN1+TQV6Duw7NByEoGpBEjTmDxdS/zHNoc+ugRSj/ejDidM1FLJ1g6Me9lnkObQ80jegEzGH2QpZebifksgyCr6WQH8xzaC0pmZjYA8dpBvJ5kI0CcAFjKVmMv8xzaOkY8AoDSEID+ZsBiSgNWI8ge5jm0OcRqV1niQa+63Sx7zimobkb7XL6syzdfk0NfgZpH9JIufV67hZSpzgBIE1W3cI94ZqhljdnuTyFbvCwdEFplqaWDPnfa2jyHNodaIih5oUYGaQLpLleWFxOeNQ4A1axRsgGUDNGuWkeU/BHldcQRoPZHJmhVPdwdBPoMd9/wOuL5oeoRUmbd0LrvK9RaYMTJs8ZxIDM7CfpbbYnHawfMHeUxvUj6NQTvfR4AWu8+NUHTI4CaKyglhMeIg0Cs0sR9S/E4LrGuIx4V6Ddfk0P/AxSvJ0E5ORXKHZS7mk5IZlaDx9+xJoe+plAtBv3bx+Y4sFh1iyJdbWueQ5tD7+uIJkAUPVu67zkzxKmmDs8aTw01hWpiVUBSC4fW16jqJd7XOAD0Lk3MZxm9MPo3UxqDSONJBhhxGvC+xvNDaxX7Llc2xTrzaIp67/Mg0Posdr07Z6XhDdKPqcQEgw6jz+3L33xNDn0FeidWN2VipUfEFkFaGPEY8eRQ+bdvByhDJl4Q5QR2L0gGMJ9z/Wxj8xzaC7oHBf0qo35BFCkCqMLl3GHjPuY5tD0016FOGwHSAGZDkP2URDIz6H3K7wjQbyJlfB2MeO2ymI0y3VXEzPmcPWscEnokjNb+jteTdHkkkb9vTQ798fVxpos6r5E7i5ebUed/byafBD4GtJ7XgFD07NLXoK9aFRDk8xoHgcx/mcwhhxxyyCGHHPqP0L/2o2r7HQPGbAAAAABJRU5ErkJggg==',485000.00,'2025-06-16 07:50:34.552693','4bdfd197cedb4be6aced562fedac9002',296,10,115),(407,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC6ElEQVR4nO2cTY6jMBBGXw1IWdLSHICjmJvN1eAoOcBIeBnJ6JuFbUKnZ9MzEemG8gLh2E+xlVK5flwx8ek2/fg8Aw455JBDDjnk0DEhK63F7I3yGAAboll+mJnZ8JLlObQjhCSJIEmaGwHlIc2gMb812swbv/ieHHoGFKsCCPNikm5m1kvAkgfMrH3d8hzaDWofP5j61BoAYVxawvyGiE/4Joe+B/QoEYIF6H63gkY29emD0Hz1PTn0DKiTNAI20IhwvQiimXS9yAZAUnrd8hzaG5rMzOwNIBadYANNFgZgya7Gq5bn0N6nxj2Uram/meBm+W3qE9pO2Hd5Du0OFe+TTtXnzC2hMU9oRFi77n0eHmIjAlIxJgjzx4E1KOEScWio6ohNNxUrMtSBu1HpEnF86FEVEOamPLL/0SXKmdIll4jTQDmlMUQzYDHoEiWOGS/SGFsI8+p6fIs9OfSfOuLe6gmRUxr5/EjkNIfriNNAsc1BCYgtGruEDetAHu09QnUGaPUwqpOpqg/u1kN+C6sScR1xZGhzauTu2G27tVVr0+MRh4c2vkZ2N8O8Dszv7Qi5r3EGaBOPuIvAw6mRXdDgEnEiKIvA1N9qumvTGkG85Bi3DS9ZnkMvgDqJcG25//qEecmuhw0ARM99ngFaI5WUc+HhhFD9rIYn/NQ4OLSmsd7ZEUUsShRbIxSxcIk4PLSRiBpxSJvUVmk5KJE8G34CaOtrjJuL+c27JBfkN9cRx4ce8xqP8YixhisJch1xBijfqqtORJMEqSWMS2vQ1FnxZ2Ky9XLdF9+TQ0+AQjUmaqFOk4t3yqxqR9jwmuU5tD+0qelqpDFavSQBJSkaZurdy2+yJ4eeAWlkMbM+kUs1fl3NypWqe6zqm+3Joc+0jwVbgIgtRpfQ1AuI5PI/tyOOD/2lNrxevx2BGoUofqh7n6eBNjVdAMSLbOjuRRvFhLDhNctzaD/I/J/JHHLIIYcccsihf4T+AMH4qbEN71IvAAAAAElFTkSuQmCC',485000.00,'2025-06-16 07:50:34.586117','4bdfd197cedb4be6aced562fedac9002',296,10,116),(408,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADFElEQVR4nO2cT46jOhCHv3pGyhKkHKCPYm4wR3rqI80N4Cg5QCR72ZLR7y1sAt2zeBrNiMyQ8iIB4k+piFL9JyZ+es3//DwDDjnkkEMOOeTQOSFrq4PZzGzMZjay2O7UzMzGp4jn0IFQV9/iBJCvGH3C6EsnCLIogBwKAHa0eA49DcrNAGjaPstmeh/aSbUgv+GbHPq7IBsBvVsH85tETO3ab/8mh/5MqPtyLlg6YroW4s0gTksn8rPEc+hpUC9pAmzMFzG/fRgQpHe7yEZAUnmeeA4dDc1mZjasV+Ot6YH9mwBYaqrxLPEcOtprbKVswYcJPgz6D2MeAtpvOFY8hw6HkKR2v2PaLgdp6iUpBWnqC/VFkjT94b/JoV+B1ptMUAsm+kI9UgLoy7ovAdE14uxQ0wipQExNLYgq9e6vL6VGlm4jzg+17HMeodmD3BXIAyJfi+YhoXlIgjwcL55Dh0M7G7G6iZaH1lXdRF9YDYXbiJNDLbJsDqO08LLqAWtRO6ZQY0yPI84P7WqWIl8EORSbh3un2uQiFKAALKajxXPocGj1GmnLQ0PtZlSjUPPQujXIvcb5oU/ZZ1WGLyrQktGmJa4RZ4f2luFz4tkCTWBTBo8jzg/tNKK5ic0epO1aqTGm24iXgWJ1DgVNeQs2F2N+a8pgI6F2v/6W3+TQr8URLdPURHgUINa09HHkNuL80I/1iDoG0YLK1t9Kj8qEa8TZoYeLWIz4/SIjX2X0d9M8Blm8XWQAFtOA1yPODz1sBK1OPfVba0ufGuF1i9uIk0MPGxEK5Kss3rqiebjD/C1BTMigqxP7h4vn0OHQo9PV1q6v0YzCvi/ukeWrQPtnuoYgYLFamZitA2pGuvic5etAD6OwFbDXHWsSUvtgzxHPoSdFllu/u1cbsmsVTXb+w73GqaGvT/AwD/eOeOuKyAYQiuZv9w7y1W3EC0A/aEScEG1EPxTmcTHi7SLIPh/xCtC+p7kNRDxqD/v5bJ+PeAlo/7zGoyW+jei36CHhs9ivApn+f8/X5f9M5pBDDjnkkEMOAfwH5i2YJwQoLjAAAAAASUVORK5CYII=',1500000.00,'2025-06-16 08:53:49.495634','bb89d1ceff6d44e2b56f44ea2d9fc4ad',303,NULL,96),(409,'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC9klEQVR4nO2cUW6rMBBFzzyQ+HSkt4AsBbb2ltQdwFKygEr4MxLovg/bhFSVqqotpGH4SAXkKGNhXc9cDzXx6WP483kGHHLIIYcccsih54QsHzXWRTOzE1gH+TRdMzPrdgnPoQ2hOv1pe4D4FwjCiPUkmGsNZwGxmgCwrcNzaDcoFgEYzEzSNQnF7YaZ1fuF59C+UHr67aUR7Qjqf+yXHHp4SH2YgDDleTCcpx/6JYceEyorQRAQwaCRtS+NgNloL42sfYG1k/XgY3LoG6DBcoVBO+Y71lEt02BOpcZe4Tm0tUbcBEBEgHA1DSeM4Xy1rCB7hOfQTlAyIHI1MRcpCBMQG6lntiQj3S7hObQhhCSlkoJWU/kYQRorSemaVE4l9Q8+Joe+AuUZQZigHSupT9cmgCpXn/k0f9lnxFND+SFrBAiS+jAlecin5BupIvUZ8fRQecilrtByAJXUh7xg0Erpw2fEU0PLqqGSM4zlRl9WjSwPo68aR4BKZqnbM5+KcZk0ImeWvmocBFrXGotQ3NKKXIKyXk58RhwDqiRdaiA2ypMhFpOyHcG6WGPdXuE5tBW01BrVIgGLKIzVughJ4uEacQzIuuJKMlidVg2z820XdC525S7hObRHZllKy3UeUbbEl6TSq8/jQNFM/1KfZZOsiFKHVoKYGzB3C8+hzaCl1qi0EoVW07os7UM2sTyPeH6o7IbH2URsRDue0HB6xVI3LgDREOHVtHV4Dm0OrX0GrYyoxaGiKqZE8apcI54aKi72XeKQCs/ccanSLRPcoToC9K5G5BvjnYvdyjXiCNCiEUBeJu76IwhL3onvdB0ISlbEmN/tg7um25JHLDPnd4zJoa/6EdYB6y2NcDWgUjIzl23yXzMmh74DSo61nSekS5N2v3JLVfTO2yNAd523q1bbvEyseqi8P+IY0DvvdAHEExq6erJ0JVxN3F7rePAxOfQV6G2tcevEz6Z2SSp9p+sgkOnj77w9/D+TOeSQQw455JBDAP8BDbeP1bH6IhcAAAAASUVORK5CYII=',1500000.00,'2025-06-16 08:49:20.606092','bb89d1ceff6d44e2b56f44ea2d9fc4ad',303,NULL,97),(410,NULL,1900000.00,'2025-06-16 09:00:50.368069','6b81645fc7224ba49d0fdf1b23881e04',289,NULL,79),(411,NULL,1700000.00,'2025-06-16 09:00:50.382927','6b81645fc7224ba49d0fdf1b23881e04',290,NULL,115),(412,NULL,1700000.00,'2025-06-16 09:00:50.386309','6b81645fc7224ba49d0fdf1b23881e04',290,NULL,117);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `payment_method` varchar(50) NOT NULL,
  `payment_status` varchar(50) NOT NULL,
  `transaction_code` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `expiration_time` datetime(6) NOT NULL,
  `order_id` char(32) NOT NULL,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `payment_order_id_98f7562d_uniq` (`order_id`),
  UNIQUE KEY `transaction_code` (`transaction_code`),
  CONSTRAINT `payment_order_id_98f7562d_fk_order_order_id` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=170 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (102,'transfer','success','3301358756','2025-05-05 00:58:45.337253','2025-05-05 01:03:45.336612','710a22c3a03e4ebb8fb5ed565a219382'),(103,'transfer','success','3301358822','2025-05-05 01:04:36.882482','2025-05-05 01:09:36.881811','1d9af26a28d647ac8c299c612fcb9b9b'),(105,'transfer','success','3301359144','2025-05-05 02:06:15.989121','2025-05-05 02:11:15.988636','d7237cdbb58543a8bc6e17511f47a744'),(106,'cash','success','CASH-10aff3e0-b89e-4202-a9ed-3a3db3b05bb1-1746411315','2025-05-05 02:15:15.978056','2025-04-30 17:00:00.000000','10aff3e0b89e4202a9ed3a3db3b05bb1'),(107,'transfer','success','3301359421','2025-05-05 02:51:01.276567','2025-05-05 02:56:01.276180','d15936ece09a40a29821ac0728543a79'),(108,'cash','success','CASH-981a9da6-6348-49e9-829a-418cd7fec6ec-1749698617','2025-06-12 03:23:37.381513','2025-04-30 17:00:00.000000','981a9da6634849e9829a418cd7fec6ec'),(113,'transfer','success','4506921080','2025-06-12 04:02:42.270469','2025-06-12 04:07:42.270232','785ed697f13749318c72fa13bb71b7fc'),(114,'transfer','success','4506901214','2025-06-12 04:05:24.990905','2025-06-12 04:10:24.990442','db74d1397e854d118a44e8c6a6d6381b'),(115,'transfer','success','4506901374','2025-06-12 04:24:14.048846','2025-06-12 04:29:14.048642','de1c862036c94e3d8dc67c0e4ba1fbcc'),(116,'transfer','success','4506901403','2025-06-12 04:28:05.139620','2025-06-12 04:33:05.139306','a3dc667fa4c24d59afbb3ea7e3d077b7'),(117,'transfer','success','4506681963','2025-06-12 04:43:49.942284','2025-06-12 04:48:49.942046','d2e41d82bebf4aa683a8281e7b060f6b'),(118,'transfer','success','4506922093','2025-06-12 06:21:14.258263','2025-06-12 06:26:14.257740','63a8ec2306ef413caf1e32f5f4073f08'),(119,'transfer','success','4506922117','2025-06-12 06:24:31.733873','2025-06-12 06:29:31.733319','d1713e6aa2f24639bd967e6f5a819c09'),(120,'transfer','success','4506782349','2025-06-12 06:28:14.148359','2025-06-12 06:33:14.147974','bf0e938e5a6042c0bea1cf4ece269c7a'),(121,'transfer','success','4506922168','2025-06-12 06:32:24.394732','2025-06-12 06:37:24.394353','b9902886aba94b6bb9bcfc17bb424b11'),(122,'transfer','success','4506922184','2025-06-12 06:34:11.486624','2025-06-12 06:39:11.486180','50a1da5aa0344a2980ce228aca912e37'),(124,'cash','success','CASH-20d85a30-9fd0-407f-8a75-9ac334fa2953-1749824016','2025-06-13 14:13:36.050745','2025-04-30 17:00:00.000000','20d85a309fd0407f8a759ac334fa2953'),(125,'transfer','success','4507486014','2025-06-13 18:22:58.263432','2025-06-13 18:27:58.263046','43dd74ce2920465c826dffcebd7615b9'),(126,'transfer','success','4507455981','2025-06-13 18:29:40.873853','2025-06-13 18:34:40.873616','e9d42e6bdabd4d41a900862762ea2234'),(127,'transfer','success','4507456092','2025-06-13 18:57:04.803695','2025-06-13 19:02:04.803139','69250b87dd6e454298fbaaccd5e631f8'),(131,'transfer','success','4507486296','2025-06-13 19:43:15.319310','2025-06-13 19:47:29.590125','dea3e8651b8c43a5b5a0221c36348549'),(132,'transfer','success','4507436526','2025-06-13 19:48:24.403173','2025-06-13 19:52:45.766895','3d80bee55cf94a8aa0a68611de2524d0'),(133,'transfer','success','4507456288','2025-06-13 19:51:30.851793','2025-06-13 19:55:58.413320','9dda0ccabfb44aa2b795a6d6683177cb'),(134,'transfer','success','4508258922','2025-06-14 07:38:43.787436','2025-06-14 07:43:01.513391','32bcfebdbb234c27935c72985a1a9a6e'),(135,'cash','success','CASH-bb4f1063-ed3f-42ce-9c6c-32edd2e1d3f5-1749888159','2025-06-14 08:02:39.958453','2025-04-30 17:00:00.000000','bb4f1063ed3f42ce9c6c32edd2e1d3f5'),(137,'transfer','success','4508259497','2025-06-14 10:02:43.403859','2025-06-14 10:07:03.490168','33f7af899a5e490c9e5b5e0b5cc01baf'),(148,'cash','success','CASH-df800a03-88ed-4bb6-b8bc-ea1ffa243cf3-1749974693','2025-06-15 08:04:53.062969','2025-04-30 17:00:00.000000','df800a0388ed4bb6b8bcea1ffa243cf3'),(149,'cash','success','CASH-bd816f36-7485-4f20-9e26-abc984b9c29d-1749978696','2025-06-15 09:11:36.681642','2025-04-30 17:00:00.000000','bd816f3674854f209e26abc984b9c29d'),(150,'transfer','success','4508245364','2025-06-15 10:05:02.167973','2025-06-15 10:09:21.279363','0d95d00884114cd287435a8ba7dfa63e'),(151,'transfer','success','4508245388','2025-06-15 10:10:33.858359','2025-06-15 10:15:00.760609','704840b6875845d8904b2e88aebde7d5'),(152,'cash','success','CASH-7c0aac36-e51c-4d6e-bce0-c6da6345a69c-1749989388','2025-06-15 12:09:48.371825','2025-04-30 17:00:00.000000','7c0aac36e51c4d6ebce0c6da6345a69c'),(153,'transfer','success','4508246063','2025-06-15 12:58:36.036253','2025-06-15 13:03:05.571902','07e8e8dad1684914b116055e5e0d208a'),(154,'transfer','success','4508226123','2025-06-15 13:17:17.647534','2025-06-15 13:21:43.243919','c1b19006b7a840179de06ffba08830eb'),(155,'transfer','success','4509027438','2025-06-15 17:19:15.257009','2025-06-15 17:23:23.942801','ef68868550a743ada81e15bfdb03d249'),(162,'cash','success','CASH-159e511a-85de-4897-b5a8-dbb1bec48133-1750049408','2025-06-16 04:50:08.473290','2025-04-30 17:00:00.000000','159e511a85de4897b5a8dbb1bec48133'),(163,'cash','success','CASH-bc6d9f60-3bd5-4979-a9ab-8341a7e6bb1f-1750049736','2025-06-16 04:55:36.406249','2025-04-30 17:00:00.000000','bc6d9f603bd54979a9ab8341a7e6bb1f'),(164,'cash','success','CASH-d1d5aa4a-7921-4a9e-bd60-bcf8a087e899-1750049766','2025-06-16 04:56:06.451013','2025-04-30 17:00:00.000000','d1d5aa4a79214a9ebd60bcf8a087e899'),(165,'cash','success','CASH-1e33d6d7-be98-4e74-8618-ae9b49b41f64-1750049952','2025-06-16 04:59:12.697473','2025-04-30 17:00:00.000000','1e33d6d7be984e748618ae9b49b41f64'),(166,'transfer','success','4510307772','2025-06-16 07:19:49.788312','2025-06-16 07:24:16.105612','063866157c2142e6ac55001bd834de9f'),(167,'transfer','success','4510508129','2025-06-16 07:50:28.403937','2025-06-16 07:54:56.621306','4bdfd197cedb4be6aced562fedac9002'),(168,'transfer','success','4510448795','2025-06-16 08:49:10.649018','2025-06-16 08:53:12.746924','bb89d1ceff6d44e2b56f44ea2d9fc4ad');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `price_history`
--

DROP TABLE IF EXISTS `price_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `price_history` (
  `p_history_id` int NOT NULL AUTO_INCREMENT,
  `old_price` decimal(10,2) NOT NULL,
  `new_price` decimal(10,2) NOT NULL,
  `effective_date` datetime(6) NOT NULL,
  `changed_at` datetime(6) NOT NULL,
  `reason` longtext NOT NULL,
  `changed_by_id` int NOT NULL,
  `pricing_id` int NOT NULL,
  PRIMARY KEY (`p_history_id`),
  KEY `price_history_changed_by_id_4009792c_fk_employee_id` (`changed_by_id`),
  KEY `price_history_pricing_id_44d4ed55_fk_section_price_pricing_id` (`pricing_id`),
  CONSTRAINT `price_history_changed_by_id_4009792c_fk_employee_id` FOREIGN KEY (`changed_by_id`) REFERENCES `employee` (`id`),
  CONSTRAINT `price_history_pricing_id_44d4ed55_fk_section_price_pricing_id` FOREIGN KEY (`pricing_id`) REFERENCES `section_price` (`pricing_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price_history`
--

LOCK TABLES `price_history` WRITE;
/*!40000 ALTER TABLE `price_history` DISABLE KEYS */;
INSERT INTO `price_history` VALUES (1,70000.00,71000.00,'2025-05-03 14:27:00.000000','2025-05-03 14:26:59.650838','Nhu cầu',2,264),(2,71000.00,72000.00,'2025-05-03 14:29:00.000000','2025-05-03 14:27:30.259231','New',2,264),(3,80000.00,50000.00,'2025-05-04 23:30:00.000000','2025-05-04 23:29:30.808683','Test',2,266),(4,50000.00,51000.00,'2025-05-05 01:48:00.000000','2025-05-05 01:47:11.040303','G',2,280),(5,90000.00,91000.00,'2025-05-05 01:53:00.000000','2025-05-05 01:51:34.828944','New',2,273);
/*!40000 ALTER TABLE `price_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotion`
--

DROP TABLE IF EXISTS `promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion` (
  `promo_id` int NOT NULL AUTO_INCREMENT,
  `promo_code` varchar(100) NOT NULL,
  `discount_value` decimal(10,2) NOT NULL,
  `discount_type` varchar(20) NOT NULL,
  `start_time` datetime(6) NOT NULL,
  `end_time` datetime(6) NOT NULL,
  `usage_limit` int NOT NULL,
  `description` longtext,
  `status` tinyint(1) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`promo_id`),
  UNIQUE KEY `promo_code` (`promo_code`),
  KEY `promotion_user_id_3df35996_fk_employee_id` (`user_id`),
  CONSTRAINT `promotion_user_id_3df35996_fk_employee_id` FOREIGN KEY (`user_id`) REFERENCES `employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotion`
--

LOCK TABLES `promotion` WRITE;
/*!40000 ALTER TABLE `promotion` DISABLE KEYS */;
INSERT INTO `promotion` VALUES (6,'NEWYEAR',5.00,'percentage','2025-05-04 01:36:00.000000','2025-05-31 01:34:00.000000',97,'',0,2),(7,'OFF12',11999.00,'amount','2025-05-04 01:37:00.000000','2025-06-05 01:35:00.000000',47,'',0,2),(8,'PRO2',6.00,'percentage','2025-05-04 01:50:00.000000','2025-05-24 01:48:00.000000',47,'',0,3),(9,'MEME',15000.00,'amount','2025-06-12 03:40:00.000000','2025-07-12 03:37:00.000000',0,'',0,2),(10,'TITITI',15000.00,'amount','2025-06-14 09:53:00.000000','2025-07-12 09:52:00.000000',3,'',1,2),(11,'NGAYVUI',5.00,'percentage','2025-06-15 08:08:00.000000','2025-07-12 08:07:00.000000',0,'Mừng khách hàng',0,2),(12,'MOIMOI',6.00,'percentage','2025-06-15 11:13:00.000000','2025-07-05 11:07:00.000000',7,'',0,2),(13,'MOMO',7.00,'percentage','2025-06-15 11:20:00.000000','2025-06-15 11:25:00.000000',5,'',0,2),(14,'MOTION',7.00,'percentage','2025-06-16 12:13:00.000000','2025-06-30 12:13:00.000000',5,'',0,2);
/*!40000 ALTER TABLE `promotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotion_detail`
--

DROP TABLE IF EXISTS `promotion_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `match_id` int NOT NULL,
  `promo_id` int NOT NULL,
  `section_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_promo_match_section` (`promo_id`,`match_id`,`section_id`),
  KEY `promotion_detail_match_id_0de2c18b_fk_match_match_id` (`match_id`),
  KEY `promotion_detail_section_id_b53a14b6_fk_section_section_id` (`section_id`),
  CONSTRAINT `promotion_detail_match_id_0de2c18b_fk_match_match_id` FOREIGN KEY (`match_id`) REFERENCES `match` (`match_id`),
  CONSTRAINT `promotion_detail_promo_id_007c9c61_fk_promotion_promo_id` FOREIGN KEY (`promo_id`) REFERENCES `promotion` (`promo_id`),
  CONSTRAINT `promotion_detail_section_id_b53a14b6_fk_section_section_id` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotion_detail`
--

LOCK TABLES `promotion_detail` WRITE;
/*!40000 ALTER TABLE `promotion_detail` DISABLE KEYS */;
INSERT INTO `promotion_detail` VALUES (17,56,6,32),(14,58,6,32),(15,58,6,33),(16,58,6,34),(21,56,7,32),(22,56,7,33),(23,56,7,34),(35,58,8,32),(36,58,8,33),(37,58,8,34),(42,65,9,37),(40,66,9,35),(41,66,9,36),(56,66,10,36),(57,66,10,41),(52,66,11,35),(53,66,11,36),(54,66,11,41),(55,67,11,35),(58,75,12,38),(59,75,12,39),(63,65,14,37),(64,65,14,40),(60,67,14,35),(61,67,14,36),(62,67,14,41);
/*!40000 ALTER TABLE `promotion_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seat`
--

DROP TABLE IF EXISTS `seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seat` (
  `seat_id` int NOT NULL AUTO_INCREMENT,
  `seat_code` varchar(50) NOT NULL,
  `seat_number` varchar(10) NOT NULL,
  `status` int NOT NULL,
  `section_id` int NOT NULL,
  PRIMARY KEY (`seat_id`),
  UNIQUE KEY `seat_code` (`seat_code`),
  KEY `seat_section_id_5b7568e1_fk_section_section_id` (`section_id`),
  CONSTRAINT `seat_section_id_5b7568e1_fk_section_section_id` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seat`
--

LOCK TABLES `seat` WRITE;
/*!40000 ALTER TABLE `seat` DISABLE KEYS */;
INSERT INTO `seat` VALUES (62,'BN-A-001','001',0,32),(65,'BN-B-001','001',0,33),(69,'BN-C-001','001',1,34),(74,'NC-A-001','001',0,35),(75,'NC-A-002','002',0,35),(76,'NC-A-003','003',0,35),(77,'NC-A-004','004',0,35),(78,'NC-B-001','001',0,36),(79,'NC-B-002','002',0,36),(85,'BN-A-002','002',0,32),(86,'BN-A-003','003',0,32),(87,'BN-A-004','004',0,32),(88,'BN-A-005','005',0,32),(89,'BN-B-002','002',0,33),(90,'BN-B-003','003',0,33),(91,'BN-B-004','004',0,33),(92,'BN-C-002','002',0,34),(93,'BN-C-003','003',0,34),(94,'BN-C-004','004',0,34),(95,'BN-C-005','005',0,34),(96,'BN2-A-001','001',0,37),(97,'BN2-A-002','002',0,37),(98,'BN2-A-003','003',0,37),(99,'BN2-A-004','004',0,37),(100,'BN2-A-005','005',0,37),(101,'MMM2-VIP-001','001',0,38),(102,'MMM2-VIP-002','002',0,38),(103,'MMM2-VIP-003','003',0,38),(104,'MMM2-VIP-004','004',0,38),(105,'MMM2-VIP-005','005',0,38),(106,'MMM2-VIP1-001','001',0,39),(107,'MMM2-VIP1-002','002',0,39),(108,'BN2-B-001','001',0,40),(109,'BN2-B-002','002',0,40),(110,'BN2-B-003','003',0,40),(111,'BN2-B-004','004',0,40),(112,'BN2-B-005','005',0,40),(113,'BN2-B-006','006',0,40),(114,'BN2-B-007','007',0,40),(115,'NC-C-001','001',0,41),(116,'NC-C-002','002',0,41),(117,'NC-C-003','003',0,41),(118,'NC-C-004','004',0,41),(119,'NC-C-005','005',0,41),(120,'PY-B-001','001',0,42),(121,'PY-B-002','002',0,42),(122,'PY-B-003','003',0,42),(123,'PY-A-001','001',0,43),(124,'PY-A-002','002',0,43),(125,'PY-A-003','003',0,43),(126,'PY-A-004','004',0,43),(127,'PY-A-005','005',0,43),(128,'PY-C-001','001',0,44),(129,'PY-C-002','002',0,44),(130,'PY-C-003','003',0,44),(131,'PY-C-004','004',0,44),(132,'PY-C-005','005',0,44),(133,'PY-C-006','006',0,44),(134,'PY-C-007','007',0,44),(135,'BN-D-001','001',0,46),(136,'BN-D-002','002',0,46),(137,'BN-D-003','003',0,46);
/*!40000 ALTER TABLE `seat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `section`
--

DROP TABLE IF EXISTS `section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `section` (
  `section_id` int NOT NULL AUTO_INCREMENT,
  `section_name` varchar(100) NOT NULL,
  `capacity` int NOT NULL,
  `stadium_id` int NOT NULL,
  PRIMARY KEY (`section_id`),
  UNIQUE KEY `unique_stadium_section_name` (`stadium_id`,`section_name`),
  CONSTRAINT `section_stadium_id_9aecacd0_fk_stadium_stadium_id` FOREIGN KEY (`stadium_id`) REFERENCES `stadium` (`stadium_id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `section`
--

LOCK TABLES `section` WRITE;
/*!40000 ALTER TABLE `section` DISABLE KEYS */;
INSERT INTO `section` VALUES (32,'A',5,11),(33,'B',4,11),(34,'C',5,11),(35,'A',4,12),(36,'B',2,12),(37,'A',5,13),(38,'VIP',5,14),(39,'VIP1',2,14),(40,'B',7,13),(41,'C',5,12),(42,'B',3,15),(43,'A',5,15),(44,'C',7,15),(46,'D',3,11);
/*!40000 ALTER TABLE `section` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `section_price`
--

DROP TABLE IF EXISTS `section_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `section_price` (
  `pricing_id` int NOT NULL AUTO_INCREMENT,
  `price` decimal(10,2) NOT NULL,
  `available_seats` int NOT NULL,
  `is_closed` tinyint(1) NOT NULL,
  `sell_date` datetime(6) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `match_id` int NOT NULL,
  `section_id` int NOT NULL,
  PRIMARY KEY (`pricing_id`),
  UNIQUE KEY `unique_match_section` (`match_id`,`section_id`),
  KEY `section_price_section_id_0629ec4b_fk_section_section_id` (`section_id`),
  CONSTRAINT `section_price_match_id_4463eea9_fk_match_match_id` FOREIGN KEY (`match_id`) REFERENCES `match` (`match_id`),
  CONSTRAINT `section_price_section_id_0629ec4b_fk_section_section_id` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=304 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `section_price`
--

LOCK TABLES `section_price` WRITE;
/*!40000 ALTER TABLE `section_price` DISABLE KEYS */;
INSERT INTO `section_price` VALUES (261,1000000.00,3,1,'2025-05-03 14:12:00.000000','2025-05-03 14:10:52.326132',55,32),(262,4000000.00,4,1,'2025-05-03 14:12:00.000000','2025-05-03 14:11:03.542107',55,33),(263,300000.00,5,1,'2025-05-03 14:14:00.000000','2025-05-03 14:11:28.663766',55,34),(264,72000.00,0,1,'2025-05-03 14:29:00.000000','2025-05-03 14:15:21.478451',56,33),(265,60000.00,0,1,'2025-05-03 14:17:00.000000','2025-05-03 14:15:23.912042',56,32),(266,80000.00,0,1,'2025-05-03 14:18:00.000000','2025-05-03 14:16:54.546006',56,34),(267,1000000.00,0,1,'2025-05-03 14:23:00.000000','2025-05-03 14:20:54.127711',58,32),(273,91000.00,0,1,'2025-05-05 01:53:00.000000','2025-05-04 23:49:44.129788',58,33),(274,111000.00,1,1,'2025-05-04 23:54:00.000000','2025-05-04 23:53:51.646291',58,34),(275,113000.00,0,1,'2025-05-04 23:00:00.000000','2025-05-04 23:58:23.637923',60,36),(276,112000.00,3,1,'2025-05-04 23:00:00.000000','2025-05-04 23:58:25.014533',60,35),(279,1000000.00,5,1,'2025-05-05 00:40:00.000000','2025-05-05 00:39:53.442490',62,32),(280,50000.00,4,1,'2025-05-05 00:41:00.000000','2025-05-05 00:40:05.490911',62,33),(281,1000000.00,2,1,'2025-05-05 01:50:00.000000','2025-05-05 01:46:21.008414',63,32),(282,50000.00,5,1,'2025-05-05 01:53:00.000000','2025-05-05 01:52:37.167599',62,34),(283,81000.00,4,1,'2025-05-07 02:11:00.000000','2025-05-05 02:11:43.940761',63,33),(284,1200000.00,0,1,'2025-06-09 22:40:00.000000','2025-06-08 09:39:53.318827',65,37),(285,1200000.00,0,1,'2025-06-12 03:41:00.000000','2025-06-12 03:40:35.343848',66,35),(286,1250000.00,0,1,'2025-06-13 03:40:00.000000','2025-06-12 03:40:57.016191',66,36),(287,1500000.00,0,1,'2025-06-12 04:24:00.000000','2025-06-12 04:23:51.515697',65,40),(288,1360000.00,0,1,'2025-06-12 05:44:00.000000','2025-06-12 05:44:00.417573',67,35),(289,1900000.00,1,1,'2025-06-12 05:45:00.000000','2025-06-12 05:44:15.778805',67,36),(290,1700000.00,4,1,'2025-06-12 06:28:00.000000','2025-06-12 06:27:10.467943',67,41),(291,1000000.00,3,0,'2025-06-12 06:32:00.000000','2025-06-12 06:31:44.464859',68,32),(292,1100000.00,1,0,'2025-06-12 06:32:00.000000','2025-06-12 06:31:48.122192',68,33),(294,500000.00,5,1,'2025-06-18 13:00:00.000000','2025-06-15 13:00:51.155617',75,38),(295,600000.00,2,1,'2025-06-18 13:00:00.000000','2025-06-15 13:00:52.772065',75,39),(296,500000.00,3,0,'2025-06-16 07:21:00.000000','2025-06-16 07:20:31.609930',66,41),(297,1400000.00,1,0,'2025-06-16 07:21:00.000000','2025-06-16 07:21:00.031446',76,35),(298,3400000.00,2,0,'2025-06-16 07:22:00.000000','2025-06-16 07:21:12.637777',76,36),(299,450000.00,5,0,'2025-06-16 07:22:00.000000','2025-06-16 07:21:22.076680',76,41),(300,1000000.00,1,0,'2025-06-16 07:22:00.000000','2025-06-16 07:21:36.385290',77,35),(301,1000000.00,1,0,'2025-06-16 07:33:00.000000','2025-06-16 07:32:17.214804',78,35),(302,950000.00,5,0,'2025-06-16 07:33:00.000000','2025-06-16 07:32:32.798635',78,41),(303,1500000.00,4,0,'2025-06-16 07:35:00.000000','2025-06-16 07:34:33.095937',79,37);
/*!40000 ALTER TABLE `section_price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stadium`
--

DROP TABLE IF EXISTS `stadium`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stadium` (
  `stadium_id` int NOT NULL AUTO_INCREMENT,
  `stadium_name` varchar(255) NOT NULL,
  `stadium_code` varchar(5) NOT NULL,
  `location` varchar(255) NOT NULL,
  `capacity` int DEFAULT NULL,
  `stadium_layouts` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`stadium_id`),
  UNIQUE KEY `stadium_name` (`stadium_name`),
  UNIQUE KEY `stadium_code` (`stadium_code`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stadium`
--

LOCK TABLES `stadium` WRITE;
/*!40000 ALTER TABLE `stadium` DISABLE KEYS */;
INSERT INTO `stadium` VALUES (11,'Bernabeo','BN','Spain',17,'stadium_layouts/stadium-1.png'),(12,'Nou Camp','NC','Spain',11,'stadium_layouts/stadium-1.png'),(13,'Olympic Stadium','BN2','Anh',12,'stadium_layouts/stadium-1.png'),(14,'MAMAMA','MMM2','Hồ Chí Minh',7,'stadium_layouts/stadium-1.png'),(15,'PHÚ YÊN','PY','Tuy Hòa, Phú Yên',15,'stadium_layouts/stadium-1.png');
/*!40000 ALTER TABLE `stadium` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team` (
  `team_id` int NOT NULL AUTO_INCREMENT,
  `team_name` varchar(255) NOT NULL,
  `logo` varchar(100) DEFAULT NULL,
  `head_coach` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  PRIMARY KEY (`team_id`),
  UNIQUE KEY `team_name` (`team_name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
INSERT INTO `team` VALUES (11,'Barcelona FC','team_logos/barch_tx5GD9n.png','COACH A','Catalan'),(12,'Real Marid','team_logos/avdcorc1r_m7Nj1k5.webp','John Smith','Spain'),(13,'Mancherster United','team_logos/manchester-united_qidr2Ri_GYgRT2U.png','Jane Doe','Trận dabey'),(14,'HOÀNG ANH GIA LAI','team_logos/Hoang_Anh_Gia_Lai_FC.png','MINH ĐỨC','HEHEHE'),(15,'SÔNG LAM NGHỆ AN','team_logos/logo.png','MINH HOÀNG','Đội bóng'),(16,'Liverpool FC','team_logos/Liverpool_FC_logo.png','Jose Muninho','TPC'),(17,'Mancherster City','team_logos/Manchester_City_FC_logo.png','Pep Goudila','Man');
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_return`
--

DROP TABLE IF EXISTS `ticket_return`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket_return` (
  `return_id` int NOT NULL AUTO_INCREMENT,
  `return_reason` longtext NOT NULL,
  `return_status` varchar(50) NOT NULL,
  `refund_method` varchar(50) NOT NULL,
  `return_time` datetime(6) NOT NULL,
  `processed_time` datetime(6) DEFAULT NULL,
  `refund_amount` decimal(10,2) DEFAULT NULL,
  `note` longtext,
  `detail_id` int NOT NULL,
  `employee_id` int DEFAULT NULL,
  PRIMARY KEY (`return_id`),
  UNIQUE KEY `detail_id` (`detail_id`),
  KEY `ticket_return_employee_id_93879c5f_fk_employee_id` (`employee_id`),
  CONSTRAINT `ticket_return_detail_id_5a3698d3_fk_order_detail_detail_id` FOREIGN KEY (`detail_id`) REFERENCES `order_detail` (`detail_id`),
  CONSTRAINT `ticket_return_employee_id_93879c5f_fk_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_return`
--

LOCK TABLES `ticket_return` WRITE;
/*!40000 ALTER TABLE `ticket_return` DISABLE KEYS */;
INSERT INTO `ticket_return` VALUES (9,'Bận ','completed','bank_card','2025-05-05 00:59:43.462743','2025-05-05 01:02:19.294363',72000.00,'OK',293,2),(10,'Bận','completed','bank_card','2025-05-05 01:05:54.167384','2025-05-05 01:06:17.005458',68400.00,'OK',294,2),(11,'Buồn ngủ','rejected','','2025-06-12 04:12:55.623791','2025-06-12 04:14:00.990416',NULL,'KHÔNG CÓ ĐƯỢC',316,2),(12,'Bận đi chơi','completed','bank_card','2025-06-12 04:16:34.283794','2025-06-12 04:17:16.587781',948000.00,'OKEE',315,2),(13,'zzz','completed','bank_card','2025-06-12 04:25:33.993083','2025-06-12 04:25:43.168874',1200000.00,'',318,2),(14,'Đi chơi với ny','completed','bank_card','2025-06-12 04:33:14.715163','2025-06-12 04:43:04.348112',1200000.00,'',319,2),(15,'Hẹ hẹ hẹ','completed','bank_card','2025-06-12 04:45:17.167407','2025-06-12 04:45:27.136626',948000.00,'',325,2),(16,'Hẹ','completed','bank_card','2025-06-12 04:51:10.011913','2025-06-12 04:51:17.125797',948000.00,'',324,2),(17,'Bận đi thi','completed','bank_card','2025-06-12 06:23:07.309659','2025-06-12 06:23:25.148766',1088000.00,'',326,2),(18,'Check','completed','bank_card','2025-06-12 06:29:39.085547','2025-06-12 06:29:48.169989',1360000.00,'',331,2),(19,'Bận rồi','completed','bank_card','2025-06-12 06:33:20.488760','2025-06-12 06:33:31.645047',800000.00,'',333,2),(20,'Hẹ hẹ','completed','bank_card','2025-06-12 06:34:58.619261','2025-06-12 06:35:18.285183',880000.00,'',336,2),(21,'Tôi bận công việc','completed','cash','2025-06-13 18:26:35.875077','2025-06-13 18:28:34.121080',1200000.00,'',341,3),(22,'Bận việc','rejected','','2025-06-13 19:46:50.688202','2025-06-13 19:47:24.183499',NULL,'Gần sát giờ thi đấu',347,3),(23,'Bận đi làm đồ án','completed','bank_card','2025-06-13 19:49:46.749251','2025-06-13 19:50:03.598761',880000.00,'Đồng ý',348,3),(24,'Bận','completed','bank_card','2025-06-13 20:03:00.394272','2025-06-13 20:03:22.133404',880000.00,'Ok',349,3),(25,'Bận','completed','bank_card','2025-06-14 07:39:12.921118','2025-06-14 07:39:53.411390',880000.00,'',350,2),(26,'Bận ngủ','completed','bank_card','2025-06-14 10:04:27.413961','2025-06-14 10:05:36.281917',960000.00,'',353,2),(27,'Ban roi','rejected','','2025-06-14 10:12:38.736676','2025-06-14 10:12:53.731377',NULL,'Không được má',351,2),(28,'Bận','rejected','','2025-06-14 10:18:45.821047','2025-06-14 10:19:30.687004',NULL,'Vé không được hoàn',340,2),(29,'đi chơi với ny','rejected','','2025-06-14 10:31:05.507578','2025-06-14 10:31:17.014763',NULL,'Không được',328,2),(30,'Buồn ngủ quá','completed','bank_card','2025-06-14 10:33:05.669802','2025-06-14 10:33:17.614486',1088000.00,'Đồng ý',327,2),(31,'Khò khò','completed','bank_card','2025-06-14 10:35:24.676425','2025-06-14 10:35:42.175653',1088000.00,'OKEE',329,2),(32,'Bận','completed','bank_card','2025-06-15 13:18:21.235410','2025-06-15 13:18:33.880284',1360000.00,'',386,2),(33,'Buồn ngủ','completed','bank_card','2025-06-15 18:49:11.931190','2025-06-15 18:49:39.452510',1360000.00,'Đồng ý',387,2),(34,'Bận','completed','bank_card','2025-06-16 05:02:26.031971','2025-06-16 05:04:01.606151',880000.00,'Chấp nhận hoàn vé',402,2),(35,'Bão lớn, không thể đi được','completed','bank_card','2025-06-16 05:02:41.399237','2025-06-16 05:03:48.893625',1520000.00,'',404,2),(36,'Có chuyến đi công tác vào ngày đó','completed','bank_card','2025-06-16 05:03:02.956084','2025-06-16 05:03:42.648468',1088000.00,'',403,2),(37,'beenhj','completed','bank_card','2025-06-16 08:51:13.822735','2025-06-16 08:53:49.482951',1200000.00,'',408,2);
/*!40000 ALTER TABLE `ticket_return` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-01  0:35:56
