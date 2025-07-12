-- MySQL dump 10.14  Distrib 5.5.68-MariaDB, for Linux (x86_64)
--
-- Host: database-1.c59x4vzxfznl.ap-northeast-1.rds.amazonaws.com    Database: database-1
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `active_storage_attachments`
--

DROP TABLE IF EXISTS `active_storage_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_storage_attachments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `record_type` varchar(255) NOT NULL,
  `record_id` bigint NOT NULL,
  `blob_id` bigint NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_attachments_uniqueness` (`record_type`,`record_id`,`name`,`blob_id`),
  KEY `index_active_storage_attachments_on_blob_id` (`blob_id`),
  CONSTRAINT `fk_rails_c3b3935057` FOREIGN KEY (`blob_id`) REFERENCES `active_storage_blobs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_storage_attachments`
--

LOCK TABLES `active_storage_attachments` WRITE;
/*!40000 ALTER TABLE `active_storage_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_storage_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `active_storage_blobs`
--

DROP TABLE IF EXISTS `active_storage_blobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_storage_blobs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `metadata` text,
  `byte_size` bigint NOT NULL,
  `checksum` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_blobs_on_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_storage_blobs`
--

LOCK TABLES `active_storage_blobs` WRITE;
/*!40000 ALTER TABLE `active_storage_blobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_storage_blobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ar_internal_metadata`
--

DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_internal_metadata`
--

LOCK TABLES `ar_internal_metadata` WRITE;
/*!40000 ALTER TABLE `ar_internal_metadata` DISABLE KEYS */;
INSERT INTO `ar_internal_metadata` VALUES ('environment','production','2022-09-05 14:18:36','2022-09-05 14:18:36');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `charactor_skills`
--

DROP TABLE IF EXISTS `charactor_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `charactor_skills` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `skill_id` int DEFAULT NULL,
  `charactor_id` int DEFAULT NULL,
  `level` int DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `charactor_skills`
--

LOCK TABLES `charactor_skills` WRITE;
/*!40000 ALTER TABLE `charactor_skills` DISABLE KEYS */;
INSERT INTO `charactor_skills` VALUES (2,30,5,2,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(3,33,5,2,'2022-09-07 12:38:59','2022-10-06 09:32:49'),(4,29,5,1,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(5,32,4,5,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(6,37,5,5,'2022-09-07 12:38:59','2022-10-09 10:59:19'),(7,39,5,6,'2022-09-07 12:38:59','2022-10-10 10:12:54'),(8,37,4,5,'2022-09-07 12:38:59','2022-10-01 10:43:21'),(9,8,5,1,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(10,36,5,5,'2022-09-07 12:38:59','2022-10-06 09:32:49'),(11,40,6,1,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(12,31,4,7,'2022-09-07 12:38:59','2022-10-04 10:18:02'),(13,32,5,7,'2022-09-07 12:38:59','2022-10-05 10:19:37'),(14,29,4,5,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(15,40,5,7,'2022-09-07 12:38:59','2022-09-30 10:47:23'),(16,34,5,3,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(17,50,5,1,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(18,34,4,4,'2022-09-07 12:38:59','2022-10-03 09:48:21'),(19,38,4,9,'2022-09-07 12:38:59','2022-10-09 11:00:13'),(20,2,5,3,'2022-09-07 12:38:59','2022-09-29 10:25:22'),(21,32,6,1,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(22,33,6,1,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(23,35,4,5,'2022-09-07 12:38:59','2022-09-29 10:26:45'),(24,28,4,3,'2022-09-07 12:38:59','2022-10-07 10:05:11'),(25,18,5,1,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(26,5,4,2,'2022-09-07 12:38:59','2022-09-26 10:28:56'),(27,36,4,4,'2022-09-07 12:38:59','2022-10-10 10:13:32'),(28,28,5,3,'2022-09-07 12:38:59','2022-10-07 10:04:17'),(29,40,4,5,'2022-09-07 12:38:59','2022-10-06 09:31:43'),(30,55,3,1,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(31,30,4,5,'2022-09-07 12:38:59','2022-10-07 10:05:11'),(32,33,4,3,'2022-09-07 12:38:59','2022-09-16 09:48:18'),(33,38,5,3,'2022-09-07 12:38:59','2022-10-01 10:42:32'),(34,5,5,1,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(35,10,4,2,'2022-09-07 12:38:59','2022-09-12 10:35:50'),(36,1,5,1,'2022-09-07 12:38:59','2022-09-07 12:38:59'),(37,35,5,2,'2022-09-07 12:38:59','2022-09-25 10:23:56'),(38,39,4,2,'2022-09-07 12:38:59','2022-09-30 10:46:22'),(39,27,3,1,'2022-09-07 12:42:14','2022-09-07 12:42:14'),(40,25,5,1,'2022-09-12 10:36:47','2022-09-12 10:36:47'),(41,31,5,1,'2022-09-16 09:48:55','2022-09-16 09:48:55'),(42,51,5,2,'2022-09-26 10:26:46','2022-09-29 10:25:22'),(43,4,5,1,'2022-09-26 10:26:46','2022-09-26 10:26:46'),(44,44,5,1,'2022-09-27 09:39:24','2022-09-27 09:39:24'),(45,55,4,1,'2022-09-27 09:41:31','2022-09-27 09:41:31'),(46,8,4,2,'2022-09-27 09:41:31','2022-10-05 10:20:56'),(47,15,4,1,'2022-09-27 09:41:31','2022-09-27 09:41:31'),(48,11,4,2,'2022-09-28 10:25:30','2022-10-07 10:05:11'),(49,48,4,1,'2022-09-29 10:26:45','2022-09-29 10:26:45'),(50,12,4,1,'2022-09-30 10:46:22','2022-09-30 10:46:22'),(51,45,5,1,'2022-09-30 10:47:23','2022-09-30 10:47:23'),(52,42,5,1,'2022-09-30 10:47:23','2022-09-30 10:47:23'),(53,21,5,1,'2022-10-01 10:42:32','2022-10-01 10:42:32'),(54,12,5,1,'2022-10-02 10:41:21','2022-10-02 10:41:21'),(55,41,4,2,'2022-10-02 10:43:12','2022-10-09 11:00:13'),(56,6,4,1,'2022-10-02 10:43:12','2022-10-02 10:43:12'),(57,46,5,1,'2022-10-03 09:47:30','2022-10-03 09:47:30'),(58,52,4,1,'2022-10-04 10:18:02','2022-10-04 10:18:02'),(59,45,4,1,'2022-10-06 09:31:43','2022-10-06 09:31:43'),(60,3,4,1,'2022-10-06 09:31:43','2022-10-06 09:31:43'),(61,13,5,1,'2022-10-06 09:32:49','2022-10-06 09:32:49'),(62,20,5,1,'2022-10-06 09:32:49','2022-10-06 09:32:49'),(63,26,4,1,'2022-10-07 10:05:11','2022-10-07 10:05:11');
/*!40000 ALTER TABLE `charactor_skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `charactor_tickets`
--

DROP TABLE IF EXISTS `charactor_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `charactor_tickets` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ticket_id` int DEFAULT NULL,
  `charactor_id` int DEFAULT NULL,
  `used` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=262 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `charactor_tickets`
--

LOCK TABLES `charactor_tickets` WRITE;
/*!40000 ALTER TABLE `charactor_tickets` DISABLE KEYS */;
INSERT INTO `charactor_tickets` VALUES (181,2,3,1,'2022-10-10 12:21:11','2022-10-10 12:21:24'),(182,2,5,1,'2022-10-12 09:31:38','2022-10-17 12:02:00'),(183,2,5,1,'2022-10-12 09:31:42','2022-10-17 12:02:02'),(184,2,5,1,'2022-10-12 09:31:45','2022-10-17 12:02:03'),(185,2,5,1,'2022-10-12 09:31:48','2022-10-17 12:02:05'),(186,2,5,1,'2022-10-12 09:31:50','2022-10-17 12:02:06'),(187,2,5,1,'2022-10-12 09:31:52','2022-10-17 12:02:08'),(188,2,5,1,'2022-10-12 09:31:55','2022-10-17 12:02:10'),(189,2,5,1,'2022-10-12 09:31:58','2022-10-17 12:02:11'),(190,2,5,1,'2022-10-12 09:32:02','2022-10-17 12:02:13'),(191,2,5,1,'2022-10-12 09:32:06','2022-10-17 12:02:15'),(192,2,4,1,'2022-10-12 09:32:27','2022-10-17 12:01:39'),(193,2,4,1,'2022-10-12 09:32:36','2022-10-17 12:01:41'),(194,2,4,1,'2022-10-12 09:32:41','2022-10-17 12:01:42'),(195,2,4,1,'2022-10-12 09:32:45','2022-10-17 12:01:44'),(196,2,4,1,'2022-10-12 09:32:52','2022-10-17 12:01:46'),(197,2,4,1,'2022-10-12 09:32:55','2022-10-17 12:01:48'),(198,2,4,1,'2022-10-12 09:33:02','2022-10-17 12:01:49'),(199,2,4,1,'2022-10-12 09:33:06','2022-10-17 12:01:51'),(200,2,4,1,'2022-10-12 09:33:09','2022-10-17 12:01:52'),(201,2,4,1,'2022-10-12 09:33:12','2022-10-17 12:01:54'),(202,5,3,0,'2022-10-12 12:36:31','2022-10-12 12:36:31'),(203,5,3,0,'2022-10-12 12:36:34','2022-10-12 12:36:34'),(204,5,5,0,'2022-10-14 09:43:59','2022-10-14 09:43:59'),(205,3,4,1,'2022-10-14 09:44:12','2022-10-21 10:35:59'),(206,3,4,1,'2022-10-19 04:05:29','2023-02-06 10:48:01'),(207,3,5,1,'2022-10-19 04:05:44','2022-10-21 10:36:07'),(208,2,4,1,'2022-10-22 06:02:23','2022-10-22 06:03:36'),(209,2,4,1,'2022-10-22 06:02:25','2022-10-22 06:03:38'),(210,2,4,1,'2022-10-22 06:02:27','2022-10-22 06:03:39'),(211,2,4,1,'2022-10-22 06:02:29','2022-10-22 06:03:41'),(212,2,4,1,'2022-10-22 06:02:30','2022-10-22 06:03:43'),(213,2,4,1,'2022-10-22 06:02:32','2022-10-22 06:03:44'),(214,2,4,1,'2022-10-22 06:02:34','2022-10-22 06:03:46'),(215,2,4,1,'2022-10-22 06:02:36','2022-10-22 06:03:48'),(216,2,4,1,'2022-10-22 06:02:39','2022-10-22 06:03:49'),(217,2,4,1,'2022-10-22 06:02:57','2022-10-22 06:03:51'),(218,2,4,1,'2022-10-29 00:42:11','2022-10-29 00:42:36'),(219,2,4,1,'2022-10-29 00:42:13','2022-10-29 00:42:37'),(220,2,4,1,'2022-10-29 00:42:15','2022-10-29 00:42:39'),(221,2,4,1,'2022-10-29 00:42:16','2022-10-29 00:42:40'),(222,2,4,1,'2022-10-29 00:42:19','2022-10-29 00:42:42'),(223,2,4,1,'2022-10-29 00:42:20','2022-10-29 00:42:44'),(224,2,4,1,'2022-10-29 00:42:22','2022-10-29 00:42:45'),(225,2,4,1,'2022-10-29 00:42:24','2022-10-29 00:42:47'),(226,2,4,1,'2022-10-29 00:42:26','2022-10-29 00:42:49'),(227,2,4,1,'2022-10-29 00:42:27','2022-10-29 00:42:50'),(228,2,5,1,'2022-10-29 00:42:57','2022-10-29 00:43:18'),(229,2,5,1,'2022-10-29 00:42:59','2022-10-29 00:43:20'),(230,2,5,1,'2022-10-29 00:43:00','2022-10-29 00:43:21'),(231,2,5,1,'2022-10-29 00:43:02','2022-10-29 00:43:23'),(232,2,5,1,'2022-10-29 00:43:04','2022-10-29 00:43:25'),(233,2,5,1,'2022-10-29 00:43:05','2022-10-29 00:43:27'),(234,2,5,1,'2022-10-29 00:43:07','2022-10-29 00:43:29'),(235,2,5,1,'2022-10-29 00:43:08','2022-10-29 00:43:31'),(236,2,5,1,'2022-10-29 00:43:10','2022-10-29 00:43:33'),(237,2,5,1,'2022-10-29 00:43:12','2022-10-29 00:43:34'),(238,6,4,1,'2022-12-15 10:39:06','2023-01-31 10:46:21'),(239,2,4,0,'2022-12-15 10:39:13','2022-12-15 10:39:13'),(240,2,4,0,'2022-12-15 10:39:17','2022-12-15 10:39:17'),(241,2,4,0,'2022-12-15 10:39:21','2022-12-15 10:39:21'),(242,2,4,0,'2022-12-15 10:39:25','2022-12-15 10:39:25'),(243,2,4,0,'2022-12-15 10:39:28','2022-12-15 10:39:28'),(244,2,4,0,'2022-12-15 10:39:34','2022-12-15 10:39:34'),(245,6,5,1,'2022-12-15 10:39:47','2023-01-31 10:48:20'),(246,4,5,0,'2022-12-15 10:39:56','2022-12-15 10:39:56'),(247,4,5,0,'2022-12-15 10:40:00','2022-12-15 10:40:00'),(248,4,5,0,'2022-12-15 10:40:03','2022-12-15 10:40:03'),(249,4,5,0,'2022-12-15 10:40:06','2022-12-15 10:40:06'),(250,6,4,1,'2023-01-31 10:46:10','2023-01-31 10:46:27'),(251,6,5,1,'2023-01-31 10:48:13','2023-01-31 10:48:23'),(252,3,5,1,'2023-02-06 10:48:11','2023-02-06 10:48:17'),(253,5,5,0,'2023-02-08 10:46:14','2023-02-08 10:46:14'),(254,5,5,0,'2023-02-08 10:46:15','2023-02-08 10:46:15'),(255,2,4,0,'2023-02-08 10:46:27','2023-02-08 10:46:27'),(256,2,4,0,'2023-02-09 10:32:54','2023-02-09 10:32:54'),(257,3,5,0,'2023-02-09 10:33:11','2023-02-09 10:33:11'),(258,2,4,0,'2023-02-16 10:40:50','2023-02-16 10:40:50'),(259,2,5,0,'2023-02-16 10:41:29','2023-02-16 10:41:29'),(260,2,4,0,'2023-02-20 10:33:59','2023-02-20 10:33:59'),(261,1,4,1,'2023-07-01 00:48:49','2023-10-16 10:31:24');
/*!40000 ALTER TABLE `charactor_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `charactors`
--

DROP TABLE IF EXISTS `charactors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `charactors` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `exp` int DEFAULT '0',
  `motion_level` int DEFAULT '1',
  `knowledge_level` int DEFAULT '1',
  `health_level` int DEFAULT '1',
  `communication_level` int DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `motion_exp` int DEFAULT '0',
  `knowledge_exp` int DEFAULT '0',
  `health_exp` int DEFAULT '0',
  `communication_exp` int DEFAULT '0',
  `total_exp` int DEFAULT '0',
  `shop_point` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `charactors`
--

LOCK TABLES `charactors` WRITE;
/*!40000 ALTER TABLE `charactors` DISABLE KEYS */;
INSERT INTO `charactors` VALUES (3,'パパ',2,0,2,3,1,2,'2022-09-07 12:35:44','2023-07-01 00:48:49',0,85,90,94,82,668),(4,'たくみ',2,0,114,105,290,170,'2022-09-07 12:35:44','2023-11-21 09:07:32',80,40,75,40,65,41625),(5,'みなと',2,0,73,149,324,34,'2022-09-07 12:35:44','2023-11-21 09:08:35',20,23,15,70,78,39443),(6,'ママ',2,0,3,1,7,1,'2022-09-07 12:35:44','2023-02-24 10:52:40',20,10,90,0,0,860);
/*!40000 ALTER TABLE `charactors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `experience_logs`
--

DROP TABLE IF EXISTS `experience_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `experience_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `experience_id` int DEFAULT NULL,
  `unit` int DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `experience_logs`
--

LOCK TABLES `experience_logs` WRITE;
/*!40000 ALTER TABLE `experience_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `experience_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `experiences`
--

DROP TABLE IF EXISTS `experiences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `experiences` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `unit_exp` int DEFAULT NULL,
  `level` int DEFAULT '1',
  `exp` int DEFAULT '0',
  `explanation` varchar(255) DEFAULT NULL,
  `charactor_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `experiences`
--

LOCK TABLES `experiences` WRITE;
/*!40000 ALTER TABLE `experiences` DISABLE KEYS */;
INSERT INTO `experiences` VALUES (8,'家事','日',30,1,30,'',6,3,'2022-09-07 12:41:42','2022-09-07 12:41:42'),(9,'勉強','時間',10,1,20,'',3,2,'2022-09-07 12:41:42','2022-10-07 11:35:35'),(10,'読書','冊',30,1,0,'',3,2,'2022-09-07 12:41:42','2022-09-07 12:41:42'),(11,'軽い運動','時間',10,1,30,'散歩やサイクリング',3,3,'2022-09-07 12:41:42','2022-09-07 12:41:42'),(15,'送り迎え','日',10,1,20,'',6,1,'2022-09-07 12:41:42','2022-09-07 12:41:42'),(28,'ひとによいことをする','回',50,1,0,'ひとにやさしくしたり、よいことをするとけいけんちがあがるよ。',4,4,'2022-09-24 11:14:38','2022-09-24 11:14:38'),(34,'ひとによいことをする','回',50,1,0,'ひとにやさしくしたり、よいことをするとけいけんちがあがるよ。',5,4,'2022-09-24 11:22:03','2022-09-24 11:22:03'),(40,'おべんきょうをしよう','回',30,1,0,'ひらがなをかいたり、たしざんをしたり…ちしきをふやそう。',5,2,'2022-09-24 11:27:48','2022-09-24 11:27:48'),(41,'おべんきょうをしよう','回',30,1,0,'ひらがなをかいたりカタカナをかいたり…ちしきをふやそう。',4,2,'2022-09-24 11:28:35','2022-09-24 11:28:35'),(42,'算数を勉強する','ページ',10,1,0,'',6,2,'2022-10-12 12:35:36','2022-10-12 12:35:36'),(45,'おてつだいしたよ','回',30,1,0,'おてつだい、いっぱいしてみよう！',5,3,'2022-11-09 10:45:07','2023-03-13 07:32:06'),(46,'おてつだいしたよ','回',20,1,0,'いっぱいおてつだいしてみよう！',4,3,'2022-11-16 09:18:57','2023-03-13 07:31:57'),(49,'はじめてのおともだち','',40,1,0,'がっこうではなしたことのないおともだちと、はじめておはなししよう!',5,4,'2023-03-13 07:29:02','2023-03-13 07:30:54'),(50,'はじめてのおともだち','',40,1,0,'いままではなしたことのない、おともだちとはなしてみよう',4,4,'2023-03-13 07:31:37','2023-03-13 07:31:37'),(51,'たいいく','日',20,1,0,'たいいくや、おそとあそびをしよう',5,1,'2023-03-13 07:34:02','2023-03-13 07:34:02'),(52,'たいいく','日',20,1,0,'たいいくや、サッカー',4,1,'2023-03-13 07:34:34','2023-03-13 07:34:34');
/*!40000 ALTER TABLE `experiences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_htmls`
--

DROP TABLE IF EXISTS `import_htmls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `import_htmls` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `managed_html_id` int DEFAULT NULL,
  `import_html_id` int DEFAULT NULL,
  `asset_type` int DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_htmls`
--

LOCK TABLES `import_htmls` WRITE;
/*!40000 ALTER TABLE `import_htmls` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_htmls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `managed_htmls`
--

DROP TABLE IF EXISTS `managed_htmls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `managed_htmls` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `public` tinyint(1) NOT NULL DEFAULT '0',
  `body` text,
  `js_body` text,
  `css_body` text,
  `note` varchar(255) DEFAULT NULL,
  `yaml` text,
  `use_yaml` tinyint(1) DEFAULT '1',
  `level` int DEFAULT NULL,
  `js_note` varchar(255) DEFAULT NULL,
  `css_note` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `managed_htmls`
--

LOCK TABLES `managed_htmls` WRITE;
/*!40000 ALTER TABLE `managed_htmls` DISABLE KEYS */;
INSERT INTO `managed_htmls` VALUES (1,'いろいろな計算',1,0,'<head>\r\n<script id=\"MathJax-script\" async\r\n  src=\"https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js\">\r\n</script>\r\n</head>\r\n\r\n<div class=\"container\">\r\n<h2>ローンの計算</h2>\r\n<p>\r\n  m: 毎月返済額、k: 借入金、n: 支払い回数, s: 利率(月), h: 頭金とすると<br />\r\n\\[\r\n  m = \\frac{s(k - h)(1 + s)^n}{(1+s)^n - 1}\r\n\\]\r\nここで、\r\n\\[\r\n  a = \\frac{s(1 + s)^n}{(1+s)^n - 1}\r\n\\]\r\n  のようにおくと、上の式は\r\n\\[\r\n  m = a(k-h)\r\n\\]\r\n  と書くことができるので、このaを月額率と呼ぶ<br />\r\n  トータルの払い込みは$mn+h = an(k-h)+h$と書くことができる<br />\r\n  利息分は$nm-k$\r\n</p>\r\n<h3>月額率表</h3>\r\n\r\n\r\n\r\n<table class=\"table\">\r\n  \r\n    <tr><td>年数\\利率(年)</td><td>0.12%</td><td>0.24%</td><td>1.2%</td><td>3.6%</td><td>6.0%</td><td>12%</td><td>18.0%</td></tr>\r\n  \r\n    <tr><td>1(12回)</td><td>0.083(1.001)</td><td>0.083(1.001)</td><td>0.084(1.007)</td><td>0.085(1.02)</td><td>0.086(1.033)</td><td>0.089(1.066)</td><td>0.092(1.1)</td></tr>\r\n  \r\n    <tr><td>2(24回)</td><td>0.042(1.001)</td><td>0.042(1.003)</td><td>0.042(1.013)</td><td>0.043(1.038)</td><td>0.044(1.064)</td><td>0.047(1.13)</td><td>0.05(1.198)</td></tr>\r\n  \r\n    <tr><td>3(36回)</td><td>0.028(1.002)</td><td>0.028(1.004)</td><td>0.028(1.019)</td><td>0.029(1.056)</td><td>0.03(1.095)</td><td>0.033(1.196)</td><td>0.036(1.301)</td></tr>\r\n  \r\n    <tr><td>4(48回)</td><td>0.021(1.002)</td><td>0.021(1.005)</td><td>0.021(1.025)</td><td>0.022(1.075)</td><td>0.023(1.127)</td><td>0.026(1.264)</td><td>0.029(1.41)</td></tr>\r\n  \r\n    <tr><td>5(60回)</td><td>0.017(1.003)</td><td>0.017(1.006)</td><td>0.017(1.031)</td><td>0.018(1.094)</td><td>0.019(1.16)</td><td>0.022(1.335)</td><td>0.025(1.524)</td></tr>\r\n  \r\n    <tr><td>6(72回)</td><td>0.014(1.004)</td><td>0.014(1.007)</td><td>0.014(1.037)</td><td>0.015(1.113)</td><td>0.017(1.193)</td><td>0.02(1.408)</td><td>0.023(1.642)</td></tr>\r\n  \r\n    <tr><td>7(84回)</td><td>0.012(1.004)</td><td>0.012(1.009)</td><td>0.012(1.043)</td><td>0.013(1.133)</td><td>0.015(1.227)</td><td>0.018(1.483)</td><td>0.021(1.765)</td></tr>\r\n  \r\n    <tr><td>8(96回)</td><td>0.01(1.005)</td><td>0.011(1.01)</td><td>0.011(1.049)</td><td>0.012(1.152)</td><td>0.013(1.262)</td><td>0.016(1.56)</td><td>0.02(1.893)</td></tr>\r\n  \r\n    <tr><td>9(108回)</td><td>0.009(1.005)</td><td>0.009(1.011)</td><td>0.01(1.055)</td><td>0.011(1.172)</td><td>0.012(1.297)</td><td>0.015(1.64)</td><td>0.019(2.026)</td></tr>\r\n  \r\n    <tr><td>10(120回)</td><td>0.008(1.006)</td><td>0.008(1.012)</td><td>0.009(1.062)</td><td>0.01(1.192)</td><td>0.011(1.332)</td><td>0.014(1.722)</td><td>0.018(2.162)</td></tr>\r\n  \r\n    <tr><td>11(132回)</td><td>0.008(1.007)</td><td>0.008(1.013)</td><td>0.008(1.068)</td><td>0.009(1.213)</td><td>0.01(1.368)</td><td>0.014(1.805)</td><td>0.017(2.303)</td></tr>\r\n  \r\n    <tr><td>12(144回)</td><td>0.007(1.007)</td><td>0.007(1.015)</td><td>0.007(1.074)</td><td>0.009(1.233)</td><td>0.01(1.405)</td><td>0.013(1.891)</td><td>0.017(2.447)</td></tr>\r\n  \r\n    <tr><td>13(156回)</td><td>0.006(1.008)</td><td>0.007(1.016)</td><td>0.007(1.081)</td><td>0.008(1.254)</td><td>0.009(1.443)</td><td>0.013(1.979)</td><td>0.017(2.594)</td></tr>\r\n  \r\n    <tr><td>14(168回)</td><td>0.006(1.008)</td><td>0.006(1.017)</td><td>0.006(1.087)</td><td>0.008(1.275)</td><td>0.009(1.48)</td><td>0.012(2.069)</td><td>0.016(2.745)</td></tr>\r\n  \r\n    <tr><td>15(180回)</td><td>0.006(1.009)</td><td>0.006(1.018)</td><td>0.006(1.093)</td><td>0.007(1.296)</td><td>0.008(1.519)</td><td>0.012(2.16)</td><td>0.016(2.899)</td></tr>\r\n  \r\n    <tr><td>16(192回)</td><td>0.005(1.01)</td><td>0.005(1.019)</td><td>0.006(1.1)</td><td>0.007(1.317)</td><td>0.008(1.558)</td><td>0.012(2.254)</td><td>0.016(3.055)</td></tr>\r\n  \r\n    <tr><td>17(204回)</td><td>0.005(1.01)</td><td>0.005(1.021)</td><td>0.005(1.106)</td><td>0.007(1.338)</td><td>0.008(1.598)</td><td>0.012(2.348)</td><td>0.016(3.214)</td></tr>\r\n  \r\n    <tr><td>18(216回)</td><td>0.005(1.011)</td><td>0.005(1.022)</td><td>0.005(1.112)</td><td>0.006(1.36)</td><td>0.008(1.638)</td><td>0.011(2.445)</td><td>0.016(3.375)</td></tr>\r\n  \r\n    <tr><td>19(228回)</td><td>0.004(1.011)</td><td>0.004(1.023)</td><td>0.005(1.119)</td><td>0.006(1.382)</td><td>0.007(1.678)</td><td>0.011(2.543)</td><td>0.016(3.539)</td></tr>\r\n  \r\n    <tr><td>20(240回)</td><td>0.004(1.012)</td><td>0.004(1.024)</td><td>0.005(1.125)</td><td>0.006(1.404)</td><td>0.007(1.719)</td><td>0.011(2.643)</td><td>0.015(3.704)</td></tr>\r\n  \r\n    <tr><td>21(252回)</td><td>0.004(1.013)</td><td>0.004(1.026)</td><td>0.004(1.132)</td><td>0.006(1.427)</td><td>0.007(1.761)</td><td>0.011(2.744)</td><td>0.015(3.871)</td></tr>\r\n  \r\n    <tr><td>22(264回)</td><td>0.004(1.013)</td><td>0.004(1.027)</td><td>0.004(1.138)</td><td>0.005(1.449)</td><td>0.007(1.803)</td><td>0.011(2.846)</td><td>0.015(4.039)</td></tr>\r\n  \r\n    <tr><td>23(276回)</td><td>0.004(1.014)</td><td>0.004(1.028)</td><td>0.004(1.145)</td><td>0.005(1.472)</td><td>0.007(1.846)</td><td>0.011(2.949)</td><td>0.015(4.209)</td></tr>\r\n  \r\n    <tr><td>24(288回)</td><td>0.004(1.015)</td><td>0.004(1.029)</td><td>0.004(1.151)</td><td>0.005(1.495)</td><td>0.007(1.889)</td><td>0.011(3.054)</td><td>0.015(4.38)</td></tr>\r\n  \r\n    <tr><td>25(300回)</td><td>0.003(1.015)</td><td>0.003(1.03)</td><td>0.004(1.158)</td><td>0.005(1.518)</td><td>0.006(1.933)</td><td>0.011(3.16)</td><td>0.015(4.552)</td></tr>\r\n  \r\n    <tr><td>26(312回)</td><td>0.003(1.016)</td><td>0.003(1.032)</td><td>0.004(1.165)</td><td>0.005(1.541)</td><td>0.006(1.977)</td><td>0.01(3.266)</td><td>0.015(4.725)</td></tr>\r\n  \r\n    <tr><td>27(324回)</td><td>0.003(1.016)</td><td>0.003(1.033)</td><td>0.004(1.171)</td><td>0.005(1.565)</td><td>0.006(2.022)</td><td>0.01(3.374)</td><td>0.015(4.899)</td></tr>\r\n  \r\n    <tr><td>28(336回)</td><td>0.003(1.017)</td><td>0.003(1.034)</td><td>0.004(1.178)</td><td>0.005(1.589)</td><td>0.006(2.067)</td><td>0.01(3.483)</td><td>0.015(5.074)</td></tr>\r\n  \r\n    <tr><td>29(348回)</td><td>0.003(1.018)</td><td>0.003(1.035)</td><td>0.003(1.185)</td><td>0.005(1.613)</td><td>0.006(2.112)</td><td>0.01(3.593)</td><td>0.015(5.25)</td></tr>\r\n  \r\n    <tr><td>30(360回)</td><td>0.003(1.018)</td><td>0.003(1.037)</td><td>0.003(1.191)</td><td>0.005(1.637)</td><td>0.006(2.158)</td><td>0.01(3.703)</td><td>0.015(5.426)</td></tr>\r\n  \r\n    <tr><td>31(372回)</td><td>0.003(1.019)</td><td>0.003(1.038)</td><td>0.003(1.198)</td><td>0.004(1.661)</td><td>0.006(2.205)</td><td>0.01(3.814)</td><td>0.015(5.602)</td></tr>\r\n  \r\n    <tr><td>32(384回)</td><td>0.003(1.019)</td><td>0.003(1.039)</td><td>0.003(1.205)</td><td>0.004(1.686)</td><td>0.006(2.252)</td><td>0.01(3.926)</td><td>0.015(5.779)</td></tr>\r\n  \r\n    <tr><td>33(396回)</td><td>0.003(1.02)</td><td>0.003(1.04)</td><td>0.003(1.212)</td><td>0.004(1.71)</td><td>0.006(2.299)</td><td>0.01(4.039)</td><td>0.015(5.956)</td></tr>\r\n  \r\n    <tr><td>34(408回)</td><td>0.003(1.021)</td><td>0.003(1.041)</td><td>0.003(1.218)</td><td>0.004(1.735)</td><td>0.006(2.347)</td><td>0.01(4.152)</td><td>0.015(6.134)</td></tr>\r\n  \r\n    <tr><td>35(420回)</td><td>0.002(1.021)</td><td>0.002(1.043)</td><td>0.003(1.225)</td><td>0.004(1.76)</td><td>0.006(2.395)</td><td>0.01(4.265)</td><td>0.015(6.312)</td></tr>\r\n  \r\n    <tr><td>36(432回)</td><td>0.002(1.022)</td><td>0.002(1.044)</td><td>0.003(1.232)</td><td>0.004(1.786)</td><td>0.006(2.443)</td><td>0.01(4.38)</td><td>0.015(6.49)</td></tr>\r\n  \r\n    <tr><td>37(444回)</td><td>0.002(1.022)</td><td>0.002(1.045)</td><td>0.003(1.239)</td><td>0.004(1.811)</td><td>0.006(2.492)</td><td>0.01(4.494)</td><td>0.015(6.669)</td></tr>\r\n  \r\n    <tr><td>38(456回)</td><td>0.002(1.023)</td><td>0.002(1.046)</td><td>0.003(1.246)</td><td>0.004(1.837)</td><td>0.006(2.541)</td><td>0.01(4.609)</td><td>0.015(6.848)</td></tr>\r\n  \r\n    <tr><td>39(468回)</td><td>0.002(1.024)</td><td>0.002(1.048)</td><td>0.003(1.253)</td><td>0.004(1.862)</td><td>0.006(2.591)</td><td>0.01(4.725)</td><td>0.015(7.027)</td></tr>\r\n  \r\n    <tr><td>40(480回)</td><td>0.002(1.024)</td><td>0.002(1.049)</td><td>0.003(1.26)</td><td>0.004(1.888)</td><td>0.006(2.641)</td><td>0.01(4.841)</td><td>0.015(7.206)</td></tr>\r\n  \r\n</table>\r\n\r\n\r\n\r\n<div id=\"loan\" class=\"flex\">\r\n  <div class=\"left\">\r\n    <div class=\"input\">\r\n      <label>返済年数[必須]</label>\r\n      <input type=\"text\" id=\"loan-n\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>年利率(%)[必須]</label> <input type=\"text\" id=\"loan-r\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>借入金(万円)</label> <input type=\"text\" id=\"loan-k\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>頭金</label> <input type=\"text\" id=\"loan-h\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>毎月返済額</label> <input type=\"text\" id=\"loan-m\">\r\n    </div>\r\n    <small>借入金か返済額のいずれかを入力して計算ボタンをおす</small>\r\n    <div class=\"calc-btn\">\r\n      <button id=\"calc-loan\" type=\"button\" class=\"btn btn-primary\">計算</button>\r\n    </div>\r\n  </div>\r\n  <div class=\"right\">\r\n    result: <span id=\"loan-result\"></span>\r\n  </div>\r\n</div>\r\n\r\n<h2>単利複利計算</h2>\r\n<div id=\"rate\" class=\"flex\">\r\n  <div class=\"left\">\r\n    <div class=\"input\">\r\n      <label>利率(%)</label> <input type=\"text\" id=\"rate-r\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>回数</label> <input type=\"text\" id=\"rate-n\">\r\n    </div>\r\n    <div class=\"calc-btn\">\r\n      <button id=\"calc-rate\" type=\"button\" class=\"btn btn-primary\">計算</button>\r\n    </div>\r\n  </div>\r\n  <div class=\"right\">\r\n    result: <span id=\"rate-result\"></span>\r\n  </div>\r\n</div>\r\n\r\n<h2>和積計算</h2>\r\n<div id=\"rate\" class=\"flex\">\r\n  <div class=\"left\">\r\n    <div class=\"\">\r\n      <label>数値</label>\r\n    </div>\r\n    <div class=\"input\">\r\n      <textarea type=\"text\" id=\"sum-n\" placeholder=\"12 34 56\" style=\"width: 100%\" rows=5></textarea>\r\n    </div>\r\n    <div class=\"calc-btn\">\r\n      <button id=\"calc-sum\" type=\"button\" class=\"btn btn-primary\">計算</button>\r\n    </div>\r\n  </div>\r\n  <div class=\"right\">\r\n    result: <span id=\"sum-result\"></span>\r\n  </div>\r\n</div>\r\n\r\n</div>','$(\"#calc-loan\").on(\'click\', function(){\r\n  const n = parseInt($(\"#loan-n\").val()) * 12\r\n  const s = parseFloat($(\"#loan-r\").val())/1200\r\n  const k = parseFloat($(\"#loan-k\").val())\r\n  let h = parseFloat($(\"#loan-h\").val())\r\n  const m = parseFloat($(\"#loan-m\").val())\r\n  let a = monthly_rate(s, n) // 月額率\r\n  if(isNaN(h)){ // 頭金がない場合は0\r\n    h = 0.0\r\n  }\r\n  if(isNaN(k)){ // 借入金がない場合は借入金を計算\r\n    result_k = m / a\r\n    $(\"#loan-result\").text(\"借入金額は\" + result_k)\r\n  }else if(isNaN(m)){// 毎月返済額がない場合は借入金を計算\r\n    result_m = (k - h) * a\r\n    total = result_m * n + h\r\n    $(\"#loan-result\").html(\"<br>毎月返済額は\" + result_m + \"。<br>総支払額は\"+ total)\r\n  }\r\n});\r\n\r\n\r\n$(\"#calc-rate\").on(\'click\', function(){\r\n  const n = parseInt($(\"#rate-n\").val())\r\n  const r = parseFloat($(\"#rate-r\").val())/100\r\n  $(\"#rate-result\").html(\"<br />単利: \" + (1 + n * r) + \"<br />複利: \" + Math.pow(1+r, n) )\r\n});\r\n\r\n$(\"#calc-sum\").on(\'click\', function(){\r\n  const nums = $(\"#sum-n\").val().split(\' \')\r\n  sum = 0\r\n  prod = 1\r\n  nums.forEach(n => {\r\n    if(n !== \'\'){\r\n      sum += parseFloat(n)\r\n      prod *= parseFloat(n)\r\n    }\r\n  });\r\n  $(\"#sum-result\").html(\"<br />合計: \" + sum + \"<br />総積: \" + prod)\r\n});\r\n\r\nfunction monthly_rate(s, n) {\r\n   return (s * Math.pow(1+s, n))/(Math.pow(1+s, n) - 1)\r\n}\r\n\r\n\r\nMathJax = {\r\n  chtml: {\r\n    matchFontHeight: false\r\n  },\r\n  tex: {\r\n    inlineMath: [[\'$\', \'$\']]\r\n  }\r\n};','.flex{\r\n  display: flex;\r\n  border-bottom: solid 1px;\r\n  padding-bottom: 10px;\r\n  flex-wrap: wrap;\r\n}\r\n\r\n.flex .right, .flex .left{\r\n  width: 50%;\r\n}\r\n\r\nlabel{\r\n  width: 150px;\r\n}\r\n\r\n.input{\r\n  border-bottom: solid 1px #999;\r\n  width: 400px;\r\n  margin-bottom: 10px;\r\n}\r\n\r\n.calc-btn{\r\n  text-align: right;\r\n  width: 400px;\r\n}','','',1,NULL,'','','','2022-09-07 08:44:12','2022-09-07 08:44:30'),(2,'いろいろな計算',2,0,'<head>\r\n<script id=\"MathJax-script\" async\r\n  src=\"https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js\">\r\n</script>\r\n</head>\r\n\r\n<div class=\"container\">\r\n<h2>ローンの計算</h2>\r\n<p>\r\n  m: 毎月返済額、k: 借入金、n: 支払い回数, s: 利率(月), h: 頭金とすると<br />\r\n\\[\r\n  m = \\frac{s(k - h)(1 + s)^n}{(1+s)^n - 1}\r\n\\]\r\nここで、\r\n\\[\r\n  a = \\frac{s(1 + s)^n}{(1+s)^n - 1}\r\n\\]\r\n  のようにおくと、上の式は\r\n\\[\r\n  m = a(k-h)\r\n\\]\r\n  と書くことができるので、このaを月額率と呼ぶ<br />\r\n  トータルの払い込みは$mn+h = an(k-h)+h$と書くことができる<br />\r\n  利息分は$nm-k$\r\n</p>\r\n<h3>月額率表</h3>\r\n\r\n\r\n<a class=\"btn btn-primary mb-3\" data-toggle=\"collapse\" href=\"#collapseExample\" role=\"button\" aria-expanded=\"false\" aria-controls=\"collapseExample\">\r\n    テーブルを表示\r\n</a>\r\n\r\n<table class=\"table collapse\" id=\"collapseExample\">\r\n  \r\n    <tr><td>年数\\利率(年)</td><td>0.12%</td><td>0.24%</td><td>1.2%</td><td>3.6%</td><td>6.0%</td><td>12%</td><td>18.0%</td></tr>\r\n  \r\n    <tr><td>1(12回)</td><td>0.083(1.001)</td><td>0.083(1.001)</td><td>0.084(1.007)</td><td>0.085(1.02)</td><td>0.086(1.033)</td><td>0.089(1.066)</td><td>0.092(1.1)</td></tr>\r\n  \r\n    <tr><td>2(24回)</td><td>0.042(1.001)</td><td>0.042(1.003)</td><td>0.042(1.013)</td><td>0.043(1.038)</td><td>0.044(1.064)</td><td>0.047(1.13)</td><td>0.05(1.198)</td></tr>\r\n  \r\n    <tr><td>3(36回)</td><td>0.028(1.002)</td><td>0.028(1.004)</td><td>0.028(1.019)</td><td>0.029(1.056)</td><td>0.03(1.095)</td><td>0.033(1.196)</td><td>0.036(1.301)</td></tr>\r\n  \r\n    <tr><td>4(48回)</td><td>0.021(1.002)</td><td>0.021(1.005)</td><td>0.021(1.025)</td><td>0.022(1.075)</td><td>0.023(1.127)</td><td>0.026(1.264)</td><td>0.029(1.41)</td></tr>\r\n  \r\n    <tr><td>5(60回)</td><td>0.017(1.003)</td><td>0.017(1.006)</td><td>0.017(1.031)</td><td>0.018(1.094)</td><td>0.019(1.16)</td><td>0.022(1.335)</td><td>0.025(1.524)</td></tr>\r\n  \r\n    <tr><td>6(72回)</td><td>0.014(1.004)</td><td>0.014(1.007)</td><td>0.014(1.037)</td><td>0.015(1.113)</td><td>0.017(1.193)</td><td>0.02(1.408)</td><td>0.023(1.642)</td></tr>\r\n  \r\n    <tr><td>7(84回)</td><td>0.012(1.004)</td><td>0.012(1.009)</td><td>0.012(1.043)</td><td>0.013(1.133)</td><td>0.015(1.227)</td><td>0.018(1.483)</td><td>0.021(1.765)</td></tr>\r\n  \r\n    <tr><td>8(96回)</td><td>0.01(1.005)</td><td>0.011(1.01)</td><td>0.011(1.049)</td><td>0.012(1.152)</td><td>0.013(1.262)</td><td>0.016(1.56)</td><td>0.02(1.893)</td></tr>\r\n  \r\n    <tr><td>9(108回)</td><td>0.009(1.005)</td><td>0.009(1.011)</td><td>0.01(1.055)</td><td>0.011(1.172)</td><td>0.012(1.297)</td><td>0.015(1.64)</td><td>0.019(2.026)</td></tr>\r\n  \r\n    <tr><td>10(120回)</td><td>0.008(1.006)</td><td>0.008(1.012)</td><td>0.009(1.062)</td><td>0.01(1.192)</td><td>0.011(1.332)</td><td>0.014(1.722)</td><td>0.018(2.162)</td></tr>\r\n  \r\n    <tr><td>11(132回)</td><td>0.008(1.007)</td><td>0.008(1.013)</td><td>0.008(1.068)</td><td>0.009(1.213)</td><td>0.01(1.368)</td><td>0.014(1.805)</td><td>0.017(2.303)</td></tr>\r\n  \r\n    <tr><td>12(144回)</td><td>0.007(1.007)</td><td>0.007(1.015)</td><td>0.007(1.074)</td><td>0.009(1.233)</td><td>0.01(1.405)</td><td>0.013(1.891)</td><td>0.017(2.447)</td></tr>\r\n  \r\n    <tr><td>13(156回)</td><td>0.006(1.008)</td><td>0.007(1.016)</td><td>0.007(1.081)</td><td>0.008(1.254)</td><td>0.009(1.443)</td><td>0.013(1.979)</td><td>0.017(2.594)</td></tr>\r\n  \r\n    <tr><td>14(168回)</td><td>0.006(1.008)</td><td>0.006(1.017)</td><td>0.006(1.087)</td><td>0.008(1.275)</td><td>0.009(1.48)</td><td>0.012(2.069)</td><td>0.016(2.745)</td></tr>\r\n  \r\n    <tr><td>15(180回)</td><td>0.006(1.009)</td><td>0.006(1.018)</td><td>0.006(1.093)</td><td>0.007(1.296)</td><td>0.008(1.519)</td><td>0.012(2.16)</td><td>0.016(2.899)</td></tr>\r\n  \r\n    <tr><td>16(192回)</td><td>0.005(1.01)</td><td>0.005(1.019)</td><td>0.006(1.1)</td><td>0.007(1.317)</td><td>0.008(1.558)</td><td>0.012(2.254)</td><td>0.016(3.055)</td></tr>\r\n  \r\n    <tr><td>17(204回)</td><td>0.005(1.01)</td><td>0.005(1.021)</td><td>0.005(1.106)</td><td>0.007(1.338)</td><td>0.008(1.598)</td><td>0.012(2.348)</td><td>0.016(3.214)</td></tr>\r\n  \r\n    <tr><td>18(216回)</td><td>0.005(1.011)</td><td>0.005(1.022)</td><td>0.005(1.112)</td><td>0.006(1.36)</td><td>0.008(1.638)</td><td>0.011(2.445)</td><td>0.016(3.375)</td></tr>\r\n  \r\n    <tr><td>19(228回)</td><td>0.004(1.011)</td><td>0.004(1.023)</td><td>0.005(1.119)</td><td>0.006(1.382)</td><td>0.007(1.678)</td><td>0.011(2.543)</td><td>0.016(3.539)</td></tr>\r\n  \r\n    <tr><td>20(240回)</td><td>0.004(1.012)</td><td>0.004(1.024)</td><td>0.005(1.125)</td><td>0.006(1.404)</td><td>0.007(1.719)</td><td>0.011(2.643)</td><td>0.015(3.704)</td></tr>\r\n  \r\n    <tr><td>21(252回)</td><td>0.004(1.013)</td><td>0.004(1.026)</td><td>0.004(1.132)</td><td>0.006(1.427)</td><td>0.007(1.761)</td><td>0.011(2.744)</td><td>0.015(3.871)</td></tr>\r\n  \r\n    <tr><td>22(264回)</td><td>0.004(1.013)</td><td>0.004(1.027)</td><td>0.004(1.138)</td><td>0.005(1.449)</td><td>0.007(1.803)</td><td>0.011(2.846)</td><td>0.015(4.039)</td></tr>\r\n  \r\n    <tr><td>23(276回)</td><td>0.004(1.014)</td><td>0.004(1.028)</td><td>0.004(1.145)</td><td>0.005(1.472)</td><td>0.007(1.846)</td><td>0.011(2.949)</td><td>0.015(4.209)</td></tr>\r\n  \r\n    <tr><td>24(288回)</td><td>0.004(1.015)</td><td>0.004(1.029)</td><td>0.004(1.151)</td><td>0.005(1.495)</td><td>0.007(1.889)</td><td>0.011(3.054)</td><td>0.015(4.38)</td></tr>\r\n  \r\n    <tr><td>25(300回)</td><td>0.003(1.015)</td><td>0.003(1.03)</td><td>0.004(1.158)</td><td>0.005(1.518)</td><td>0.006(1.933)</td><td>0.011(3.16)</td><td>0.015(4.552)</td></tr>\r\n  \r\n    <tr><td>26(312回)</td><td>0.003(1.016)</td><td>0.003(1.032)</td><td>0.004(1.165)</td><td>0.005(1.541)</td><td>0.006(1.977)</td><td>0.01(3.266)</td><td>0.015(4.725)</td></tr>\r\n  \r\n    <tr><td>27(324回)</td><td>0.003(1.016)</td><td>0.003(1.033)</td><td>0.004(1.171)</td><td>0.005(1.565)</td><td>0.006(2.022)</td><td>0.01(3.374)</td><td>0.015(4.899)</td></tr>\r\n  \r\n    <tr><td>28(336回)</td><td>0.003(1.017)</td><td>0.003(1.034)</td><td>0.004(1.178)</td><td>0.005(1.589)</td><td>0.006(2.067)</td><td>0.01(3.483)</td><td>0.015(5.074)</td></tr>\r\n  \r\n    <tr><td>29(348回)</td><td>0.003(1.018)</td><td>0.003(1.035)</td><td>0.003(1.185)</td><td>0.005(1.613)</td><td>0.006(2.112)</td><td>0.01(3.593)</td><td>0.015(5.25)</td></tr>\r\n  \r\n    <tr><td>30(360回)</td><td>0.003(1.018)</td><td>0.003(1.037)</td><td>0.003(1.191)</td><td>0.005(1.637)</td><td>0.006(2.158)</td><td>0.01(3.703)</td><td>0.015(5.426)</td></tr>\r\n  \r\n    <tr><td>31(372回)</td><td>0.003(1.019)</td><td>0.003(1.038)</td><td>0.003(1.198)</td><td>0.004(1.661)</td><td>0.006(2.205)</td><td>0.01(3.814)</td><td>0.015(5.602)</td></tr>\r\n  \r\n    <tr><td>32(384回)</td><td>0.003(1.019)</td><td>0.003(1.039)</td><td>0.003(1.205)</td><td>0.004(1.686)</td><td>0.006(2.252)</td><td>0.01(3.926)</td><td>0.015(5.779)</td></tr>\r\n  \r\n    <tr><td>33(396回)</td><td>0.003(1.02)</td><td>0.003(1.04)</td><td>0.003(1.212)</td><td>0.004(1.71)</td><td>0.006(2.299)</td><td>0.01(4.039)</td><td>0.015(5.956)</td></tr>\r\n  \r\n    <tr><td>34(408回)</td><td>0.003(1.021)</td><td>0.003(1.041)</td><td>0.003(1.218)</td><td>0.004(1.735)</td><td>0.006(2.347)</td><td>0.01(4.152)</td><td>0.015(6.134)</td></tr>\r\n  \r\n    <tr><td>35(420回)</td><td>0.002(1.021)</td><td>0.002(1.043)</td><td>0.003(1.225)</td><td>0.004(1.76)</td><td>0.006(2.395)</td><td>0.01(4.265)</td><td>0.015(6.312)</td></tr>\r\n  \r\n    <tr><td>36(432回)</td><td>0.002(1.022)</td><td>0.002(1.044)</td><td>0.003(1.232)</td><td>0.004(1.786)</td><td>0.006(2.443)</td><td>0.01(4.38)</td><td>0.015(6.49)</td></tr>\r\n  \r\n    <tr><td>37(444回)</td><td>0.002(1.022)</td><td>0.002(1.045)</td><td>0.003(1.239)</td><td>0.004(1.811)</td><td>0.006(2.492)</td><td>0.01(4.494)</td><td>0.015(6.669)</td></tr>\r\n  \r\n    <tr><td>38(456回)</td><td>0.002(1.023)</td><td>0.002(1.046)</td><td>0.003(1.246)</td><td>0.004(1.837)</td><td>0.006(2.541)</td><td>0.01(4.609)</td><td>0.015(6.848)</td></tr>\r\n  \r\n    <tr><td>39(468回)</td><td>0.002(1.024)</td><td>0.002(1.048)</td><td>0.003(1.253)</td><td>0.004(1.862)</td><td>0.006(2.591)</td><td>0.01(4.725)</td><td>0.015(7.027)</td></tr>\r\n  \r\n    <tr><td>40(480回)</td><td>0.002(1.024)</td><td>0.002(1.049)</td><td>0.003(1.26)</td><td>0.004(1.888)</td><td>0.006(2.641)</td><td>0.01(4.841)</td><td>0.015(7.206)</td></tr>\r\n  \r\n</table>\r\n\r\n\r\n\r\n<div id=\"loan\" class=\"flex\">\r\n  <div class=\"left\">\r\n    <div class=\"input\">\r\n      <label>返済年数[必須]</label>\r\n      <input type=\"text\" id=\"loan-n\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>年利率(%)[必須]</label> <input type=\"text\" id=\"loan-r\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>借入金(万円)</label> <input type=\"text\" id=\"loan-k\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>頭金</label> <input type=\"text\" id=\"loan-h\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>毎月返済額</label> <input type=\"text\" id=\"loan-m\">\r\n    </div>\r\n    <small>借入金か返済額のいずれかを入力して計算ボタンをおす</small>\r\n    <div class=\"calc-btn\">\r\n      <button id=\"calc-loan\" type=\"button\" class=\"btn btn-primary\">計算</button>\r\n    </div>\r\n  </div>\r\n  <div class=\"right\">\r\n    result: <span id=\"loan-result\"></span>\r\n  </div>\r\n</div>\r\n\r\n<h2>投資計算</h2>\r\n<div id=\"investment\" class=\"flex\">\r\n  <div class=\"left\">\r\n    <div class=\"input\">\r\n      <label>利率(%)</label> <input type=\"text\" id=\"investment-r\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>回数</label> <input type=\"text\" id=\"investment-n\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>頭金</label> <input type=\"text\" id=\"investment-a\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>加算</label> <input type=\"text\" id=\"investment-b\">\r\n    </div>\r\n    <div class=\"calc-btn\">\r\n      <button id=\"calc-investment\" type=\"button\" class=\"btn btn-primary\">計算</button>\r\n    </div>\r\n  </div>\r\n  <div class=\"right\">\r\n    result: <span id=\"result-investment\"></span>\r\n  </div>\r\n</div>\r\n\r\n<h2>単利複利計算</h2>\r\n<div id=\"rate\" class=\"flex\">\r\n  <div class=\"left\">\r\n    <div class=\"input\">\r\n      <label>利率(%)</label> <input type=\"text\" id=\"rate-r\">\r\n    </div>\r\n    <div class=\"input\">\r\n      <label>回数</label> <input type=\"text\" id=\"rate-n\">\r\n    </div>\r\n    <div class=\"calc-btn\">\r\n      <button id=\"calc-rate\" type=\"button\" class=\"btn btn-primary\">計算</button>\r\n    </div>\r\n  </div>\r\n  <div class=\"right\">\r\n    result: <span id=\"rate-result\"></span>\r\n  </div>\r\n</div>\r\n\r\n<h2>和積計算</h2>\r\n<div id=\"rate\" class=\"flex\">\r\n  <div class=\"left\">\r\n    <div class=\"\">\r\n      <label>数値</label>\r\n    </div>\r\n    <div class=\"input\">\r\n      <textarea type=\"text\" id=\"sum-n\" placeholder=\"12 34 56\" style=\"width: 100%\" rows=5></textarea>\r\n    </div>\r\n    <div class=\"calc-btn\">\r\n      <button id=\"calc-sum\" type=\"button\" class=\"btn btn-primary\">計算</button>\r\n    </div>\r\n  </div>\r\n  <div class=\"right\">\r\n    result: <span id=\"sum-result\"></span>\r\n  </div>\r\n</div>\r\n\r\n</div>','$(\"#calc-loan\").on(\'click\', function(){\r\n  const n = parseInt($(\"#loan-n\").val()) * 12\r\n  const s = parseFloat($(\"#loan-r\").val())/1200\r\n  const k = parseFloat($(\"#loan-k\").val())\r\n  let h = parseFloat($(\"#loan-h\").val())\r\n  const m = parseFloat($(\"#loan-m\").val())\r\n  let a = monthly_rate(s, n) // 月額率\r\n  if(isNaN(h)){ // 頭金がない場合は0\r\n    h = 0.0\r\n  }\r\n  if(isNaN(k)){ // 借入金がない場合は借入金を計算\r\n    result_k = m / a\r\n    $(\"#loan-result\").text(\"借入金額は\" + result_k)\r\n  }else if(isNaN(m)){// 毎月返済額がない場合は借入金を計算\r\n    result_m = (k - h) * a\r\n    total = result_m * n + h\r\n    $(\"#loan-result\").html(\"<br>毎月返済額は\" + result_m + \"。<br>総支払額は\"+ total)\r\n  }\r\n});\r\n\r\n$(\"#calc-investment\").on(\'click\', function(){\r\n  const n = parseInt($(\"#investment-n\").val())\r\n  const r = 1 + parseFloat($(\"#investment-r\").val())/100\r\n  const a = parseFloat($(\"#investment-a\").val())\r\n  const b = parseFloat($(\"#investment-b\").val())\r\n  const rn = Math.pow(r, n)\r\n  const result = rn * a + ((rn - 1)/(r-1))*b\r\n  $(\"#result-investment\").html(\"<br />最終金額: \" + result + \"<br />投資総額: \" + (a + b * n) + \"<br />儲け: \" + (result - (a + b * n))  + \"<br />倍率(最終金額/投資総額): \" + (result / (a + b * n)))\r\n});\r\n\r\n\r\n$(\"#calc-rate\").on(\'click\', function(){\r\n  const n = parseInt($(\"#rate-n\").val())\r\n  const r = parseFloat($(\"#rate-r\").val())/100\r\n  $(\"#rate-result\").html(\"<br />単利: \" + (1 + n * r) + \"<br />複利: \" + Math.pow(1+r, n) )\r\n});\r\n\r\n$(\"#calc-sum\").on(\'click\', function(){\r\n  const nums = $(\"#sum-n\").val().split(\' \')\r\n  sum = 0\r\n  prod = 1\r\n  nums.forEach(n => {\r\n    if(n !== \'\'){\r\n      sum += parseFloat(n)\r\n      prod *= parseFloat(n)\r\n    }\r\n  });\r\n  $(\"#sum-result\").html(\"<br />合計: \" + sum + \"<br />総積: \" + prod)\r\n});\r\n\r\nfunction monthly_rate(s, n) {\r\n   return (s * Math.pow(1+s, n))/(Math.pow(1+s, n) - 1)\r\n}\r\n\r\n\r\nMathJax = {\r\n  chtml: {\r\n    matchFontHeight: false\r\n  },\r\n  tex: {\r\n    inlineMath: [[\'$\', \'$\']]\r\n  }\r\n};','.flex{\r\n  display: flex;\r\n  border-bottom: solid 1px;\r\n  padding-bottom: 10px;\r\n  flex-wrap: wrap;\r\n}\r\n\r\n.flex .right, .flex .left{\r\n  width: 50%;\r\n}\r\n\r\nlabel{\r\n  width: 150px;\r\n}\r\n\r\n.input{\r\n  border-bottom: solid 1px #999;\r\n  width: 400px;\r\n  margin-bottom: 10px;\r\n}\r\n\r\n.calc-btn{\r\n  text-align: right;\r\n  width: 400px;\r\n}','ローンの計算などなど','',1,2,'','','','2022-09-07 12:57:25','2023-06-07 04:50:29'),(3,'お絵描き',2,1,'\r\n<head>\r\n  <script src=\"https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.6.1/p5.min.js\"></script>\r\n</head>\r\n<div class=\"body\">\r\n  <div class=\"\">\r\n    <div class=\"row g-3 align-items-center m-1\">\r\n      <div class=\"col-auto\">\r\n        <button id=\"pen\" class=\"btn btn-primary\"><i class=\"bi bi-pencil\"></i></button>\r\n      </div>\r\n      <div class=\"col-auto\">\r\n        <select class=\"form-select\" id=\"r\" aria-label=\"Default select example\">\r\n          <option value=\"1\">1</option>\r\n          <option value=\"2\" selected>2</option>\r\n          <option value=\"3\">3</option>\r\n          <option value=\"4\">4</option>\r\n          <option value=\"5\">5</option>\r\n          <option value=\"6\">6</option>\r\n          <option value=\"7\">7</option>\r\n          <option value=\"8\">8</option>\r\n          <option value=\"9\">9</option>\r\n          <option value=\"10\">10</option>\r\n          <option value=\"15\">15</option>\r\n          <option value=\"20\">20</option>\r\n          <option value=\"30\">30</option>\r\n          <option value=\"50\">50</option>\r\n        </select>\r\n      </div>\r\n      <div class=\"col-auto\">\r\n        <input type=\"color\" id=\"color\" name=\"head\">\r\n      </div>\r\n      <div class=\"col-auto\">\r\n        <select class=\"form-select\" id=\"type\" aria-label=\"Default select example\">\r\n          <option value=\"pen\" selected>ペン</option>\r\n          <option value=\"line\">直線</option>\r\n          <option value=\"brush\">ブラシ</option>\r\n        </select>\r\n      </div>\r\n    </div>\r\n    <div class=\"row g-3 align-items-center m-1\">\r\n      <div class=\"col-auto\">\r\n        <button id=\"all\" class=\"btn btn-success\">\r\n          <i class=\"bi bi-paint-bucket\"></i>\r\n        </button>\r\n      </div>\r\n      <div class=\"col-auto\">\r\n        <input type=\"color\" id=\"back\">\r\n      </div>\r\n    </div>\r\n    <div class=\"row g-3 align-items-center m-1\">\r\n      <div class=\"col-auto\">\r\n        <button id=\"erase\" class=\"btn btn-warning\"><i class=\"bi bi-eraser\"></i></button>\r\n      </div>\r\n    </div>\r\n\r\n    <hr>\r\n    <div class=\"row g-3 align-items-center m-1\">\r\n      <div class=\"col-auto\">\r\n        <select class=\"form-select\" id=\"w\" aria-label=\"Default select example\">\r\n          <option value=\"100\">w:100</option>\r\n          <option value=\"200\">w:200</option>\r\n          <option value=\"300\">w:300</option>\r\n          <option value=\"400\">w:400</option>\r\n          <option value=\"500\">w:500</option>\r\n          <option value=\"600\">w:600</option>\r\n          <option value=\"700\">w:700</option>\r\n          <option value=\"800\">w:800</option>\r\n          <option value=\"900\">w:900</option>\r\n          <option value=\"1000\">w:1000</option>\r\n          <option value=\"1100\">w:1100</option>\r\n          <option value=\"1200\">w:1200</option>\r\n          <option value=\"1300\" selected>w:1300</option>\r\n          <option value=\"1400\">w:1400</option>\r\n          <option value=\"1500\">w:1500</option>\r\n        </select>\r\n      </div>\r\n      <div class=\"col-auto\">\r\n        <select class=\"form-select\" id=\"h\" aria-label=\"Default select example\">\r\n          <option value=\"100\">h:100</option>\r\n          <option value=\"200\">h:200</option>\r\n          <option value=\"300\">h:300</option>\r\n          <option value=\"400\">h:400</option>\r\n          <option value=\"500\">h:500</option>\r\n          <option value=\"600\">h:600</option>\r\n          <option value=\"700\">h:700</option>\r\n          <option value=\"800\" selected>h:800</option>\r\n          <option value=\"900\">h:900</option>\r\n          <option value=\"1000\">h:1000</option>\r\n          <option value=\"1100\">h:1100</option>\r\n          <option value=\"1200\">h:1200</option>\r\n          <option value=\"1300\">h:1300</option>\r\n          <option value=\"1400\">h:1400</option>\r\n          <option value=\"1500\">h:1500</option>\r\n          <option value=\"1600\">h:1600</option>\r\n          <option value=\"1700\">h:1700</option>\r\n        </select>\r\n      </div>\r\n      <div class=\"col-auto\">\r\n        <button id=\"resize\" class=\"btn btn-info\">\r\n          <i class=\"bi bi-textarea-resize\"></i>\r\n        </button>\r\n      </div>\r\n    </div>\r\n    <div class=\"row g-3 align-items-center m-1\">\r\n      <div class=\"col-auto\">\r\n        <button id=\"save\" class=\"btn btn-info\">\r\n          <i class=\"bi bi-download\"></i>\r\n        </button>\r\n      </div>\r\n    </div>\r\n    <hr>\r\n    <div class=\"row g-3 align-items-center m-1\">\r\n      <div class=\"col-auto\">\r\n        <button id=\"delete\" class=\"btn btn-danger\">\r\n          <i class=\"bi bi-trash3-fill\"></i>\r\n        </button>\r\n      </div>\r\n    </div>\r\n  </div>\r\n<div id=\"mycanvas\"></div>\r\n</div>\r\n','var w = $(\"#w\").val();\r\nvar h = $(\"#h\").val();\r\nvar prevX = null;\r\nvar prevY = null;\r\nvar time = 0;\r\nvar pressedTime = 0;\r\nvar penr = 2;\r\nvar color = \"#000000\";\r\nvar back = \"#ffffff\";\r\nvar mode = $(\"#type\").val();\r\nvar line_first = [];\r\nfunction setup() {\r\n  let canvas = createCanvas(w, h);\r\n  canvas.parent( \'mycanvas\' );\r\n  fill(255,255,255)\r\n  stroke(0,0,0)\r\n  clearCanvas();\r\n  strokeWeight(penr);\r\n}\r\n\r\nfunction draw() {\r\n  if(mouseX > 0 && mouseY > 0 && mouseX < w && mouseY < h){\r\n    if(mode === \"pen\"){\r\n      if(mouseIsPressed === true){\r\n        if(prevX === null || prevY === null || (time - pressedTime) > 10){\r\n          ellipse(mouseX, mouseY, penr);\r\n        }else{\r\n          line(prevX, prevY, mouseX, mouseY);\r\n        }\r\n        prevX = mouseX;\r\n        prevY = mouseY;\r\n        pressedTime = time;\r\n      }\r\n    }else if(mode === \"line\"){\r\n      if((time - pressedTime) > 10 && mouseIsPressed === true){\r\n        if(line_first.length === 0){\r\n          ellipse(mouseX, mouseY, penr);\r\n          line_first = [mouseX, mouseY]\r\n        }else{\r\n          //push()\r\n          //fill(color)\r\n          line(line_first[0], line_first[1], mouseX, mouseY)\r\n          //pop()\r\n          line_first = []\r\n        }\r\n        pressedTime = time;\r\n      }\r\n    }else if(mode === \"brush\"){\r\n      if(mouseIsPressed === true){\r\n        for(let i = 0; i< 30; i++){\r\n          var randx = rnorm() * penr\r\n          var randy = rnorm() * penr\r\n          push()\r\n          strokeWeight(1)\r\n          ellipse(mouseX + randx, mouseY + randy, 1);\r\n          pop()\r\n        }\r\n      }\r\n    }\r\n    time++;\r\n  }\r\n}\r\n\r\nfunction mouseReleased(){\r\n  prevX = null\r\n  prevY = null\r\n}\r\n\r\nfunction clearCanvas(){\r\n  background(255);\r\n  stroke(0,0,0);\r\n}\r\nfunction saveImg(fname){\r\n  saveCanvas(fname, \'jpg\');\r\n}\r\n\r\nfunction resize(a, b){\r\n  w = a\r\n  h = b\r\n  resizeCanvas(w, h);\r\n  clearCanvas();\r\n}\r\n\r\nfunction rnorm(){\r\n  return Math.sqrt(-2 * Math.log(1 - Math.random())) * Math.cos(2 * Math.PI * Math.random());\r\n}\r\n\r\n$(document).ready(function(){\r\n  $(\"#delete\").on(\'click\', function(){\r\n    clearCanvas();\r\n  })\r\n\r\n  $(\"#all\").on(\'click\', function(){\r\n    rect(0,0,w,h);\r\n  })\r\n\r\n  $(\"#resize\").on(\'click\', function(){\r\n    const inputW = $(\"#w\").val()\r\n    const inputH = $(\"#h\").val()\r\n    if(inputW.length !== 0 && inputH.length !== 0){\r\n      resize(inputW, inputH)\r\n    }\r\n  })\r\n\r\n  $(\"#save\").on(\'click\', function(){\r\n      var now = new Date();\r\n      var year = now.getFullYear();\r\n      var month = now.getMonth()+1;\r\n      var date = now.getDate();\r\n      var hour = now.getHours();\r\n      var min = now.getMinutes();\r\n      file = year + \"-\" + month + \"-\" + date + \"-\" + hour + \"-\" + min\r\n      saveCanvas(file, \'jpg\');\r\n  })\r\n  \r\n  $(\"#type\").on(\'change\', function(){\r\n    mode = $(\"#type\").val();\r\n  })\r\n\r\n  $(\"#r\").on(\'change\', function(){\r\n    penr = $(\"#r\").val()\r\n    strokeWeight($(\"#r\").val());\r\n  })\r\n\r\n  $(\"#color\").on(\'change\', function(){\r\n    color = $(\"#color\").val();\r\n    stroke(color)\r\n  })\r\n  $(\"#back\").on(\'change\', function(){\r\n    back = $(\"#back\").val()\r\n    fill(back)\r\n  })\r\n\r\n  $(\"#pen\").on(\'click\', function(){\r\n    stroke(color);\r\n    $(\"#r\").val(2)\r\n    strokeWeight(2);\r\n  })\r\n\r\n  $(\"#erase\").on(\'click\', function(){\r\n    stroke(back);\r\n    strokeWeight(10);\r\n    $(\"#r\").val(8)\r\n  })\r\n});','.body {\r\n  padding: 5px;\r\n  padding-left: 30px;\r\n  margin: 0;\r\n  display: flex;\r\n}\r\ncanvas{\r\n  margin-top: 5px;\r\n  margin-left: 30px;\r\n  border: solid 1px;\r\n}\r\n.flex{\r\n  display: flex;\r\n}\r\n.col-auto{\r\n  padding-left: 0px;\r\n}','お絵描きアプリ','',1,1,'','','','2022-09-09 08:46:47','2022-10-05 10:52:28'),(4,'開発TODO',2,0,'<div class=\'container\' style=\"width: 100%\">\n  <div class=\'jumbotron\'>\n    <h1>開発TODO</h1>\n  </div>\n  <div class=\'col-xs-3\' id=\'side_menu\'>\n    <ul>\n      <li><a href=\'#h-0\'>やること</a></li>\n      <ul>\n        <li><a href=\'#h-1\'></a></li>\n        <li><a href=\'#h-2\'></a></li>\n        <li><a href=\'#h-3\'></a></li>\n        <li><a href=\'#h-4\'></a></li>\n        <li><a href=\'#h-5\'></a></li>\n        <li><a href=\'#h-6\'></a></li>\n        <li><a href=\'#h-7\'></a></li>\n      </ul>\n    </ul>\n  </div>\n  <div class=\'col-xs-8\'>\n    <h1 id=\'h-0\'>やること</h1>\n    <h2 id=\'h-1\'></h2> -> css非反映ボタン(cssが自動反映されてしまうと、編集できなくなる場合があるため)\n    <h2 id=\'h-2\'></h2> -> yaml生成がちょっとおかしいので修正\n    <h2 id=\'h-3\'></h2> -> 有用なcss,jsを作る。例えば外部ライブラリをインポートするとか\n    <h2 id=\'h-4\'></h2> -> データをカンマ区切りで入力するとグラフで表示してくれる\n    <h2 id=\'h-5\'></h2> -> localStrageを利用した簡単なメモアプリ\n    <h2 id=\'h-6\'></h2> -> コピー\n    <h2 id=\'h-7\'></h2> -> vue.jsを使ったページ\n  </div>\n  <div class=\'col-xs-1\'></div>\n</div>\n','','','やることリスト','やること:\r\n  - css非反映ボタン(cssが自動反映されてしまうと、編集できなくなる場合があるため)\r\n  - yaml生成がちょっとおかしいので修正\r\n  - 有用なcss,jsを作る。例えば外部ライブラリをインポートするとか\r\n  - データをカンマ区切りで入力するとグラフで表示してくれる\r\n  - localStrageを利用した簡単なメモアプリ\r\n  - コピー\r\n  - vue.jsを使ったページ',1,1,'','','','2022-09-09 09:54:16','2022-09-11 22:51:14'),(5,'import Math ',2,0,'<div>\r\n\r\n\\[\r\n  m = \\frac{s(k - h)(1 + s)^n}{(1+s)^n - 1}\r\n\\]\r\n\r\n</div>','import * from \'https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js\';\r\n\r\nMathJax = {\r\n  chtml: {\r\n    matchFontHeight: false\r\n  },\r\n  tex: {\r\n    inlineMath: [[\'$\', \'$\']]\r\n  }\r\n};','','','',1,2,'Texを導入する','','','2022-09-09 10:00:16','2022-09-09 10:02:59'),(6,'図からcsvを作成する',2,1,'\r\n<head>\r\n  <script src=\"https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.6.1/p5.min.js\"></script>\r\n</head>\r\n\r\n<div class=\"body\">\r\n  <div>\r\n    <div class=\"row g-3 align-items-center m-1\">\r\n      <div class=\"col-auto\">\r\n        minX <input type=\"text\" id=\"minX\" class=\"form-control\" value=0>\r\n        maxX<input type=\"text\" id=\"maxX\" class=\"form-control\" value=100>\r\n        minY<input type=\"text\" id=\"minY\" class=\"form-control\" value=0>\r\n        maxY<input type=\"text\" id=\"maxY\" class=\"form-control\" value=100>\r\n      </div>\r\n    </div>\r\n    <div class=\"row g-3 align-items-center m-1\">\r\n      <div class=\"col-auto\">\r\n        <button id=\"csv\" class=\"btn btn-success\">\r\n          csv\r\n        </button>\r\n      </div>\r\n    </div>\r\n    <div class=\"row g-3 align-items-center m-1\">\r\n      <div class=\"col-auto\">\r\n        <button id=\"delete\" class=\"btn btn-danger\">\r\n          クリア\r\n        </button>\r\n      </div>\r\n    </div>\r\n  </div>\r\n<div id=\"mycanvas\"></div>\r\n</div>','var w = 1000\r\nvar h = 600\r\nvar prevX = null;\r\nvar prevY = null;\r\nvar time = 0;\r\nvar pressedTime = 0;\r\nvar maxY = 100, minY = 0;\r\nvar maxX = 100, minX = 0;\r\nvar lines = []\r\nfunction setup() {\r\n  let canvas = createCanvas(w, h);\r\n  canvas.parent( \'mycanvas\' );\r\n  fill(255,255,255)\r\n  stroke(0,0,0)\r\n  clearCanvas();\r\n  for (let i = 0; i < 1000-50; ++i){\r\n    lines.push(0)\r\n  }\r\n}\r\n\r\nfunction draw() {\r\n  if(mouseX > 0 && mouseY > 0 && mouseX < w && mouseY < h){\r\n    if(mouseIsPressed === true){\r\n      if(prevX === null || prevY === null || (time - pressedTime) > 10){\r\n        ellipse(mouseX, mouseY, 1);\r\n        if(mouseX >= 50){\r\n          lines[parseInt(mouseX - 50)] = 550 - mouseY\r\n        }\r\n      }else{\r\n        x1 = prevX\r\n        y1 = 550 - prevY\r\n        x2 = mouseX\r\n        y2 = 550 - mouseY\r\n        a = (y2 - y1) / (x2 - x1)\r\n        b = y1 - a * x1\r\n        for (let i = parseInt(x1); i < x2; ++i){\r\n          console.log(i)\r\n          if(i >= 50){\r\n            lines[i - 50] = i * a + b\r\n          }\r\n        }\r\n        line(prevX, prevY, mouseX, mouseY);\r\n      }\r\n      prevX = mouseX;\r\n      prevY = mouseY;\r\n      pressedTime = time;\r\n    }\r\n    time++;\r\n  }\r\n}\r\n\r\nfunction mouseReleased(){\r\n  prevX = null\r\n  prevY = null\r\n}\r\n\r\nfunction clearCanvas(){\r\n  background(255);\r\n  stroke(0,0,0);\r\n  drawAxis()\r\n}\r\n\r\nfunction drawAxis(){\r\n  line(50, 0, 50, 560)\r\n  line(40, 550, 1000, 550)\r\n}\r\n\r\nfunction createCSV(){\r\n  minX = $(\"#minX\").val()\r\n  maxX = $(\"#maxX\").val()\r\n  minY = $(\"#minY\").val()\r\n  maxY = $(\"#maxY\").val()\r\n  rx = (maxX - minX)/950\r\n  ry = (maxY - minY)/550\r\n  str = \"\"\r\n  for (let i = 0; i < 1000-50; ++i){\r\n    str += (i * rx + minX) + \",\" + (lines[i] * ry + minY) +\"\\n\";\r\n  }\r\n  \r\n  var blob =new Blob([str],{type:\"text/csv\"}); //配列に上記の文字列(str)を設定\r\n  var link =document.createElement(\'a\');\r\n  link.href = URL.createObjectURL(blob);\r\n  link.download =\"tempdate.csv\";\r\n  link.target =\'_blank\';\r\n  link.click();\r\n}\r\n\r\n\r\n$(document).ready(function(){\r\n  $(\"#setAxis\").on(\'click\', function(){\r\n    minX = $(\"#minX\").val()\r\n    maxX = $(\"#maxX\").val()\r\n    minY = $(\"#minY\").val()\r\n    maxY = $(\"#maxY\").val()\r\n  })\r\n  $(\"#delete\").on(\'click\', function(){\r\n    clearCanvas();\r\n  })\r\n  $(\"#csv\").on(\'click\', function(){\r\n    createCSV();\r\n  })\r\n});','.body {\r\n  padding: 5px;\r\n  padding-left: 30px;\r\n  margin: 0;\r\n  display: flex;\r\n}\r\ncanvas{\r\n  margin-top: 5px;\r\n  margin-left: 30px;\r\n  border: solid 1px;\r\n}\r\n.flex{\r\n  display: flex;\r\n}\r\n.col-auto{\r\n  padding-left: 0px;\r\n}','','',1,2,'','','','2022-12-23 11:06:18','2022-12-23 12:19:36'),(7,'時計スケジュール',2,0,'\r\n<head>\r\n  <script src=\"https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.6.1/p5.min.js\"></script>\r\n</head>\r\n<div class=\"container\">\r\n  <div class=\"row\">\r\n    <div class=\"col-5\">\r\n      <div class=\"schedule\">\r\n        <div class=\"row\">\r\n          <div class=\"col-6\">\r\n            <div class=\"mb-3 d-flex\">\r\n              <button class=\"btn-danger mr-1\" type=\"button\">x</button>\r\n              <input type=\"text\" class=\"form-control title\" placeholder=\"内容\">\r\n            </div>\r\n          </div>\r\n          <div class=\"col-3\">\r\n            <input type=\"text\" class=\"form-control start_at\" placeholder=\"9\">\r\n          </div>\r\n          <div class=\"col-3\">\r\n            <input type=\"text\" class=\"form-control end_at\" placeholder=\"10\">\r\n          </div>\r\n        </div>\r\n      </div>\r\n    </div>\r\n    <div class=\"col-7\">\r\n      <div id=\"mycanvas\"></div>\r\n    </div>\r\n  </div>\r\n</div>\r\n\r\n<div class=\"row template\">\r\n  <div class=\"col-6\">\r\n    <div class=\"mb-3 d-flex\">\r\n      <button class=\"btn-danger mr-1\" type=\"button\">x</button>\r\n      <input type=\"text\" class=\"form-control\" id=\"exampleFormControlInput1\" placeholder=\"内容\">\r\n    </div>\r\n  </div>\r\n  <div class=\"col-3\">\r\n    <input type=\"text\" class=\"form-control\" id=\"exampleFormControlInput1\" placeholder=\"9\">\r\n  </div>\r\n  <div class=\"col-3\">\r\n    <input type=\"text\" class=\"form-control\" id=\"exampleFormControlInput1\" placeholder=\"10\">\r\n  </div>\r\n</div>','for (var i = 0; i < 12; i++) {\r\n  var $template = $(\".template\").clone();\r\n  $template.removeClass(\"template\");\r\n  $(\".schedule\").append($template);\r\n}\r\n\r\n\r\n\r\n\r\nfunction onChangeSchedule(){\r\n  // タイトルを集めて色分け\r\n  \r\n}\r\n\r\nfunction setup() {\r\n  let canvas = createCanvas(600, 600);\r\n  canvas.parent( \'mycanvas\' );\r\n  angleMode(DEGREES);\r\n  frameRate(1);\r\n}\r\n\r\nfunction draw() {\r\n  background(255);\r\n  \r\n  // 中心座標を計算\r\n  let centerX = width / 2;\r\n  let centerY = height / 2;\r\n  \r\n  // 現在の時刻を取得\r\n  let hr = hour();\r\n  let min = minute();\r\n  \r\n  // 時針の角度を計算\r\n  let hrAngle = map(hr % 12, 0, 12, 0, 360);\r\n  hrAngle += map(min, 0, 60, 0, 30); // 分針の補正\r\n  \r\n  // 分針の角度を計算\r\n  let minAngle = map(min, 0, 60, 0, 360);\r\n  \r\n  // 時計の外枠を描画\r\n  strokeWeight(3);\r\n  stroke(0);\r\n  noFill();\r\n  ellipse(centerX, centerY, 500);\r\n  \r\n  // 分針を描画\r\n  stroke(0);\r\n  strokeWeight(6);\r\n  line(centerX, centerY, centerX + cos(minAngle - 90) * 250, centerY + sin(minAngle - 90) * 250);\r\n  \r\n  // 時針を描画\r\n  stroke(0);\r\n  strokeWeight(8);\r\n  line(centerX, centerY, centerX + cos(hrAngle - 90) * 150, centerY + sin(hrAngle - 90) * 150);\r\n  \r\n  // 中心の点を描画\r\n  fill(0);\r\n  noStroke();\r\n  ellipse(centerX, centerY, 12);\r\n}\r\n','.body {\r\n  padding: 5px;\r\n  padding-left: 30px;\r\n  margin: 0;\r\n  display: flex;\r\n}\r\ncanvas{\r\n  margin-top: 5px;\r\n  margin-left: 30px;\r\n  border: solid 1px;\r\n}\r\n.flex{\r\n  display: flex;\r\n}\r\n.col-auto{\r\n  padding-left: 0px;\r\n}\r\n.template{\r\n  display: none;\r\n}','','',1,3,'','','','2023-09-06 20:49:16','2023-09-06 21:19:22');
/*!40000 ALTER TABLE `managed_htmls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20211124065408'),('20211124071244'),('20211124102231'),('20211124102438'),('20211124102519'),('20211124102639'),('20211125055825'),('20211129042713'),('20211202015435'),('20211202015452'),('20211203015216'),('20211203015226'),('20211203025054'),('20220906112614'),('20220906112639'),('20221010111611'),('20230630231944');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skills`
--

DROP TABLE IF EXISTS `skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skills` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `explanation` text,
  `category_id` int DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skills`
--

LOCK TABLES `skills` WRITE;
/*!40000 ALTER TABLE `skills` DISABLE KEYS */;
INSERT INTO `skills` VALUES (1,'柔軟UP','柔軟性が増し、怪我をしにくくなる',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(2,'移動速度','歩く速さが少し速くなる',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(3,'視野拡大','視野が拡大し、より多くのものを見る',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(4,'腕力上昇','より重いものを持つことができる',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(5,'肺活量UP','スタミナ上昇の効果が期待できる',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(6,'忍耐上昇','怪我をしても我慢することができる',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(7,'走力UP','より速く走れるようになる',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(8,'運動神経','より速くいろいろな運動がマスターできる',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(9,'脚力上昇','キックの力が強くなる',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(10,'豪腕','ものをより遠くへ投げることができる',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(11,'硬骨','骨が強くなり、折れにくくなる',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(12,'集中','集中力が増し、長い時間運動できるようになる',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(13,'ランナーズハイ','自分の限界を突破し、動くことができる',1,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(14,'抽象思考','抽象的な思考力が増し、より難しい本も読めるようになる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(15,'本質理解','文章からより多くのことを学べるようになる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(16,'記憶力向上','よりたくさんのことを覚えられるようになる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(17,'算術士','計算が速くなる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(18,'上昇志向','より知識を欲するようになる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(19,'精神力向上','ストレスに強くなる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(20,'論理思考','論理的に考えられるようになり、騙されにくくなる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(21,'学者','あらゆる知識の吸収が少し速くなる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(22,'言語士','より難しい言葉を理解できるようになる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(23,'生存戦略','困難に直面しても自分で解決できるようになる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(24,'人格向上','他人に優しく、自分に厳しい人になれる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(25,'理性','お金の使い方が上手になる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(26,'思考加速','考えるスピードが速くなる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(27,'極限集中','自分の限界を突破し、学習することができる',2,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(28,'睡眠強化','7時間以上の睡眠でより多く元気になる',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(29,'消化向上','食べたものからより多くの栄養素を受け取れる',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(30,'ウイルス耐性','風邪などを引きにくくする',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(31,'毒耐性','食中毒にかかりにくくする',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(32,'朝の目覚め','朝スッキリと起きることができる',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(33,'美肌','肌がきれいになる',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(34,'全能力値UP','知識や運動など他のスキルが強化される',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(35,'便通向上','便秘や下痢にならない',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(36,'太陽神','周りの人にも元気を与えることができる',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(37,'視力向上','より遠くのものを見ることができる',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(38,'覇気','オーラを強くする',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(39,'回復UP','病気になっても早く元気になれる',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(40,'健康体','自分の限界を突破し、長く健康でいられる',3,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(41,'文章力UP','より伝わりやすい文章を考えることができる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(42,'傾聴効果','人の話をよく聞くことができる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(43,'伝達','人の話を間違えずに伝えることができる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(44,'声帯強化','より大きな声を出せるようになる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(45,'説得','相手を説得できる確率が上がる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(46,'拡散','自分の話を多くの人に広めることができる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(47,'情報収集','今まで知らなかった情報をより多く集めることができる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(48,'信頼','自分の話を信じてもらえやすくなる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(49,'リーダー','集団を導く力が強くなる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(50,'書き手','より多くの文字を書くことができる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(51,'聖徳太子','一度に聞こえる声が増える',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(52,'伝授','自分の知識を他人に伝えることができる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(53,'会話上手','相手とスムーズに会話することができる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(54,'密談','特定の人にしか聞こえない声で話すことができる',4,'2022-09-07 12:34:45','2022-09-07 12:34:45'),(55,'帝王','自分の限界を突破し、自分の声がより多くの人へ届く',4,'2022-09-07 12:34:45','2022-09-07 12:34:45');
/*!40000 ALTER TABLE `skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickets` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `point` int DEFAULT '100',
  `charactor_id` int DEFAULT '3',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
INSERT INTO `tickets` VALUES (1,'たかい、たかい','#3c9dbd','2022-09-07 12:34:13','2022-10-29 00:43:49',500,3),(2,'10円ゲット','#c27259','2022-09-07 12:34:13','2022-10-29 00:43:55',1000,3),(3,'パパが馬になる','#4cad61','2022-09-07 12:34:13','2022-10-29 00:44:03',300,3),(4,'小さなお菓子ゲット','#a848a5','2022-09-07 12:34:13','2022-10-29 00:44:09',1000,3),(5,'マッサージしてもらう','#d44aa1','2022-09-07 12:34:13','2022-10-29 00:44:19',300,3),(6,'100えんゲット','#0000ff','2022-10-23 01:17:07','2022-10-29 00:44:26',10000,3),(7,'かたたたき','#00ff00','2023-07-01 00:52:15','2023-07-01 00:52:15',400,4),(9,'マッサージをする','#ffffff','2023-07-02 10:02:10','2023-07-02 10:02:10',500,5),(10,'にがおえをかく','#ff00ff','2023-07-02 10:05:19','2023-07-02 10:05:19',10000,4),(11,'にがおえをかく','#000000','2023-07-04 10:11:06','2023-07-04 10:11:06',1000,5),(12,'マッサージをする','#ff00ff','2023-08-04 09:12:02','2023-08-04 09:12:02',500,4),(13,'かたたたき','#00ff00','2023-08-04 09:14:14','2023-08-04 09:14:14',300,5);
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'email.1@example.com','$2a$12$f9OiP1BjVlzm1ELDUaGM7e4blZEuND9qQfxEE..ztEbe6xB5OCjIu',NULL,NULL,'2022-09-07 12:39:28','2022-09-07 12:33:01','2022-09-07 12:39:28','uotani');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vrs`
--

DROP TABLE IF EXISTS `vrs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vrs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vrs`
--

LOCK TABLES `vrs` WRITE;
/*!40000 ALTER TABLE `vrs` DISABLE KEYS */;
/*!40000 ALTER TABLE `vrs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-11 21:36:05
