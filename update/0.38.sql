CREATE  TABLE `tec_odn`.`base_comments` (
  `comment_id` INT NOT NULL AUTO_INCREMENT ,
  `user_id` INT NULL ,
  `comment_type` VARCHAR(1) NULL ,
  `comment_body` VARCHAR(45) NULL ,
PRIMARY KEY (`comment_id`) ,
INDEX `fk_base_comments_user_id` (`user_id` ASC) ,
CONSTRAINT `fk_base_comments_user_id`
    FOREIGN KEY (`user_id` )
    REFERENCES `tec_odn`.`base_users` (`user_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE);
            