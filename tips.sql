CREATE DATABADE tips;
USE tips;

CREATE TABLE IF NOT EXISTS `tips` (
  `tip` varchar(200) DEFAULT NULL,
  `timestamp` int(30) NOT NULL
);
