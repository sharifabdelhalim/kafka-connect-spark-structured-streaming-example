DROP TABLE IF EXISTS `moviesdb`.`genre`;
CREATE TABLE `moviesdb`.`genre` (
  `id` int(11) NOT NULL,
  `genre_name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `moviesdb`.`genre` WRITE;
INSERT INTO `moviesdb`.`genre` VALUES (0,'Action'),(1,'Comedy'),(2,'Drama'),(3,'Fantasy'),(4,'Horror'),(5,'Thriller'),(6,'Science Fiction');
UNLOCK TABLES;

