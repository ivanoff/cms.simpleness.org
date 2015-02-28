CREATE  TABLE `base_realtor_config` (
  `realtor_config_id` INT NOT NULL AUTO_INCREMENT ,
  `realtor_data_column_id` INT NULL ,
  `name` VARCHAR(1024) NULL ,
  `content` VARCHAR(45) NULL ,
  PRIMARY KEY (`realtor_config_id`) );