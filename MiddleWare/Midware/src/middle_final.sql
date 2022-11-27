/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80031
 Source Host           : localhost:3306
 Source Schema         : middle_final

 Target Server Type    : MySQL
 Target Server Version : 80031
 File Encoding         : 65001

 Date: 27/11/2022 10:25:50
*/

CREATE DATABASE IF NOT EXISTS 'middle_final';
USE middle_final;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tstudentinfo
-- ----------------------------
DROP TABLE IF EXISTS `tstudentinfo`;
CREATE TABLE `tstudentinfo` (
  `stuNo` varchar(63) NOT NULL,
  `name` varchar(63) NOT NULL,
  `gender` enum('male','female','none') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `major` varchar(255) NOT NULL,
  PRIMARY KEY (`stuNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of tstudentinfo
-- ----------------------------
BEGIN;
INSERT INTO `tstudentinfo` (`stuNo`, `name`, `gender`, `major`) VALUES ('2019151059', 'He Rongjin', 'male', 'software engineering');
INSERT INTO `tstudentinfo` (`stuNo`, `name`, `gender`, `major`) VALUES ('2020151001', 'Yu Qinggeng', 'male', 'software engineering');
INSERT INTO `tstudentinfo` (`stuNo`, `name`, `gender`, `major`) VALUES ('2020151018', 'Guo Haidong', 'male', 'software engineering');
INSERT INTO `tstudentinfo` (`stuNo`, `name`, `gender`, `major`) VALUES ('2020151044', 'Zhong Lize', 'male', 'software engineering');
INSERT INTO `tstudentinfo` (`stuNo`, `name`, `gender`, `major`) VALUES ('2020151065', 'Li Yaohua', 'male', 'software engineering');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
