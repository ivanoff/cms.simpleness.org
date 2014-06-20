DROP TABLE IF EXISTS `base_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `base_comments` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `lang` varchar(2) NOT NULL,
  `comment_type` varchar(1) DEFAULT NULL,
  `comment_url` varchar(512) DEFAULT NULL,
  `comment_body` varchar(128) DEFAULT NULL,
  `comment_position` float DEFAULT NULL,
  `comment_private` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `fk_base_comments_user_url` (`user_id`,`comment_url`),
  KEY `fk_base_comments_user_id` (`user_id`),
  CONSTRAINT `fk_base_comments_user_id` FOREIGN KEY (`user_id`) REFERENCES `base_users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
