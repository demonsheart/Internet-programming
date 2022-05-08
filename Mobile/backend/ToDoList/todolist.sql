/*
 Navicat Premium Data Transfer

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : localhost:3306
 Source Schema         : todolist

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 08/05/2022 16:59:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for users_auth
-- ----------------------------
DROP TABLE IF EXISTS `users_auth`;
CREATE TABLE `users_auth` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_account` (`account`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of users_auth
-- ----------------------------
BEGIN;
INSERT INTO `users_auth` (`id`, `account`, `password`, `token`) VALUES (1, 'demodemo', 'C514C91E4ED341F263E458D44B3BB0A7', 'GIHH1o3hDbeNgrUiAKeXOdk1yTjQSBFCiv86P50bIBZd6ba2tl');
COMMIT;

-- ----------------------------
-- Table structure for users_mess
-- ----------------------------
DROP TABLE IF EXISTS `users_mess`;
CREATE TABLE `users_mess` (
  `account` varchar(50) NOT NULL,
  `nick` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`account`),
  CONSTRAINT `fk_account` FOREIGN KEY (`account`) REFERENCES `users_auth` (`account`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of users_mess
-- ----------------------------
BEGIN;
INSERT INTO `users_mess` (`account`, `nick`, `avatar`, `phone`, `email`) VALUES ('demodemo', 'demo', 'https://img1.baidu.com/it/u=3794642170,1888722368&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=563', '88888888', '88888888@qq.com');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
