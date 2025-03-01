/*
 Navicat Premium Data Transfer

 Source Server         : Mysql
 Source Server Type    : MySQL
 Source Server Version : 80031
 Source Host           : localhost:3306
 Source Schema         : aiops

 Target Server Type    : MySQL
 Target Server Version : 80031
 File Encoding         : 65001

 Date: 19/09/2024 11:23:21
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for node
-- ----------------------------
DROP TABLE IF EXISTS `node`;
CREATE TABLE `node`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '组件id',
  `node_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件名称',
  `node_data` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件数据',
  `node_input` int NULL DEFAULT NULL COMMENT '输入参数数量',
  `node_output` int NULL DEFAULT NULL COMMENT '输出参数数量',
  `user_id` bigint NULL DEFAULT NULL COMMENT '创建者id',
  `node_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件介绍',
  `node_title` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件标题',
  `pid` int NULL DEFAULT NULL COMMENT '父级id',
  `sort_num` int NULL DEFAULT NULL COMMENT '排序',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'https://gw.alipayobjects.com/mdn/rms_43231b/afts/img/A*evDjT5vjkX0AAAAAAAAAAAAAARQnAQ' COMMENT '图标',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of node
-- ----------------------------
INSERT INTO `node` VALUES (1, 'IO', NULL, NULL, NULL, NULL, NULL, '输入输出', NULL, NULL, 'https://gw.alipayobjects.com/mdn/rms_43231b/afts/img/A*evDjT5vjkX0AAAAAAAAAAAAAARQnAQ', NULL);
INSERT INTO `node` VALUES (2, 'imgInput', '222', 0, 1, NULL, '123', '图片数据', 1, NULL, 'http://localhost:9090/file/0a058f5ca96f41f58d072ca69bb6ff06.jpg', 'output');
INSERT INTO `node` VALUES (3, 'dataOutput', '', 1, 1, NULL, NULL, '数据输出', 1, NULL, 'model.svg', 'onlyIn');
INSERT INTO `node` VALUES (4, 'DataAnalysis', NULL, NULL, NULL, NULL, NULL, '数据分析', NULL, NULL, 'https://gw.alipayobjects.com/mdn/rms_43231b/afts/img/A*evDjT5vjkX0AAAAAAAAAAAAAARQnAQ', NULL);
INSERT INTO `node` VALUES (5, 'imgHandle', '', 1, 1, NULL, NULL, '图片处理', 4, NULL, 'model.svg', 'database');
INSERT INTO `node` VALUES (6, 'Models', NULL, NULL, NULL, NULL, NULL, '模型', NULL, NULL, 'https://gw.alipayobjects.com/mdn/rms_43231b/afts/img/A*evDjT5vjkX0AAAAAAAAAAAAAARQnAQ', NULL);
INSERT INTO `node` VALUES (7, 'imgCompare', '', 1, 1, NULL, NULL, '图片比较', 4, NULL, 'model.svg', 'condition');
INSERT INTO `node` VALUES (8, 'faceFeature', '', 1, 1, NULL, NULL, '特征提取', 6, NULL, 'https://gw.alipayobjects.com/mdn/rms_43231b/afts/img/A*evDjT5vjkX0AAAAAAAAAAAAAARQnAQ', 'database');

-- ----------------------------
-- Table structure for nodedata
-- ----------------------------
DROP TABLE IF EXISTS `nodedata`;
CREATE TABLE `nodedata`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `node_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `node_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `node_version` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `node_dependence` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of nodedata
-- ----------------------------
INSERT INTO `nodedata` VALUES (1, 'imgInput', '这是图片输入组件', '1.0', 'python == 3.9');
INSERT INTO `nodedata` VALUES (2, 'dataOutput', '这是图片输出组件', '1.0', 'python == 3.9');
INSERT INTO `nodedata` VALUES (3, 'imgHandle', '这是图片处理组件', '1.0', 'python == 3.9');
INSERT INTO `nodedata` VALUES (4, 'imgCompare', '这是图片比较组件', '1.0', 'python == 3.9');
INSERT INTO `nodedata` VALUES (5, 'faceFeature', '这是图片特征提取组件', '1.0', 'python == 3.9');

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`  (
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '内容',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES ('platform-eleme', 'el-icon-platform-eleme', 'icon');
INSERT INTO `sys_dict` VALUES ('eleme', 'el-icon-eleme', 'icon');
INSERT INTO `sys_dict` VALUES ('delete-solid', 'el-icon-delete-solid', 'icon');
INSERT INTO `sys_dict` VALUES ('delete', 'el-icon-delete', 'icon');
INSERT INTO `sys_dict` VALUES ('s-tools', 'el-icon-s-tools', 'icon');
INSERT INTO `sys_dict` VALUES ('setting', 'el-icon-setting', 'icon');
INSERT INTO `sys_dict` VALUES ('user-solid', 'el-icon-user-solid', 'icon');
INSERT INTO `sys_dict` VALUES ('user', 'el-icon-user', 'icon');
INSERT INTO `sys_dict` VALUES ('phone', 'el-icon-phone', 'icon');
INSERT INTO `sys_dict` VALUES ('phone-outline', 'el-icon-phone-outline', 'icon');
INSERT INTO `sys_dict` VALUES ('more', 'el-icon-more', 'icon');
INSERT INTO `sys_dict` VALUES ('more-outline', 'el-icon-more-outline', 'icon');
INSERT INTO `sys_dict` VALUES ('star-on', 'el-icon-star-on', 'icon');
INSERT INTO `sys_dict` VALUES ('star-off', 'el-icon-star-off', 'icon');
INSERT INTO `sys_dict` VALUES ('s-goods', 'el-icon-s-goods', 'icon');
INSERT INTO `sys_dict` VALUES ('goods', 'el-icon-goods', 'icon');
INSERT INTO `sys_dict` VALUES ('warning', 'el-icon-warning', 'icon');
INSERT INTO `sys_dict` VALUES ('warning-outline', 'el-icon-warning-outline', 'icon');
INSERT INTO `sys_dict` VALUES ('question', 'el-icon-question', 'icon');
INSERT INTO `sys_dict` VALUES ('info', 'el-icon-info', 'icon');
INSERT INTO `sys_dict` VALUES ('remove', 'el-icon-remove', 'icon');
INSERT INTO `sys_dict` VALUES ('circle-plus', 'el-icon-circle-plus', 'icon');
INSERT INTO `sys_dict` VALUES ('success', 'el-icon-success', 'icon');
INSERT INTO `sys_dict` VALUES ('error', 'el-icon-error', 'icon');
INSERT INTO `sys_dict` VALUES ('zoom-in', 'el-icon-zoom-in', 'icon');
INSERT INTO `sys_dict` VALUES ('zoom-out', 'el-icon-zoom-out', 'icon');
INSERT INTO `sys_dict` VALUES ('remove-outline', 'el-icon-remove-outline', 'icon');
INSERT INTO `sys_dict` VALUES ('circle-plus-outline', 'el-icon-circle-plus-outline', 'icon');
INSERT INTO `sys_dict` VALUES ('circle-check', 'el-icon-circle-check', 'icon');
INSERT INTO `sys_dict` VALUES ('circle-close', 'el-icon-circle-close', 'icon');
INSERT INTO `sys_dict` VALUES ('s-help', 'el-icon-s-help', 'icon');
INSERT INTO `sys_dict` VALUES ('help', 'el-icon-help', 'icon');
INSERT INTO `sys_dict` VALUES ('minus', 'el-icon-minus', 'icon');
INSERT INTO `sys_dict` VALUES ('plus', 'el-icon-plus', 'icon');
INSERT INTO `sys_dict` VALUES ('check', 'el-icon-check', 'icon');
INSERT INTO `sys_dict` VALUES ('close', 'el-icon-close', 'icon');
INSERT INTO `sys_dict` VALUES ('picture', 'el-icon-picture', 'icon');
INSERT INTO `sys_dict` VALUES ('picture-outline', 'el-icon-picture-outline', 'icon');
INSERT INTO `sys_dict` VALUES ('picture-outline-round', 'el-icon-picture-outline-round', 'icon');
INSERT INTO `sys_dict` VALUES ('upload', 'el-icon-upload', 'icon');
INSERT INTO `sys_dict` VALUES ('upload2', 'el-icon-upload2', 'icon');
INSERT INTO `sys_dict` VALUES ('download', 'el-icon-download', 'icon');
INSERT INTO `sys_dict` VALUES ('camera-solid', 'el-icon-camera-solid', 'icon');
INSERT INTO `sys_dict` VALUES ('camera', 'el-icon-camera', 'icon');
INSERT INTO `sys_dict` VALUES ('video-camera-solid', 'el-icon-video-camera-solid', 'icon');
INSERT INTO `sys_dict` VALUES ('video-camera', 'el-icon-video-camera', 'icon');
INSERT INTO `sys_dict` VALUES ('message-solid', 'el-icon-message-solid', 'icon');
INSERT INTO `sys_dict` VALUES ('bell', 'el-icon-bell', 'icon');
INSERT INTO `sys_dict` VALUES ('s-cooperation', 'el-icon-s-cooperation', 'icon');
INSERT INTO `sys_dict` VALUES ('s-order', 'el-icon-s-order', 'icon');
INSERT INTO `sys_dict` VALUES ('s-platform', 'el-icon-s-platform', 'icon');
INSERT INTO `sys_dict` VALUES ('s-fold', 'el-icon-s-fold', 'icon');
INSERT INTO `sys_dict` VALUES ('s-unfold', 'el-icon-s-unfold', 'icon');
INSERT INTO `sys_dict` VALUES ('s-operation', 'el-icon-s-operation', 'icon');
INSERT INTO `sys_dict` VALUES ('s-promotion', 'el-icon-s-promotion', 'icon');
INSERT INTO `sys_dict` VALUES ('s-home', 'el-icon-s-home', 'icon');
INSERT INTO `sys_dict` VALUES ('s-release', 'el-icon-s-release', 'icon');
INSERT INTO `sys_dict` VALUES ('s-ticket', 'el-icon-s-ticket', 'icon');
INSERT INTO `sys_dict` VALUES ('s-management', 'el-icon-s-management', 'icon');
INSERT INTO `sys_dict` VALUES ('s-open', 'el-icon-s-open', 'icon');
INSERT INTO `sys_dict` VALUES ('s-shop', 'el-icon-s-shop', 'icon');
INSERT INTO `sys_dict` VALUES ('s-marketing', 'el-icon-s-marketing', 'icon');
INSERT INTO `sys_dict` VALUES ('s-flag', 'el-icon-s-flag', 'icon');
INSERT INTO `sys_dict` VALUES ('s-comment', 'el-icon-s-comment', 'icon');
INSERT INTO `sys_dict` VALUES ('s-finance', 'el-icon-s-finance', 'icon');
INSERT INTO `sys_dict` VALUES ('s-claim', 'el-icon-s-claim', 'icon');
INSERT INTO `sys_dict` VALUES ('s-custom', 'el-icon-s-custom', 'icon');
INSERT INTO `sys_dict` VALUES ('s-opportunity', 'el-icon-s-opportunity', 'icon');
INSERT INTO `sys_dict` VALUES ('s-data', 'el-icon-s-data', 'icon');
INSERT INTO `sys_dict` VALUES ('s-check', 'el-icon-s-check', 'icon');
INSERT INTO `sys_dict` VALUES ('s-grid', 'el-icon-s-grid', 'icon');
INSERT INTO `sys_dict` VALUES ('menu', 'el-icon-menu', 'icon');
INSERT INTO `sys_dict` VALUES ('share', 'el-icon-share', 'icon');
INSERT INTO `sys_dict` VALUES ('d-caret', 'el-icon-d-caret', 'icon');
INSERT INTO `sys_dict` VALUES ('caret-left', 'el-icon-caret-left', 'icon');
INSERT INTO `sys_dict` VALUES ('caret-right', 'el-icon-caret-right', 'icon');
INSERT INTO `sys_dict` VALUES ('caret-bottom', 'el-icon-caret-bottom', 'icon');
INSERT INTO `sys_dict` VALUES ('caret-top', 'el-icon-caret-top', 'icon');
INSERT INTO `sys_dict` VALUES ('bottom-left', 'el-icon-bottom-left', 'icon');
INSERT INTO `sys_dict` VALUES ('bottom-right', 'el-icon-bottom-right', 'icon');
INSERT INTO `sys_dict` VALUES ('back', 'el-icon-back', 'icon');
INSERT INTO `sys_dict` VALUES ('right', 'el-icon-right', 'icon');
INSERT INTO `sys_dict` VALUES ('bottom', 'el-icon-bottom', 'icon');
INSERT INTO `sys_dict` VALUES ('top', 'el-icon-top', 'icon');
INSERT INTO `sys_dict` VALUES ('top-left', 'el-icon-top-left', 'icon');
INSERT INTO `sys_dict` VALUES ('top-right', 'el-icon-top-right', 'icon');
INSERT INTO `sys_dict` VALUES ('arrow-left', 'el-icon-arrow-left', 'icon');
INSERT INTO `sys_dict` VALUES ('arrow-right', 'el-icon-arrow-right', 'icon');
INSERT INTO `sys_dict` VALUES ('arrow-down', 'el-icon-arrow-down', 'icon');
INSERT INTO `sys_dict` VALUES ('arrow-up', 'el-icon-arrow-up', 'icon');
INSERT INTO `sys_dict` VALUES ('d-arrow-left', 'el-icon-d-arrow-left', 'icon');
INSERT INTO `sys_dict` VALUES ('d-arrow-right', 'el-icon-d-arrow-right', 'icon');
INSERT INTO `sys_dict` VALUES ('video-pause', 'el-icon-video-pause', 'icon');
INSERT INTO `sys_dict` VALUES ('video-play', 'el-icon-video-play', 'icon');
INSERT INTO `sys_dict` VALUES ('refresh', 'el-icon-refresh', 'icon');
INSERT INTO `sys_dict` VALUES ('refresh-right', 'el-icon-refresh-right', 'icon');
INSERT INTO `sys_dict` VALUES ('refresh-left', 'el-icon-refresh-left', 'icon');
INSERT INTO `sys_dict` VALUES ('finished', 'el-icon-finished', 'icon');
INSERT INTO `sys_dict` VALUES ('sort', 'el-icon-sort', 'icon');
INSERT INTO `sys_dict` VALUES ('sort-up', 'el-icon-sort-up', 'icon');
INSERT INTO `sys_dict` VALUES ('sort-down', 'el-icon-sort-down', 'icon');
INSERT INTO `sys_dict` VALUES ('rank', 'el-icon-rank', 'icon');
INSERT INTO `sys_dict` VALUES ('loading', 'el-icon-loading', 'icon');
INSERT INTO `sys_dict` VALUES ('view', 'el-icon-view', 'icon');
INSERT INTO `sys_dict` VALUES ('c-scale-to-original', 'el-icon-c-scale-to-original', 'icon');
INSERT INTO `sys_dict` VALUES ('date', 'el-icon-date', 'icon');
INSERT INTO `sys_dict` VALUES ('edit', 'el-icon-edit', 'icon');
INSERT INTO `sys_dict` VALUES ('edit-outline', 'el-icon-edit-outline', 'icon');
INSERT INTO `sys_dict` VALUES ('folder', 'el-icon-folder', 'icon');
INSERT INTO `sys_dict` VALUES ('folder-opened', 'el-icon-folder-opened', 'icon');
INSERT INTO `sys_dict` VALUES ('folder-add', 'el-icon-folder-add', 'icon');
INSERT INTO `sys_dict` VALUES ('folder-remove', 'el-icon-folder-remove', 'icon');
INSERT INTO `sys_dict` VALUES ('folder-delete', 'el-icon-folder-delete', 'icon');
INSERT INTO `sys_dict` VALUES ('folder-checked', 'el-icon-folder-checked', 'icon');
INSERT INTO `sys_dict` VALUES ('tickets', 'el-icon-tickets', 'icon');
INSERT INTO `sys_dict` VALUES ('document-remove', 'el-icon-document-remove', 'icon');
INSERT INTO `sys_dict` VALUES ('document-delete', 'el-icon-document-delete', 'icon');
INSERT INTO `sys_dict` VALUES ('document-copy', 'el-icon-document-copy', 'icon');
INSERT INTO `sys_dict` VALUES ('document-checked', 'el-icon-document-checked', 'icon');
INSERT INTO `sys_dict` VALUES ('document', 'el-icon-document', 'icon');
INSERT INTO `sys_dict` VALUES ('document-add', 'el-icon-document-add', 'icon');
INSERT INTO `sys_dict` VALUES ('printer', 'el-icon-printer', 'icon');
INSERT INTO `sys_dict` VALUES ('paperclip', 'el-icon-paperclip', 'icon');
INSERT INTO `sys_dict` VALUES ('takeaway-box', 'el-icon-takeaway-box', 'icon');
INSERT INTO `sys_dict` VALUES ('search', 'el-icon-search', 'icon');
INSERT INTO `sys_dict` VALUES ('monitor', 'el-icon-monitor', 'icon');
INSERT INTO `sys_dict` VALUES ('attract', 'el-icon-attract', 'icon');
INSERT INTO `sys_dict` VALUES ('mobile', 'el-icon-mobile', 'icon');
INSERT INTO `sys_dict` VALUES ('scissors', 'el-icon-scissors', 'icon');
INSERT INTO `sys_dict` VALUES ('umbrella', 'el-icon-umbrella', 'icon');
INSERT INTO `sys_dict` VALUES ('headset', 'el-icon-headset', 'icon');
INSERT INTO `sys_dict` VALUES ('brush', 'el-icon-brush', 'icon');
INSERT INTO `sys_dict` VALUES ('mouse', 'el-icon-mouse', 'icon');
INSERT INTO `sys_dict` VALUES ('coordinate', 'el-icon-coordinate', 'icon');
INSERT INTO `sys_dict` VALUES ('magic-stick', 'el-icon-magic-stick', 'icon');
INSERT INTO `sys_dict` VALUES ('reading', 'el-icon-reading', 'icon');
INSERT INTO `sys_dict` VALUES ('data-line', 'el-icon-data-line', 'icon');
INSERT INTO `sys_dict` VALUES ('data-board', 'el-icon-data-board', 'icon');
INSERT INTO `sys_dict` VALUES ('pie-chart', 'el-icon-pie-chart', 'icon');
INSERT INTO `sys_dict` VALUES ('data-analysis', 'el-icon-data-analysis', 'icon');
INSERT INTO `sys_dict` VALUES ('collection-tag', 'el-icon-collection-tag', 'icon');
INSERT INTO `sys_dict` VALUES ('film', 'el-icon-film', 'icon');
INSERT INTO `sys_dict` VALUES ('suitcase', 'el-icon-suitcase', 'icon');
INSERT INTO `sys_dict` VALUES ('suitcase-1', 'el-icon-suitcase-1', 'icon');
INSERT INTO `sys_dict` VALUES ('receiving', 'el-icon-receiving', 'icon');
INSERT INTO `sys_dict` VALUES ('collection', 'el-icon-collection', 'icon');
INSERT INTO `sys_dict` VALUES ('files', 'el-icon-files', 'icon');
INSERT INTO `sys_dict` VALUES ('notebook-1', 'el-icon-notebook-1', 'icon');
INSERT INTO `sys_dict` VALUES ('notebook-2', 'el-icon-notebook-2', 'icon');
INSERT INTO `sys_dict` VALUES ('toilet-paper', 'el-icon-toilet-paper', 'icon');
INSERT INTO `sys_dict` VALUES ('office-building', 'el-icon-office-building', 'icon');
INSERT INTO `sys_dict` VALUES ('school', 'el-icon-school', 'icon');
INSERT INTO `sys_dict` VALUES ('table-lamp', 'el-icon-table-lamp', 'icon');
INSERT INTO `sys_dict` VALUES ('house', 'el-icon-house', 'icon');
INSERT INTO `sys_dict` VALUES ('no-smoking', 'el-icon-no-smoking', 'icon');
INSERT INTO `sys_dict` VALUES ('smoking', 'el-icon-smoking', 'icon');
INSERT INTO `sys_dict` VALUES ('shopping-cart-full', 'el-icon-shopping-cart-full', 'icon');
INSERT INTO `sys_dict` VALUES ('shopping-cart-1', 'el-icon-shopping-cart-1', 'icon');
INSERT INTO `sys_dict` VALUES ('shopping-cart-2', 'el-icon-shopping-cart-2', 'icon');
INSERT INTO `sys_dict` VALUES ('shopping-bag-1', 'el-icon-shopping-bag-1', 'icon');
INSERT INTO `sys_dict` VALUES ('shopping-bag-2', 'el-icon-shopping-bag-2', 'icon');
INSERT INTO `sys_dict` VALUES ('sold-out', 'el-icon-sold-out', 'icon');
INSERT INTO `sys_dict` VALUES ('sell', 'el-icon-sell', 'icon');
INSERT INTO `sys_dict` VALUES ('present', 'el-icon-present', 'icon');
INSERT INTO `sys_dict` VALUES ('box', 'el-icon-box', 'icon');
INSERT INTO `sys_dict` VALUES ('bank-card', 'el-icon-bank-card', 'icon');
INSERT INTO `sys_dict` VALUES ('money', 'el-icon-money', 'icon');
INSERT INTO `sys_dict` VALUES ('coin', 'el-icon-coin', 'icon');
INSERT INTO `sys_dict` VALUES ('wallet', 'el-icon-wallet', 'icon');
INSERT INTO `sys_dict` VALUES ('discount', 'el-icon-discount', 'icon');
INSERT INTO `sys_dict` VALUES ('price-tag', 'el-icon-price-tag', 'icon');
INSERT INTO `sys_dict` VALUES ('news', 'el-icon-news', 'icon');
INSERT INTO `sys_dict` VALUES ('guide', 'el-icon-guide', 'icon');
INSERT INTO `sys_dict` VALUES ('male', 'el-icon-male', 'icon');
INSERT INTO `sys_dict` VALUES ('female', 'el-icon-female', 'icon');
INSERT INTO `sys_dict` VALUES ('thumb', 'el-icon-thumb', 'icon');
INSERT INTO `sys_dict` VALUES ('cpu', 'el-icon-cpu', 'icon');
INSERT INTO `sys_dict` VALUES ('link', 'el-icon-link', 'icon');
INSERT INTO `sys_dict` VALUES ('connection', 'el-icon-connection', 'icon');
INSERT INTO `sys_dict` VALUES ('open', 'el-icon-open', 'icon');
INSERT INTO `sys_dict` VALUES ('turn-off', 'el-icon-turn-off', 'icon');
INSERT INTO `sys_dict` VALUES ('set-up', 'el-icon-set-up', 'icon');
INSERT INTO `sys_dict` VALUES ('chat-round', 'el-icon-chat-round', 'icon');
INSERT INTO `sys_dict` VALUES ('chat-line-round', 'el-icon-chat-line-round', 'icon');
INSERT INTO `sys_dict` VALUES ('chat-square', 'el-icon-chat-square', 'icon');
INSERT INTO `sys_dict` VALUES ('chat-dot-round', 'el-icon-chat-dot-round', 'icon');
INSERT INTO `sys_dict` VALUES ('chat-dot-square', 'el-icon-chat-dot-square', 'icon');
INSERT INTO `sys_dict` VALUES ('chat-line-square', 'el-icon-chat-line-square', 'icon');
INSERT INTO `sys_dict` VALUES ('message', 'el-icon-message', 'icon');
INSERT INTO `sys_dict` VALUES ('postcard', 'el-icon-postcard', 'icon');
INSERT INTO `sys_dict` VALUES ('position', 'el-icon-position', 'icon');
INSERT INTO `sys_dict` VALUES ('turn-off-microphone', 'el-icon-turn-off-microphone', 'icon');
INSERT INTO `sys_dict` VALUES ('microphone', 'el-icon-microphone', 'icon');
INSERT INTO `sys_dict` VALUES ('close-notification', 'el-icon-close-notification', 'icon');
INSERT INTO `sys_dict` VALUES ('bangzhu', 'el-icon-bangzhu', 'icon');
INSERT INTO `sys_dict` VALUES ('time', 'el-icon-time', 'icon');
INSERT INTO `sys_dict` VALUES ('odometer', 'el-icon-odometer', 'icon');
INSERT INTO `sys_dict` VALUES ('crop', 'el-icon-crop', 'icon');
INSERT INTO `sys_dict` VALUES ('aim', 'el-icon-aim', 'icon');
INSERT INTO `sys_dict` VALUES ('switch-button', 'el-icon-switch-button', 'icon');
INSERT INTO `sys_dict` VALUES ('full-screen', 'el-icon-full-screen', 'icon');
INSERT INTO `sys_dict` VALUES ('copy-document', 'el-icon-copy-document', 'icon');
INSERT INTO `sys_dict` VALUES ('mic', 'el-icon-mic', 'icon');
INSERT INTO `sys_dict` VALUES ('stopwatch', 'el-icon-stopwatch', 'icon');
INSERT INTO `sys_dict` VALUES ('medal-1', 'el-icon-medal-1', 'icon');
INSERT INTO `sys_dict` VALUES ('medal', 'el-icon-medal', 'icon');
INSERT INTO `sys_dict` VALUES ('trophy', 'el-icon-trophy', 'icon');
INSERT INTO `sys_dict` VALUES ('trophy-1', 'el-icon-trophy-1', 'icon');
INSERT INTO `sys_dict` VALUES ('first-aid-kit', 'el-icon-first-aid-kit', 'icon');
INSERT INTO `sys_dict` VALUES ('discover', 'el-icon-discover', 'icon');
INSERT INTO `sys_dict` VALUES ('place', 'el-icon-place', 'icon');
INSERT INTO `sys_dict` VALUES ('location', 'el-icon-location', 'icon');
INSERT INTO `sys_dict` VALUES ('location-outline', 'el-icon-location-outline', 'icon');
INSERT INTO `sys_dict` VALUES ('location-information', 'el-icon-location-information', 'icon');
INSERT INTO `sys_dict` VALUES ('add-location', 'el-icon-add-location', 'icon');
INSERT INTO `sys_dict` VALUES ('delete-location', 'el-icon-delete-location', 'icon');
INSERT INTO `sys_dict` VALUES ('map-location', 'el-icon-map-location', 'icon');
INSERT INTO `sys_dict` VALUES ('alarm-clock', 'el-icon-alarm-clock', 'icon');
INSERT INTO `sys_dict` VALUES ('timer', 'el-icon-timer', 'icon');
INSERT INTO `sys_dict` VALUES ('watch-1', 'el-icon-watch-1', 'icon');
INSERT INTO `sys_dict` VALUES ('watch', 'el-icon-watch', 'icon');
INSERT INTO `sys_dict` VALUES ('lock', 'el-icon-lock', 'icon');
INSERT INTO `sys_dict` VALUES ('unlock', 'el-icon-unlock', 'icon');
INSERT INTO `sys_dict` VALUES ('key', 'el-icon-key', 'icon');
INSERT INTO `sys_dict` VALUES ('service', 'el-icon-service', 'icon');
INSERT INTO `sys_dict` VALUES ('mobile-phone', 'el-icon-mobile-phone', 'icon');
INSERT INTO `sys_dict` VALUES ('bicycle', 'el-icon-bicycle', 'icon');
INSERT INTO `sys_dict` VALUES ('truck', 'el-icon-truck', 'icon');
INSERT INTO `sys_dict` VALUES ('ship', 'el-icon-ship', 'icon');
INSERT INTO `sys_dict` VALUES ('basketball', 'el-icon-basketball', 'icon');
INSERT INTO `sys_dict` VALUES ('football', 'el-icon-football', 'icon');
INSERT INTO `sys_dict` VALUES ('soccer', 'el-icon-soccer', 'icon');
INSERT INTO `sys_dict` VALUES ('baseball', 'el-icon-baseball', 'icon');
INSERT INTO `sys_dict` VALUES ('wind-power', 'el-icon-wind-power', 'icon');
INSERT INTO `sys_dict` VALUES ('light-rain', 'el-icon-light-rain', 'icon');
INSERT INTO `sys_dict` VALUES ('lightning', 'el-icon-lightning', 'icon');
INSERT INTO `sys_dict` VALUES ('heavy-rain', 'el-icon-heavy-rain', 'icon');
INSERT INTO `sys_dict` VALUES ('sunrise', 'el-icon-sunrise', 'icon');
INSERT INTO `sys_dict` VALUES ('sunrise-1', 'el-icon-sunrise-1', 'icon');
INSERT INTO `sys_dict` VALUES ('sunset', 'el-icon-sunset', 'icon');
INSERT INTO `sys_dict` VALUES ('sunny', 'el-icon-sunny', 'icon');
INSERT INTO `sys_dict` VALUES ('cloudy', 'el-icon-cloudy', 'icon');
INSERT INTO `sys_dict` VALUES ('partly-cloudy', 'el-icon-partly-cloudy', 'icon');
INSERT INTO `sys_dict` VALUES ('cloudy-and-sunny', 'el-icon-cloudy-and-sunny', 'icon');
INSERT INTO `sys_dict` VALUES ('moon', 'el-icon-moon', 'icon');
INSERT INTO `sys_dict` VALUES ('moon-night', 'el-icon-moon-night', 'icon');
INSERT INTO `sys_dict` VALUES ('dish', 'el-icon-dish', 'icon');
INSERT INTO `sys_dict` VALUES ('dish-1', 'el-icon-dish-1', 'icon');
INSERT INTO `sys_dict` VALUES ('food', 'el-icon-food', 'icon');
INSERT INTO `sys_dict` VALUES ('chicken', 'el-icon-chicken', 'icon');
INSERT INTO `sys_dict` VALUES ('fork-spoon', 'el-icon-fork-spoon', 'icon');
INSERT INTO `sys_dict` VALUES ('knife-fork', 'el-icon-knife-fork', 'icon');
INSERT INTO `sys_dict` VALUES ('burger', 'el-icon-burger', 'icon');
INSERT INTO `sys_dict` VALUES ('tableware', 'el-icon-tableware', 'icon');
INSERT INTO `sys_dict` VALUES ('sugar', 'el-icon-sugar', 'icon');
INSERT INTO `sys_dict` VALUES ('dessert', 'el-icon-dessert', 'icon');
INSERT INTO `sys_dict` VALUES ('ice-cream', 'el-icon-ice-cream', 'icon');
INSERT INTO `sys_dict` VALUES ('hot-water', 'el-icon-hot-water', 'icon');
INSERT INTO `sys_dict` VALUES ('water-cup', 'el-icon-water-cup', 'icon');
INSERT INTO `sys_dict` VALUES ('coffee-cup', 'el-icon-coffee-cup', 'icon');
INSERT INTO `sys_dict` VALUES ('cold-drink', 'el-icon-cold-drink', 'icon');
INSERT INTO `sys_dict` VALUES ('goblet', 'el-icon-goblet', 'icon');
INSERT INTO `sys_dict` VALUES ('goblet-full', 'el-icon-goblet-full', 'icon');
INSERT INTO `sys_dict` VALUES ('goblet-square', 'el-icon-goblet-square', 'icon');
INSERT INTO `sys_dict` VALUES ('goblet-square-full', 'el-icon-goblet-square-full', 'icon');
INSERT INTO `sys_dict` VALUES ('refrigerator', 'el-icon-refrigerator', 'icon');
INSERT INTO `sys_dict` VALUES ('grape', 'el-icon-grape', 'icon');
INSERT INTO `sys_dict` VALUES ('watermelon', 'el-icon-watermelon', 'icon');
INSERT INTO `sys_dict` VALUES ('cherry', 'el-icon-cherry', 'icon');
INSERT INTO `sys_dict` VALUES ('apple', 'el-icon-apple', 'icon');
INSERT INTO `sys_dict` VALUES ('pear', 'el-icon-pear', 'icon');
INSERT INTO `sys_dict` VALUES ('orange', 'el-icon-orange', 'icon');
INSERT INTO `sys_dict` VALUES ('coffee', 'el-icon-coffee', 'icon');
INSERT INTO `sys_dict` VALUES ('ice-tea', 'el-icon-ice-tea', 'icon');
INSERT INTO `sys_dict` VALUES ('ice-drink', 'el-icon-ice-drink', 'icon');
INSERT INTO `sys_dict` VALUES ('milk-tea', 'el-icon-milk-tea', 'icon');
INSERT INTO `sys_dict` VALUES ('potato-strips', 'el-icon-potato-strips', 'icon');
INSERT INTO `sys_dict` VALUES ('lollipop', 'el-icon-lollipop', 'icon');
INSERT INTO `sys_dict` VALUES ('ice-cream-square', 'el-icon-ice-cream-square', 'icon');
INSERT INTO `sys_dict` VALUES ('ice-cream-round', 'el-icon-ice-cream-round', 'icon');

-- ----------------------------
-- Table structure for sys_file
-- ----------------------------
DROP TABLE IF EXISTS `sys_file`;
CREATE TABLE `sys_file`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件名称',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件类型',
  `size` bigint NULL DEFAULT NULL COMMENT '文件大小(kb)',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '下载链接',
  `md5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件md5',
  `is_delete` tinyint(1) NULL DEFAULT 0 COMMENT '是否删除',
  `enable` tinyint(1) NULL DEFAULT 1 COMMENT '是否禁用链接',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_file
-- ----------------------------
INSERT INTO `sys_file` VALUES (47, '嗷嗷哭小黄脸.jpg', 'jpg', 268, 'http://localhost:9090/file/c393b5113a884b13a3d0717bc7dc29c7.jpg', '68f14457fdb1a50c09f1fadb0acadbde', 0, 1);
INSERT INTO `sys_file` VALUES (48, '31e73e1332e9ae044deb39aa2129a3e3.jpeg', 'jpeg', 20, 'http://localhost:9090/file/dc7e8c25021e47598f9bc7b1daa71a6d.jpeg', '4dd3cf90d865bb6d16fb76cd702703c5', 0, 1);
INSERT INTO `sys_file` VALUES (49, '06b26fb6ac35e6bea62cfd3c38de9548.jpeg', 'jpeg', 260, 'http://localhost:9090/file/29b047221f72435ea6d46b945a0b9410.jpeg', '54a13a266cb920d8d0a56bdaf5091136', 0, 1);
INSERT INTO `sys_file` VALUES (50, '自行车.jpg', 'jpg', 198, 'http://localhost:9090/file/f3c4434a9b124f68ad83812cb999f469.jpg', '08832ab1500f5dfe85b0eeabcd45687c', 0, 1);
INSERT INTO `sys_file` VALUES (51, '4922e64fcd822195346eb1f056396f30.jpeg', 'jpeg', 33, 'http://localhost:9090/file/a87ec4cf0435437da68ee9eb94ecc8b4.jpeg', '90efaa500fac9fb3052ae99ff5e7eab9', 0, 1);
INSERT INTO `sys_file` VALUES (52, '自行车.jpg', 'jpg', 198, 'http://localhost:9090/file/f3c4434a9b124f68ad83812cb999f469.jpg', '08832ab1500f5dfe85b0eeabcd45687c', 0, 1);
INSERT INTO `sys_file` VALUES (53, '自行车.jpg', 'jpg', 198, 'http://localhost:9090/file/f3c4434a9b124f68ad83812cb999f469.jpg', '08832ab1500f5dfe85b0eeabcd45687c', 0, 1);
INSERT INTO `sys_file` VALUES (54, '4dedf65c1ede82a6dbaae4beefa9d324.jpg', 'jpg', 335, 'http://localhost:9090/file/0a058f5ca96f41f58d072ca69bb6ff06.jpg', 'd224aa67ac1be9fdf21e4a9319f0ba87', 0, 1);

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '路径',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图标',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `pid` int NULL DEFAULT NULL COMMENT '父级id',
  `page_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '页面路径',
  `sort_num` int NULL DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (2, '数据报表', '/back/dashbord', 'el-icon-s-marketing', '11', NULL, 'Dashbord', 100);
INSERT INTO `sys_menu` VALUES (4, '系统管理', NULL, 'el-icon-s-grid', NULL, NULL, NULL, 300);
INSERT INTO `sys_menu` VALUES (5, '用户管理', '/back/user', 'el-icon-user', NULL, 4, 'systemManage/User', 301);
INSERT INTO `sys_menu` VALUES (6, '角色管理', '/back/role', 'el-icon-s-custom', NULL, 4, 'systemManage/Role', 302);
INSERT INTO `sys_menu` VALUES (7, '菜单管理', '/back/menu', 'el-icon-menu', NULL, 4, 'systemManage/Menu', 303);
INSERT INTO `sys_menu` VALUES (8, '文件管理', '/back/file', 'el-icon-document', NULL, 4, 'systemManage/File', 304);
INSERT INTO `sys_menu` VALUES (9, '请作者喝杯咖啡', '/back/donate', 'el-icon-coffee\r\n', NULL, NULL, 'Donate', 200);
INSERT INTO `sys_menu` VALUES (10, '主页', '/back', 'el-icon-house', NULL, NULL, 'Home', 0);
INSERT INTO `sys_menu` VALUES (39, '课程管理', '/back/course', 'el-icon-menu', NULL, NULL, 'Course', 201);
INSERT INTO `sys_menu` VALUES (40, '高德地图', '/back/map', 'el-icon-house', NULL, NULL, 'Map', 999);
INSERT INTO `sys_menu` VALUES (41, '文章管理', '/back/article', 'el-icon-menu', NULL, NULL, 'Article', 999);
INSERT INTO `sys_menu` VALUES (42, '级联查询', '/back/building', 'el-icon-menu', NULL, NULL, 'Building', 999);
INSERT INTO `sys_menu` VALUES (44, '专业管理', '/back/major', 'el-icon-s-order', NULL, NULL, 'Major', 222);
INSERT INTO `sys_menu` VALUES (45, '课程管理', '/back/coursemanager', 'el-icon-remove-outline', NULL, NULL, 'CourseManage', 223);
INSERT INTO `sys_menu` VALUES (46, '学生管理', '/back/student', 'el-icon-circle-close', NULL, NULL, 'Student', 224);
INSERT INTO `sys_menu` VALUES (47, '课程表', '/back/courseTable', 'el-icon-delete', NULL, NULL, 'CourseTable', 225);
INSERT INTO `sys_menu` VALUES (48, '工作流节点', '/back/node', 'el-icon-copy-document', NULL, NULL, 'Node', 123);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `flag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '唯一标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '管理员', '管理员', 'ROLE_ADMIN');
INSERT INTO `sys_role` VALUES (2, '学生', '学生', 'ROLE_STUDENT');
INSERT INTO `sys_role` VALUES (3, '老师', '老师', 'ROLE_TEACHER');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` int NOT NULL COMMENT '角色id',
  `menu_id` int NOT NULL COMMENT '菜单id',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色菜单关系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 4);
INSERT INTO `sys_role_menu` VALUES (1, 5);
INSERT INTO `sys_role_menu` VALUES (1, 6);
INSERT INTO `sys_role_menu` VALUES (1, 7);
INSERT INTO `sys_role_menu` VALUES (1, 8);
INSERT INTO `sys_role_menu` VALUES (1, 10);
INSERT INTO `sys_role_menu` VALUES (1, 48);
INSERT INTO `sys_role_menu` VALUES (3, 2);
INSERT INTO `sys_role_menu` VALUES (3, 10);
INSERT INTO `sys_role_menu` VALUES (3, 39);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', 'admin', '程序员青戈', 'admin@qq.com', '13988997788', '', '2022-01-22 21:10:27', 'http://localhost:9090/file/29b047221f72435ea6d46b945a0b9410.jpeg', 'ROLE_ADMIN');
INSERT INTO `sys_user` VALUES (16, '222', '202cb962ac59075b964b07152d234b70', '甄姬好大', '2', '2', '2', '2022-02-26 22:10:14', NULL, 'ROLE_TEACHER');
INSERT INTO `sys_user` VALUES (17, '333', '202cb962ac59075b964b07152d234b70', '我是三三哦豁', '3', '3', '3', '2022-02-26 22:10:18', 'http://localhost:9090/file/7737484487db47ab89e58504ddf86ac1.jpg', 'ROLE_TEACHER');
INSERT INTO `sys_user` VALUES (18, 'nzz', '202cb962ac59075b964b07152d234b70', '哪吒', '2', '2', '2', '2022-03-29 16:59:44', '', 'ROLE_STUDENT');
INSERT INTO `sys_user` VALUES (19, 'yss', '202cb962ac59075b964b07152d234b70', '亚瑟', '3', '3', '3', '2022-04-29 16:59:44', '', 'ROLE_STUDENT');
INSERT INTO `sys_user` VALUES (20, 'lxx', '202cb962ac59075b964b07152d234b70', '李信', '2', '2', '2', '2022-05-29 17:12:04', '2', 'ROLE_STUDENT');
INSERT INTO `sys_user` VALUES (25, 'sir', '202cb962ac59075b964b07152d234b70', '安琪拉', NULL, NULL, NULL, '2022-06-08 17:00:47', NULL, 'ROLE_STUDENT');
INSERT INTO `sys_user` VALUES (26, 'err', '202cb962ac59075b964b07152d234b70', '妲己', '11', '1', '1', '2022-07-08 17:20:01', NULL, 'ROLE_STUDENT');
INSERT INTO `sys_user` VALUES (28, 'ddd', '202cb962ac59075b964b07152d234b70', 'ddd', '', '', '', '2022-11-09 10:41:07', 'http://localhost:9090/file/7de0e50f915547539db12023cf997276.jpg', 'ROLE_STUDENT');
INSERT INTO `sys_user` VALUES (29, 'ffff', '202cb962ac59075b964b07152d234b70', 'ffff', NULL, NULL, NULL, '2022-12-10 11:53:31', NULL, 'ROLE_STUDENT');
INSERT INTO `sys_user` VALUES (30, 'xiaobai', '202cb962ac59075b964b07152d234b70', 'xiaobai', NULL, NULL, NULL, '2022-05-23 14:43:08', NULL, 'ROLE_STUDENT');

SET FOREIGN_KEY_CHECKS = 1;
