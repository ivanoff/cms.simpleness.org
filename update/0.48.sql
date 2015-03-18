
DROP TABLE IF EXISTS `base_realtor_config`;

CREATE TABLE `base_realtor_config` (
  `realtor_config_id` int(11) NOT NULL AUTO_INCREMENT,
  `column_id` int(11) DEFAULT NULL,
  `name` varchar(1024),
  `type` varchar(64),
  `dimension` varchar(1024),
  `hidden` tinyint(1) DEFAULT NULL,
  `details_hide` tinyint(1) DEFAULT NULL,
  `pdf_hide` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`realtor_config_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

