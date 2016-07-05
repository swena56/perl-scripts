-- MySQL dump 10.13  Distrib 5.5.49, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: bei_training
-- ------------------------------------------------------
-- Server version	5.5.49-0ubuntu0.14.04.1

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
-- Table structure for table `billing_meters`
--

DROP TABLE IF EXISTS `billing_meters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_meters` (
  `serial_id` int(10) NOT NULL,
  `bill_date` varchar(10) NOT NULL,
  `meter_code_id` int(10) NOT NULL,
  `meter_code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`serial_id`,`meter_code_id`,`bill_date`),
  KEY `meter_code_id` (`meter_code_id`),
  CONSTRAINT `billing_meters_ibfk_1` FOREIGN KEY (`serial_id`) REFERENCES `serials` (`serial_id`),
  CONSTRAINT `billing_meters_ibfk_2` FOREIGN KEY (`meter_code_id`) REFERENCES `meter_codes` (`meter_code_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `branches` (
  `branch_id` int(10) NOT NULL AUTO_INCREMENT,
  `branch_number` varchar(32) NOT NULL,
  PRIMARY KEY (`branch_id`),
  UNIQUE KEY `branch_number` (`branch_number`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `call_types`
--

DROP TABLE IF EXISTS `call_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `call_types` (
  `call_type_id` int(10) NOT NULL AUTO_INCREMENT,
  `call_type` varchar(10) DEFAULT NULL,
  `call_type_description` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`call_type_id`),
  UNIQUE KEY `call_type` (`call_type`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `correction_codes`
--

DROP TABLE IF EXISTS `correction_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `correction_codes` (
  `correction_code_id` int(10) NOT NULL AUTO_INCREMENT,
  `correction_code` varchar(32) DEFAULT NULL,
  `correction_code_desc` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`correction_code_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `customer_id` int(10) NOT NULL AUTO_INCREMENT,
  `customer_number` varchar(32) NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `customer_number` (`customer_number`)
) ENGINE=InnoDB AUTO_INCREMENT=8192 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixbilling`
--

DROP TABLE IF EXISTS `fixbilling`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fixbilling` (
  `model` varchar(30) DEFAULT NULL,
  `serial_numl` varchar(30) DEFAULT NULL,
  `billing_dl` varchar(10) DEFAULT NULL,
  `meter_code` varchar(20) DEFAULT NULL,
  `meter_readling` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixlabor`
--

DROP TABLE IF EXISTS `fixlabor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fixlabor` (
  `call_id` varchar(15) DEFAULT NULL,
  `model` varchar(30) DEFAULT NULL,
  `labor_serial` varchar(30) DEFAULT NULL,
  `activity_code` varchar(15) DEFAULT NULL,
  `assist` tinyint(1) DEFAULT NULL,
  `labor_date` varchar(10) DEFAULT NULL,
  `tech_number` varchar(10) DEFAULT NULL,
  `dispatch_time` varchar(4) DEFAULT NULL,
  `arrival_time` varchar(4) DEFAULT NULL,
  `departure_time` varchar(4) DEFAULT NULL,
  `interrupt_hours` varchar(4) DEFAULT NULL,
  `mileage` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixmdesc`
--

DROP TABLE IF EXISTS `fixmdesc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fixmdesc` (
  `meter_code` varchar(20) DEFAULT NULL,
  `meter_code_description` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixmeter`
--

DROP TABLE IF EXISTS `fixmeter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fixmeter` (
  `call_id` varchar(15) DEFAULT NULL,
  `model` varchar(30) DEFAULT NULL,
  `serial_number` varchar(30) DEFAULT NULL,
  `completion_date` varchar(10) DEFAULT NULL,
  `meter_code` varchar(20) DEFAULT NULL,
  `meter_reading` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixparla`
--

DROP TABLE IF EXISTS `fixparla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fixparla` (
  `part_number` varchar(18) DEFAULT NULL,
  `part_description` varchar(32) DEFAULT NULL,
  `add_sub_indicator` char(1) DEFAULT NULL,
  `quantity_used` int(4) DEFAULT NULL,
  `call_id` varchar(15) DEFAULT NULL,
  `model_number` varchar(30) DEFAULT NULL,
  `serial_number` varchar(30) DEFAULT NULL,
  `installation_date` varchar(10) DEFAULT NULL,
  `init_meter_reading` varchar(10) DEFAULT NULL,
  `parts_cost` varchar(12) DEFAULT NULL,
  `customer_number` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixploc`
--

DROP TABLE IF EXISTS `fixploc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fixploc` (
  `product_code` varchar(30) DEFAULT NULL,
  `vendor_part_number` varchar(18) DEFAULT NULL,
  `description` varchar(30) DEFAULT NULL,
  `identifier` char(1) DEFAULT NULL,
  `item_cost` varchar(12) DEFAULT NULL,
  `record_creation_date` varchar(10) DEFAULT NULL,
  `total_qty` int(10) DEFAULT NULL,
  `warehouse_qty` int(10) DEFAULT NULL,
  `warehouse_location_number` varchar(10) DEFAULT NULL,
  `qty_on_hand` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixserl`
--

DROP TABLE IF EXISTS `fixserl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fixserl` (
  `serial_id` varchar(30) DEFAULT NULL,
  `model_description` varchar(32) DEFAULT NULL,
  `initial_meter_reading` int(10) DEFAULT NULL,
  `date_sold_or_rented` varchar(10) DEFAULT NULL,
  `model_number` varchar(30) DEFAULT NULL,
  `source_code` varchar(1) DEFAULT NULL,
  `meter_reading_on_last_service_call` int(10) DEFAULT NULL,
  `null_placeholder` varchar(25) DEFAULT NULL,
  `date_of_last_service_call` varchar(10) DEFAULT NULL,
  `customer_number` varchar(32) DEFAULT NULL,
  `program_type_code` varchar(10) DEFAULT NULL,
  `product_category_code` varchar(6) DEFAULT NULL,
  `sales_rep_id` varchar(6) DEFAULT NULL,
  `connectivity_code` varchar(2) DEFAULT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `sic_number` varchar(6) DEFAULT NULL,
  `equipment_id` varchar(10) DEFAULT NULL,
  `primary_technician_id` varchar(10) DEFAULT NULL,
  `facility_management_equip` varchar(15) DEFAULT NULL,
  `is_under_contract` tinyint(1) DEFAULT NULL,
  `branch_id` varchar(10) DEFAULT NULL,
  `customer_bill_to_number` varchar(32) DEFAULT NULL,
  `customer_type` varchar(15) DEFAULT NULL,
  `territory_field` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fixserv`
--

DROP TABLE IF EXISTS `fixserv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fixserv` (
  `null_field1` varchar(10) DEFAULT NULL,
  `call_id` varchar(15) DEFAULT NULL,
  `model_number` varchar(30) DEFAULT NULL,
  `serial_number` varchar(30) DEFAULT NULL,
  `call_date` varchar(10) DEFAULT NULL,
  `call_time` varchar(4) DEFAULT NULL,
  `customer_time` varchar(4) DEFAULT NULL,
  `arrival_time` varchar(4) DEFAULT NULL,
  `call_completion_time` varchar(10) DEFAULT NULL,
  `call_type` varchar(10) DEFAULT NULL,
  `problem_code` varchar(4) DEFAULT NULL,
  `location_code` varchar(4) DEFAULT NULL,
  `reason_code` varchar(100) DEFAULT NULL,
  `correction_code` varchar(4) DEFAULT NULL,
  `date_dispatched` varchar(10) DEFAULT NULL,
  `time_dispatched` varchar(4) DEFAULT NULL,
  `completion_date` varchar(10) DEFAULT NULL,
  `meter_reading_total` int(10) DEFAULT NULL,
  `meter_reading_prior_call` int(10) DEFAULT NULL,
  `date_of_prior_call` varchar(10) DEFAULT NULL,
  `pc_type` varchar(4) DEFAULT NULL,
  `lc_type` varchar(4) DEFAULT NULL,
  `null_field2` varchar(10) DEFAULT NULL,
  `machine_status` varchar(25) DEFAULT NULL,
  `technician_id_number` varchar(10) DEFAULT NULL,
  `customer_number` varchar(32) DEFAULT NULL,
  `miles_driven` int(10) DEFAULT NULL,
  `response_time` varchar(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `location_codes`
--

DROP TABLE IF EXISTS `location_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location_codes` (
  `location_code_id` int(10) NOT NULL AUTO_INCREMENT,
  `location_code` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`location_code_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meter_codes`
--

DROP TABLE IF EXISTS `meter_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meter_codes` (
  `meter_code_id` int(10) NOT NULL AUTO_INCREMENT,
  `meter_code` varchar(32) DEFAULT NULL,
  `meter_description` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`meter_code_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `models`
--

DROP TABLE IF EXISTS `models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `models` (
  `model_id` int(10) NOT NULL AUTO_INCREMENT,
  `model_number` varchar(30) DEFAULT NULL,
  `model_description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`model_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2048 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `parts`
--

DROP TABLE IF EXISTS `parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parts` (
  `part_id` int(10) NOT NULL AUTO_INCREMENT,
  `part_number` varchar(18) DEFAULT NULL,
  `part_description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`part_id`)
) ENGINE=InnoDB AUTO_INCREMENT=512 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `problem_codes`
--

DROP TABLE IF EXISTS `problem_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem_codes` (
  `problem_code_id` int(10) NOT NULL AUTO_INCREMENT,
  `problem_code` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`problem_code_id`),
  UNIQUE KEY `problem_code` (`problem_code`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `programs` (
  `program_id` int(10) NOT NULL AUTO_INCREMENT,
  `program_number` varchar(32) NOT NULL,
  PRIMARY KEY (`program_id`),
  UNIQUE KEY `program_number` (`program_number`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `serials`
--

DROP TABLE IF EXISTS `serials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serials` (
  `serial_id` int(10) NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(30) NOT NULL,
  `model_id` int(10) DEFAULT NULL,
  `customer_id` int(10) DEFAULT NULL,
  `branch_id` int(10) DEFAULT NULL,
  `program_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`serial_id`),
  UNIQUE KEY `serial_number` (`serial_number`,`model_id`),
  KEY `model_id` (`model_id`),
  KEY `customer_id` (`customer_id`),
  KEY `branch_id` (`branch_id`),
  KEY `program_id` (`program_id`),
  CONSTRAINT `serials_ibfk_1` FOREIGN KEY (`model_id`) REFERENCES `models` (`model_id`),
  CONSTRAINT `serials_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `serials_ibfk_3` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`branch_id`),
  CONSTRAINT `serials_ibfk_4` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16384 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service` (
  `service_id` int(10) NOT NULL AUTO_INCREMENT,
  `call_datetime` datetime DEFAULT NULL,
  `dispatched_datetime` datetime DEFAULT NULL,
  `arrival_datetime` datetime DEFAULT NULL,
  `completion_datetime` datetime DEFAULT NULL,
  `serial_id` int(10) DEFAULT NULL,
  `technician_id` int(10) DEFAULT NULL,
  `problem_code_id` int(10) DEFAULT NULL,
  `location_code_id` int(10) DEFAULT NULL,
  `call_id_not_call_type` varchar(10) NOT NULL,
  `call_type_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`service_id`),
  UNIQUE KEY `serial_id` (`serial_id`,`completion_datetime`,`call_id_not_call_type`),
  KEY `technician_id` (`technician_id`),
  KEY `problem_code_id` (`problem_code_id`),
  KEY `location_code_id` (`location_code_id`),
  KEY `call_type_id` (`call_type_id`),
  CONSTRAINT `service_ibfk_1` FOREIGN KEY (`serial_id`) REFERENCES `serials` (`serial_id`),
  CONSTRAINT `service_ibfk_2` FOREIGN KEY (`technician_id`) REFERENCES `technicians` (`technician_id`),
  CONSTRAINT `service_ibfk_3` FOREIGN KEY (`problem_code_id`) REFERENCES `problem_codes` (`problem_code_id`),
  CONSTRAINT `service_ibfk_4` FOREIGN KEY (`location_code_id`) REFERENCES `location_codes` (`location_code_id`),
  CONSTRAINT `service_ibfk_5` FOREIGN KEY (`call_type_id`) REFERENCES `call_types` (`call_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2048 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_meters`
--

DROP TABLE IF EXISTS `service_meters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_meters` (
  `service_id` int(10) NOT NULL,
  `meter_code_id` int(10) NOT NULL,
  `meter` int(10) DEFAULT NULL,
  PRIMARY KEY (`service_id`,`meter_code_id`),
  KEY `meter_code_id` (`meter_code_id`),
  CONSTRAINT `service_meters_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `service` (`service_id`),
  CONSTRAINT `service_meters_ibfk_2` FOREIGN KEY (`meter_code_id`) REFERENCES `meter_codes` (`meter_code_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_parts`
--

DROP TABLE IF EXISTS `service_parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_parts` (
  `service_id` int(10) NOT NULL,
  `part_id` int(10) NOT NULL,
  `addsub` char(1) NOT NULL,
  `cost` decimal(12,4) DEFAULT NULL,
  PRIMARY KEY (`service_id`,`part_id`,`addsub`),
  KEY `part_id` (`part_id`),
  CONSTRAINT `service_parts_ibfk_1` FOREIGN KEY (`part_id`) REFERENCES `parts` (`part_id`),
  CONSTRAINT `service_parts_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `service` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `technicians`
--

DROP TABLE IF EXISTS `technicians`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `technicians` (
  `technician_id` int(10) NOT NULL AUTO_INCREMENT,
  `technician_number` varchar(32) NOT NULL,
  PRIMARY KEY (`technician_id`),
  UNIQUE KEY `technician_number` (`technician_number`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-07-01  8:20:02
