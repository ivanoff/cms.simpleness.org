ALTER TABLE `base_news` ADD COLUMN `news_hidden` BINARY NULL DEFAULT TRUE AFTER `news_key`;
ALTER TABLE `base_gallery_images` ADD COLUMN `img_path` VARCHAR(255) NULL AFTER `img_name`;
