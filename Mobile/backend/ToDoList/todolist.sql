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

 Date: 10/05/2022 01:43:44
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for users_auth
-- ----------------------------
DROP TABLE IF EXISTS `users_auth`;
CREATE TABLE `users_auth` (
                              `id` int NOT NULL AUTO_INCREMENT,
                              `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                              `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                              `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              UNIQUE KEY `unique_email` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of users_auth
-- ----------------------------
BEGIN;
INSERT INTO `users_auth` (`id`, `email`, `password`, `token`) VALUES (6, 'a2509875617@gmail.com', 'C514C91E4ED341F263E458D44B3BB0A7', 'xu1NKTaA24Z8enbwNr4PFJU6xUpxn9luzeYT2i279wPuKiP6mV');
INSERT INTO `users_auth` (`id`, `email`, `password`, `token`) VALUES (11, '2509875617@qq.com', 'C514C91E4ED341F263E458D44B3BB0A7', '');
COMMIT;

-- ----------------------------
-- Table structure for users_mess
-- ----------------------------
DROP TABLE IF EXISTS `users_mess`;
CREATE TABLE `users_mess` (
                              `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                              `nick` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                              `avatar` varchar(255) DEFAULT NULL,
                              `phone` varchar(50) DEFAULT NULL,
                              PRIMARY KEY (`email`) USING BTREE,
                              CONSTRAINT `fk_email` FOREIGN KEY (`email`) REFERENCES `users_auth` (`email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of users_mess
-- ----------------------------
BEGIN;
INSERT INTO `users_mess` (`email`, `nick`, `avatar`, `phone`) VALUES ('2509875617@qq.com', 'nick', '', '');
INSERT INTO `users_mess` (`email`, `nick`, `avatar`, `phone`) VALUES ('a2509875617@gmail.com', 'giao', 'https://img1.baidu.com/it/u=3794642170,1888722368&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=563', '7777777');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
