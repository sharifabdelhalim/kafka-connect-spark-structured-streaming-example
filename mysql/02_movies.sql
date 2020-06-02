DROP TABLE IF EXISTS `moviesdb`.`movie`;
CREATE TABLE `moviesdb`.`movie` (
  `id` int(11) NOT NULL,
  `title` varchar(30) NOT NULL,
  `description` text,
  `release_date` Date NOT NULL,
  `genre_id` int(11) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `movies_ibfk_1` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `moviesdb`.`movie` WRITE;
INSERT INTO `moviesdb`.`movie` (id,title,description,release_date,genre_id) VALUES (0,'Westworld','Westworld is a 1973 American science-fiction western thriller film written and directed by Michael Crichton','1973-08-17',6);
INSERT INTO `moviesdb`.`movie` (id,title,description,release_date,genre_id) VALUES (1,'Ace Ventura','Ace Ventura: Pet Detective is a 1994 American comedy film starring Jim Carrey as Ace Ventura, an animal detective who is tasked with finding the abducted dolphin mascot of the Miami Dolphins football team','1994-02-04',1);
UNLOCK TABLES;
