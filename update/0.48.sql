DROP TABLE IF EXISTS `base_realtor_config`;
CREATE TABLE `base_realtor_config` (
  `realtor_config_id` INT NOT NULL AUTO_INCREMENT ,
  `column_id` INT NULL ,
  `name` blob,
  `content` blob,
  `hidden` boolean,
  PRIMARY KEY (`realtor_config_id`) );