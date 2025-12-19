-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.4.5 - MySQL Community Server - GPL
-- Server OS:                    Linux
-- HeidiSQL Version:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for sport
CREATE DATABASE IF NOT EXISTS `sport` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `sport`;

-- Dumping structure for table sport.authtoken_token
CREATE TABLE IF NOT EXISTS `authtoken_token` (
  `key` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `created` datetime(6) NOT NULL,
  `user_id` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `authtoken_token_user_id_35299eff_fk_employee_account_username` FOREIGN KEY (`user_id`) REFERENCES `employee_account` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.authtoken_token: ~0 rows (approximately)

-- Dumping structure for table sport.auth_group
CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.auth_group: ~0 rows (approximately)

-- Dumping structure for table sport.auth_group_permissions
CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.auth_group_permissions: ~0 rows (approximately)

-- Dumping structure for table sport.auth_permission
CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.auth_permission: ~120 rows (approximately)
INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
	(1, 'Can add log entry', 1, 'add_logentry'),
	(2, 'Can change log entry', 1, 'change_logentry'),
	(3, 'Can delete log entry', 1, 'delete_logentry'),
	(4, 'Can view log entry', 1, 'view_logentry'),
	(5, 'Can add permission', 2, 'add_permission'),
	(6, 'Can change permission', 2, 'change_permission'),
	(7, 'Can delete permission', 2, 'delete_permission'),
	(8, 'Can view permission', 2, 'view_permission'),
	(9, 'Can add group', 3, 'add_group'),
	(10, 'Can change group', 3, 'change_group'),
	(11, 'Can delete group', 3, 'delete_group'),
	(12, 'Can view group', 3, 'view_group'),
	(13, 'Can add content type', 4, 'add_contenttype'),
	(14, 'Can change content type', 4, 'change_contenttype'),
	(15, 'Can delete content type', 4, 'delete_contenttype'),
	(16, 'Can view content type', 4, 'view_contenttype'),
	(17, 'Can add session', 5, 'add_session'),
	(18, 'Can change session', 5, 'change_session'),
	(19, 'Can delete session', 5, 'delete_session'),
	(20, 'Can view session', 5, 'view_session'),
	(21, 'Can add Token', 6, 'add_token'),
	(22, 'Can change Token', 6, 'change_token'),
	(23, 'Can delete Token', 6, 'delete_token'),
	(24, 'Can view Token', 6, 'view_token'),
	(25, 'Can add Token', 7, 'add_tokenproxy'),
	(26, 'Can change Token', 7, 'change_tokenproxy'),
	(27, 'Can delete Token', 7, 'delete_tokenproxy'),
	(28, 'Can view Token', 7, 'view_tokenproxy'),
	(29, 'Can add completed task', 8, 'add_completedtask'),
	(30, 'Can change completed task', 8, 'change_completedtask'),
	(31, 'Can delete completed task', 8, 'delete_completedtask'),
	(32, 'Can view completed task', 8, 'view_completedtask'),
	(33, 'Can add task', 9, 'add_task'),
	(34, 'Can change task', 9, 'change_task'),
	(35, 'Can delete task', 9, 'delete_task'),
	(36, 'Can view task', 9, 'view_task'),
	(37, 'Can add customer', 10, 'add_customer'),
	(38, 'Can change customer', 10, 'change_customer'),
	(39, 'Can delete customer', 10, 'delete_customer'),
	(40, 'Can view customer', 10, 'view_customer'),
	(41, 'Can add employee', 11, 'add_employee'),
	(42, 'Can change employee', 11, 'change_employee'),
	(43, 'Can delete employee', 11, 'delete_employee'),
	(44, 'Can view employee', 11, 'view_employee'),
	(45, 'Can add customer account', 12, 'add_customeraccount'),
	(46, 'Can change customer account', 12, 'change_customeraccount'),
	(47, 'Can delete customer account', 12, 'delete_customeraccount'),
	(48, 'Can view customer account', 12, 'view_customeraccount'),
	(49, 'Can add employee account', 13, 'add_employeeaccount'),
	(50, 'Can change employee account', 13, 'change_employeeaccount'),
	(51, 'Can delete employee account', 13, 'delete_employeeaccount'),
	(52, 'Can view employee account', 13, 'view_employeeaccount'),
	(53, 'Can add league', 14, 'add_league'),
	(54, 'Can change league', 14, 'change_league'),
	(55, 'Can delete league', 14, 'delete_league'),
	(56, 'Can view league', 14, 'view_league'),
	(57, 'Can add match', 15, 'add_match'),
	(58, 'Can change match', 15, 'change_match'),
	(59, 'Can delete match', 15, 'delete_match'),
	(60, 'Can view match', 15, 'view_match'),
	(61, 'Can add sport', 16, 'add_sport'),
	(62, 'Can change sport', 16, 'change_sport'),
	(63, 'Can delete sport', 16, 'delete_sport'),
	(64, 'Can view sport', 16, 'view_sport'),
	(65, 'Can add stadium', 17, 'add_stadium'),
	(66, 'Can change stadium', 17, 'change_stadium'),
	(67, 'Can delete stadium', 17, 'delete_stadium'),
	(68, 'Can view stadium', 17, 'view_stadium'),
	(69, 'Can add team', 18, 'add_team'),
	(70, 'Can change team', 18, 'change_team'),
	(71, 'Can delete team', 18, 'delete_team'),
	(72, 'Can view team', 18, 'view_team'),
	(73, 'Can add match history', 19, 'add_matchhistory'),
	(74, 'Can change match history', 19, 'change_matchhistory'),
	(75, 'Can delete match history', 19, 'delete_matchhistory'),
	(76, 'Can view match history', 19, 'view_matchhistory'),
	(77, 'Can add section', 20, 'add_section'),
	(78, 'Can change section', 20, 'change_section'),
	(79, 'Can delete section', 20, 'delete_section'),
	(80, 'Can view section', 20, 'view_section'),
	(81, 'Can add section price', 21, 'add_sectionprice'),
	(82, 'Can change section price', 21, 'change_sectionprice'),
	(83, 'Can delete section price', 21, 'delete_sectionprice'),
	(84, 'Can view section price', 21, 'view_sectionprice'),
	(85, 'Can add seat', 22, 'add_seat'),
	(86, 'Can change seat', 22, 'change_seat'),
	(87, 'Can delete seat', 22, 'delete_seat'),
	(88, 'Can view seat', 22, 'view_seat'),
	(89, 'Can add price history', 23, 'add_pricehistory'),
	(90, 'Can change price history', 23, 'change_pricehistory'),
	(91, 'Can delete price history', 23, 'delete_pricehistory'),
	(92, 'Can view price history', 23, 'view_pricehistory'),
	(93, 'Can add order', 24, 'add_order'),
	(94, 'Can change order', 24, 'change_order'),
	(95, 'Can delete order', 24, 'delete_order'),
	(96, 'Can view order', 24, 'view_order'),
	(97, 'Can add payment', 25, 'add_payment'),
	(98, 'Can change payment', 25, 'change_payment'),
	(99, 'Can delete payment', 25, 'delete_payment'),
	(100, 'Can view payment', 25, 'view_payment'),
	(101, 'Can add order detail', 26, 'add_orderdetail'),
	(102, 'Can change order detail', 26, 'change_orderdetail'),
	(103, 'Can delete order detail', 26, 'delete_orderdetail'),
	(104, 'Can view order detail', 26, 'view_orderdetail'),
	(105, 'Can add promotion', 27, 'add_promotion'),
	(106, 'Can change promotion', 27, 'change_promotion'),
	(107, 'Can delete promotion', 27, 'delete_promotion'),
	(108, 'Can view promotion', 27, 'view_promotion'),
	(109, 'Can add promotion detail', 28, 'add_promotiondetail'),
	(110, 'Can change promotion detail', 28, 'change_promotiondetail'),
	(111, 'Can delete promotion detail', 28, 'delete_promotiondetail'),
	(112, 'Can view promotion detail', 28, 'view_promotiondetail'),
	(113, 'Can add ticket return', 29, 'add_ticketreturn'),
	(114, 'Can change ticket return', 29, 'change_ticketreturn'),
	(115, 'Can delete ticket return', 29, 'delete_ticketreturn'),
	(116, 'Can view ticket return', 29, 'view_ticketreturn'),
	(117, 'Can add chat history', 30, 'add_chathistory'),
	(118, 'Can change chat history', 30, 'change_chathistory'),
	(119, 'Can delete chat history', 30, 'delete_chathistory'),
	(120, 'Can view chat history', 30, 'view_chathistory');

-- Dumping structure for table sport.background_task
CREATE TABLE IF NOT EXISTS `background_task` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_name` varchar(190) COLLATE utf8mb4_general_ci NOT NULL,
  `task_params` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `task_hash` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `verbose_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `priority` int NOT NULL,
  `run_at` datetime(6) NOT NULL,
  `repeat` bigint NOT NULL,
  `repeat_until` datetime(6) DEFAULT NULL,
  `queue` varchar(190) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `attempts` int NOT NULL,
  `failed_at` datetime(6) DEFAULT NULL,
  `last_error` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `locked_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `locked_at` datetime(6) DEFAULT NULL,
  `creator_object_id` int unsigned DEFAULT NULL,
  `creator_content_type_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `background_task_creator_content_type_61cc9af3_fk_django_co` (`creator_content_type_id`),
  KEY `background_task_task_name_4562d56a` (`task_name`),
  KEY `background_task_task_hash_d8f233bd` (`task_hash`),
  KEY `background_task_priority_88bdbce9` (`priority`),
  KEY `background_task_run_at_7baca3aa` (`run_at`),
  KEY `background_task_queue_1d5f3a40` (`queue`),
  KEY `background_task_attempts_a9ade23d` (`attempts`),
  KEY `background_task_failed_at_b81bba14` (`failed_at`),
  KEY `background_task_locked_by_db7779e3` (`locked_by`),
  KEY `background_task_locked_at_0fb0f225` (`locked_at`),
  CONSTRAINT `background_task_creator_content_type_61cc9af3_fk_django_co` FOREIGN KEY (`creator_content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `background_task_chk_1` CHECK ((`creator_object_id` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.background_task: ~0 rows (approximately)

-- Dumping structure for table sport.background_task_completedtask
CREATE TABLE IF NOT EXISTS `background_task_completedtask` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_name` varchar(190) COLLATE utf8mb4_general_ci NOT NULL,
  `task_params` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `task_hash` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `verbose_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `priority` int NOT NULL,
  `run_at` datetime(6) NOT NULL,
  `repeat` bigint NOT NULL,
  `repeat_until` datetime(6) DEFAULT NULL,
  `queue` varchar(190) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `attempts` int NOT NULL,
  `failed_at` datetime(6) DEFAULT NULL,
  `last_error` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `locked_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `locked_at` datetime(6) DEFAULT NULL,
  `creator_object_id` int unsigned DEFAULT NULL,
  `creator_content_type_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `background_task_comp_creator_content_type_21d6a741_fk_django_co` (`creator_content_type_id`),
  KEY `background_task_completedtask_task_name_388dabc2` (`task_name`),
  KEY `background_task_completedtask_task_hash_91187576` (`task_hash`),
  KEY `background_task_completedtask_priority_9080692e` (`priority`),
  KEY `background_task_completedtask_run_at_77c80f34` (`run_at`),
  KEY `background_task_completedtask_queue_61fb0415` (`queue`),
  KEY `background_task_completedtask_attempts_772a6783` (`attempts`),
  KEY `background_task_completedtask_failed_at_3de56618` (`failed_at`),
  KEY `background_task_completedtask_locked_by_edc8a213` (`locked_by`),
  KEY `background_task_completedtask_locked_at_29c62708` (`locked_at`),
  CONSTRAINT `background_task_comp_creator_content_type_21d6a741_fk_django_co` FOREIGN KEY (`creator_content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `background_task_completedtask_chk_1` CHECK ((`creator_object_id` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.background_task_completedtask: ~0 rows (approximately)

-- Dumping structure for table sport.chat_history
CREATE TABLE IF NOT EXISTS `chat_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_message` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `bot_response` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `session_id` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `customer_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_history_customer_id_66eee622_fk_customer_id` (`customer_id`),
  CONSTRAINT `chat_history_customer_id_66eee622_fk_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.chat_history: ~18 rows (approximately)
INSERT INTO `chat_history` (`id`, `user_message`, `bot_response`, `created_at`, `session_id`, `customer_id`) VALUES
	(1, 'alo', 'Xin chào! Bạn muốn biết thông tin về vé thể thao hay muốn mua vé cho một trận đấu thú vị?', '2025-12-04 05:03:53.584547', 'frontend-test', 1),
	(2, 'bạn có link không', 'Đúng vậy! Chúng tôi có link để bạn xem thông tin vé và đặt vé cho các trận đấu thú vị.\n\nBạn có thể truy cập vào các đường link sau để xem thông tin về vé:\n\n- Trận Real Madrid vs Barcelona: http://localhost:5500/match/4\n- Trận Liverpool vs Manchester United: http://localhost:5500/match/2\n\nNếu bạn muốn đặt vé, vui lòng click vào đường link tương ứng và chúng tôi sẽ hướng dẫn bạn tiếp theo!', '2025-12-04 05:05:16.934320', 'frontend-test', 1),
	(3, 'tôi muốn đặt vé trận manchester united', 'Trận đấu giữa Liverpool vs Manchester United là một trận đấu thú vị!\n\nBạn có thể xem thông tin về vé cho trận đấu này tại đường link sau: http://localhost:5500/match/2\n\nĐây là thông tin về vé cho trận đấu này:\n\n- Giải: Premier League (Football)\n- Trận đấu: Liverpool vs Manchester United\n- Thời gian: 20:00 ngày 20/12/2025\n- Khu vực ngồi: Bạn có thể chọn giữa khu vực A, B, hoặc C\n- Giá vé: 150đ (khu vực A), 120đ (khu vực B), hoặc 90đ (khu vực C)\n\nCòn bao nhiêu vé? Khu vực A còn 14000 chỗ, khu vực B còn 17000 chỗ, khu vực C còn 19000 chỗ.\n\nĐể đặt vé, bạn có thể click vào đường link trên và chúng tôi sẽ hướng dẫn bạn tiếp theo!', '2025-12-04 05:06:17.252296', 'frontend-test', 1),
	(4, 'có vé trận manchester không', 'Vé trận Liverpool vs Manchester United đang có sẵn!\n\nChúng ta có 3 khu vực để chọn:\n\n* Khu vực A: Giá vé 150đ, vẫn còn vé. Số chỗ còn lại: 14000\n* Khu vực B: Giá vé 120đ, vẫn còn vé. Số chỗ còn lại: 17000\n* Khu vực C: Giá vé 90đ, vẫn còn vé. Số chỗ còn lại: 19000\n\nBạn muốn đặt vé cho trận Liverpool vs Manchester United không? Nếu có, tôi có thể đưa bạn đến trang đặt vé. Vui lòng chọn khu vực mong muốn và số vé bạn muốn đặt!\n\nNếu bạn muốn đặt vé cho khu vực A: http://localhost:5500/match/2\nNếu bạn muốn đặt vé cho khu vực B: http://localhost:5500/match/2\nNếu bạn muốn đặt vé cho khu vực C: http://localhost:5500/match/2\n\nHãy cho tôi biết bạn muốn gì!', '2025-12-07 08:48:52.259653', 'frontend-session-1765097292232', 1),
	(5, 'tôi muốn mua khu vực A', 'Bạn đã chọn khu vực A!\n\nTại khu vực A, giá vé là 150đ và vẫn còn 14000 chỗ. Bạn có thể đặt vé theo yêu cầu của mình.\n\nTôi sẽ đưa bạn đến trang đặt vé của trận Liverpool vs Manchester United - khu vực A.\n\n**Trang đặt vé khu vực A:**\nhttp://localhost:5500/match/2#khu-vuc-a\n\nTại trang này, bạn có thể chọn số lượng vé và đặt vé. Hãy làm theo hướng dẫn trên trang để hoàn tất quá trình đặt vé.\n\nChúc bạn có một trải nghiệm thú vị tại trận Liverpool vs Manchester United!', '2025-12-07 08:49:37.994169', 'frontend-session-1765097292232', 1),
	(6, 'rẻ thé', 'Vé khu vực A của trận Liverpool vs Manchester United không rẻ nhất.\n\nNếu bạn muốn giá vé rẻ hơn, bạn có thể xem xét khu vực B hoặc khu vực C.\n\n* Khu vực B: Giá vé 120đ, vẫn còn 17000 chỗ\n* Khu vực C: Giá vé 90đ, vẫn còn 19000 chỗ\n\nBạn có muốn xem chi tiết vé ở khu vực B hoặc C không?\n\nNếu bạn muốn xem chi tiết vé ở khu vực B: http://localhost:5500/match/2#khu-vuc-b\nNếu bạn muốn xem chi tiết vé ở khu vực C: http://localhost:5500/match/2#khu-vuc-c\n\nHãy cho tôi biết bạn muốn gì!', '2025-12-07 08:50:12.627397', 'frontend-session-1765097292232', 1),
	(7, 'alo', 'Xin chào! Bạn muốn đặt vé cho một trận thể thao nào không? Hiện tại, chúng tôi đang hỗ trợ đặt vé cho các trận đấu sau:\n\n- Giải Premier League (Football): Trận Liverpool vs Manchester United (20:00, 20/12/2025)\n- Giải La Liga (Football): Trận Real Madrid vs Barcelona (21:00, 10/12/2025)\n\nBạn đã biết trận đấu mong muốn mình chưa?', '2025-12-07 08:51:28.574584', 'frontend-session-1765097465138', 1),
	(8, 'tôi muốn đặt vé trận manchester', 'Bạn muốn đặt vé trận Liverpool vs Manchester United?\n\nTôi có nhiều lựa chọn vé cho bạn:\n\n- Vé khu vực A, giá 150đ, còn 14000 chỗ.\n- Vé khu vực B, giá 120đ, còn 17000 chỗ.\n- Vé khu vực C, giá 90đ, còn 19000 chỗ.\n\nBạn muốn biết thêm thông tin về vé trước khi đặt? Hãy chọn khu vực vé phù hợp với mình tại trang https://nguyenminhduc123.com:5500/match/2', '2025-12-07 08:57:04.507023', 'frontend-session-1765097730631', 1),
	(9, 'alo', 'Xin chào! Bạn cần tìm hiểu thông tin về vé thể thao hay muốn đặt mua vé cho một trận đấu nào đó? Tất cả thông tin về vé thể thao hiện có bao gồm:\n\n- match_id 2: Giải Premier League (Football), Trận Liverpool vs Manchester United\n  - Khu vực A: Giá vé 150đ, còn 14000 chỗ\n  - Khu vực B: Giá vé 120đ, còn 17000 chỗ\n\n- match_id 4: Giải La Liga (Football), Trận Real Madrid vs Barcelona\n  - Khu vực B: Giá vé 120đ, còn 17000 chỗ\n\nXin hãy cho tôi biết bạn cần cái gì để tôi có thể hỗ trợ bạn tốt nhất có thể.', '2025-12-07 08:58:14.497454', 'frontend-session-1765097838483', 1),
	(10, 'có trận manchester không', 'Trận đấu mà bạn đang tìm kiếm là trận Liverpool vs Manchester United. Đây là một trận đấu quan trọng của giải Premier League (Football).\n\nDưới đây là thông tin chi tiết về trận đấu này:\n\n- Giải: Premier League (Football)\n- Trận đấu: Liverpool vs Manchester United\n- Thời gian: 20:00, 20/12/2025\n- Khu vực:\n + Khu vực A: Giá vé 150đ, còn 14000 chỗ. Bạn có thể xem chi tiết thông tin và đặt vé tại đây: http://localhost:5500/match/2\n + Khu vực B: Giá vé 120đ, còn 17000 chỗ. Bạn có thể xem chi tiết thông tin và đặt vé tại đây: http://localhost:5500/match/2\n\nBạn muốn biết thêm thông tin về trận đấu này hay muốn đặt vé cho một khu vực cụ thể?', '2025-12-07 08:58:30.623105', 'frontend-session-1765097838483', 1),
	(11, 'có vé trận mu không', 'Dữ liệu tại thời điểm hiện tại cho thấy còn vé trận đấu giữa Real Madrid vs Barcelona và Liverpool vs Manchester United. \n\nBạn có muốn đặt vé cho trận đấu nào không? \n\n- Trận Real Madrid vs Barcelona có vé ở Khu vực A (150đ) và Khu vực B (120đ). \n- Trận Liverpool vs Manchester United có vé ở Khu vực A (150đ). \n\nĐể liên hệ xem chi tiết vé và đặt vé, vui lòng nhấn vào đường dẫn sau:\nhttp://localhost:5500/match/4\n\nHoặc: \nhttp://localhost:5500/match/2 \n\nNếu bạn cần đặt vé, vui lòng nhấn vào đường dẫn trên.', '2025-12-07 09:02:07.666727', 'frontend-session-1765098116293', 1),
	(12, 'có vé trận mu không', 'Để biết tình hình vé cho trận Real Madrid vs Barcelona, tôi có thể giúp bạn kiểm tra thông tin. Bạn có muốn xem chi tiết về vé trận này không?\n\nNếu muốn, bạn có thể click vào đường dẫn để xem chi tiết: \nhttp://localhost:5500/match/4', '2025-12-07 09:02:49.951752', 'frontend-session-1765098157730', 1),
	(13, 'có vé trận manchester united không', 'Bạn đang tìm kiếm thông tin về trận Liverpool vs Manchester United.\n\nCó vé cho trận này. Vé được bán ở 3 khu vực khác nhau với giá mỗi khu vực khác nhau.\n\nBạn muốn biết thêm thông tin về vé của trận này không?\n\nKhu vực A: Giá 150đ | Còn vé | Còn 14000 chỗ\nKhu vực B: Giá 120đ | Còn vé | Còn 17000 chỗ\nKhu vực C: Giá 90đ | Còn vé | Còn 19000 chỗ\n\nBạn cũng có thể click vào đường dẫn để xem chi tiết: \nhttp://localhost:5500/match/2\n\nBạn muốn đặt mua vé không?\n\nNếu muốn, bạn có thể click vào đường dẫn tương ứng với khu vực bạn muốn mua: \n- http://localhost:5500/match/2/khu-vuc-a (Khu vực A)\n- http://localhost:5500/match/2/khu-vuc-b (Khu vực B)\n- http://localhost:5500/match/2/khu-vuc-c (Khu vực C)', '2025-12-07 09:03:41.418986', 'frontend-session-1765098157730', 1),
	(14, 'có vé trận manchester không', 'Để kiểm tra tình trạng vé cho trận đấu giữa Liverpool vs Manchester United, bạn có thể xem thông tin về trận đấu sau:\n\n* Thời gian: 20:00, 20/12/2025\n* Giải đấu: Premier League (Football)\n\nVề việc còn vé cho khu vực nào, mình xin lỗi vì thông tin không được cập nhật liên tục, bạn có thể tham khảo thông tin hiện tại:\n\n- Khu vực A: Giá 150đ, còn vé, còn 14000 chỗ\n- Khu vực B: Giá 120đ, còn vé, còn 17000 chỗ\n- Khu vực C: Giá 90đ, còn vé, còn 19000 chỗ\n\nNếu bạn muốn đặt khách sạn hoặc mua vé, bạn có thể truy cập trang web thông tin về trận đấu tại đường dẫn: http://localhost:5500/match/2', '2025-12-07 09:08:51.783609', 'frontend-session-1765098516954', 1),
	(15, 'có vé trận manchester không', 'Bạn đang muốn đặt vé cho trận Liverpool vs Manchester United!\n\nCó vé còn lại cho trận này. Bạn có thể chọn khu vực và giá vé phù hợp với mình.\n\nDưới đây là thông tin về vé cho trận này:\n\n- Khu vực A: 150đ, còn vé, còn 14000 chỗ: http://localhost:5500/match/2\n- Khu vực B: 120đ, còn vé, còn 17000 chỗ: http://localhost:5500/match/2\n- Khu vực C: 90đ, còn vé, còn 19000 chỗ: http://localhost:5500/match/2\n\nBạn chọn khu vực nào?', '2025-12-07 09:10:29.678549', 'frontend-session-1765098614725', 34),
	(16, 'tôi muốn đặt vé trận manchester unnited', 'Bạn muốn đặt vé cho trận Liverpool vs Manchester United?\n\nĐể đặt vé, vui lòng chọn khu vực và số lượng vé phù hợp với bạn. Sau đó, bạn sẽ được chuyển đến trang thanh toán để hoàn tất đơn đặt hàng.\n\nDưới đây là thông tin về vé cho trận này:\n\n- Khu vực A: 150đ, còn vé, còn 14000 chỗ: http://localhost:5500/match/2\n- Khu vực B: 120đ, còn vé, còn 17000 chỗ: http://localhost:5500/match/2\n- Khu vực C: 90đ, còn vé, còn 19000 chỗ: http://localhost:5500/match/2\n\nBạn muốn đặt vé cho khu vực nào?', '2025-12-07 09:20:20.018771', 'frontend-session-1765098614725', 34),
	(17, 'cho tôi xem vé trận manchester', 'Bạn muốn xem vé cho trận đấu giữa Manchester United và Liverpool nhé!\n\nCó 3 khu vực để chọn:\n- Khu vực A: Giá 150đ, còn vé, còn 14000 chỗ.\n- Khu vực B: Giá 120đ, còn vé, còn 17000 chỗ.\n- Khu vực C: Giá 90đ, còn vé, còn 19000 chỗ.\n\nBạn muốn xem chi tiết vé? \n\n- [View Match](http://localhost:5500/match/2)', '2025-12-07 09:21:51.451965', 'frontend-session-1765099251862', 34),
	(18, 'khu vực A đi', 'Bạn chọn khu vực A nhé!\n\nTrận đấu giữa Liverpool và Manchester United sẽ diễn ra vào lúc 20:00 ngày 20/12/2025, và bạn sẽ được ngồi ở khu vực A.\n\nGiá vé là 150đ, và còn 14000 chỗ trong khu vực này.\n\nNếu bạn muốn đặt vé ngay bây giờ, xin vui lòng click vào đường dẫn sau:\n\n- [Mua Vé](http://localhost:5500/match/2)', '2025-12-07 09:34:48.480789', 'frontend-session-1765099251862', 34),
	(19, 'tôi muốn mua vé trận manchester united', 'Xin chúc mừng! Bạn muốn mua vé cho trận đấu giữa Liverpool vs Manchester United!\n\nTôi có thông tin về 3 khu vực khác nhau để bạn lựa chọn:\n\n1. **Khu vực A**: Giá vé là 150.000 đồng và còn lại 14.000 chỗ.\n2. **Khu vực B**: Giá vé là 120.000 đồng và còn lại 17.000 chỗ.\n3. **Khu vực C**: Giá vé là 90.000 đồng và còn lại 19.000 chỗ.\n\nBạn có muốn xem chi tiết từng khu vực hoặc đặt vé trực tiếp không? Nếu muốn, bạn có thể truy cập đường dẫn dưới đây:\n\n1. Khu vực A: http://localhost:5500/match/2 (Đặt vé)\n2. Khu vực B: http://localhost:5500/match/2 (Đặt vé)\n3. Khu vực C: http://localhost:5500/match/2 (Đặt vé)\n\nHay bạn có yêu cầu hỗ trợ khác không?', '2025-12-07 11:24:45.953687', 'frontend-session-1765106571978', 34),
	(20, 'tôi muốn mua vé trận manchester united', 'Để đặt vé cho trận Liverpool vs Manchester United, bạn có thể chọn khu vực và số lượng vé mong muốn. \n\nDưới đây là các lựa chọn vé cho trận này:\n\n * Trận Liverpool vs Manchester United (Giải Premier League) - 20:00 20/12/2025\n + Khu vực A: Giá 150đ, Còn vé, Còn 14000 chỗ. Xem chi tiết và đặt vé **[http://localhost:5500/match/2](http://localhost:5500/match/2)**\n + Khu vực B: Giá 120đ, Còn vé, Còn 17000 chỗ. Xem chi tiết và đặt vé **[http://localhost:5500/match/2](http://localhost:5500/match/2)**\n + Khu vực C: Giá 90đ, Còn vé, Còn 19000 chỗ. Xem chi tiết và đặt vé **[http://localhost:5500/match/2](http://localhost:5500/match/2)**\n\nLựa chọn khu vực và số lượng vé của bạn là gì?', '2025-12-07 13:25:00.996055', 'frontend-session-1765113881301', 34),
	(21, 'tôi muốn mua vé trận manchester united', 'Bạn muốn mua vé cho trận Liverpool vs Manchester United đúng không? Vé này đang bán còn vài chỗ, với 3 khu vực khác nhau để bạn lựa chọn:\n\n- Khu vực A: Giá 150 đ, còn 14000 chỗ.\n- Khu vực B: Giá 120 đ, còn 17000 chỗ.\n- Khu vực C: Giá 90 đ, còn 19000 chỗ.\n\nBạn muốn chọn khu vực nào? Chọn để tôi giúp bạn đặt vé!\n\n[Chọn khu vực A](http://localhost:5500/match/2#khu-vuc-A)\n[Chọn khu vực B](http://localhost:5500/match/2#khu-vuc-B)\n[Chọn khu vực C](http://localhost:5500/match/2#khu-vuc-C)', '2025-12-07 13:25:47.313537', 'frontend-session-1765113942428', 34),
	(22, 'có vé trận manchester united không', 'Vé trận Liverpool vs Manchester United vẫn còn sẵn sàng cho bạn.\n\nCó nhiều khu vực và giá vé khác nhau để bạn chọn:\n\n- Vé khu vực A (giá 150 đ), còn hơn 14.000 chỗ\n- Vé khu vực B (giá 120 đ), còn hơn 17.000 chỗ\n- Vé khu vực C (giá 90 đ), còn hơn 19.000 chỗ\n\nNếu bạn muốn đặt vé, bạn có thể truy cập trang web sau để tìm hiểu thêm thông tin về vé và đặt vé:\n\nhttps://localhost:5500/match/2', '2025-12-09 10:35:36.749503', 'frontend-session-1765276520312', 34),
	(23, 'tôi muốn mua vé trận Manchester United', 'Bạn muốn mua vé cho trận Manchester United không?\n\nDựa trên thông tin mà tôi có, có hai trận phù hợp với yêu cầu của bạn:\n\n- Trận Manchester United vs Liverpool, diễn ra vào lúc 16:30 ngày 03/01/2026, ở khu vực A. Giá vé là 150,000đ và còn có 8 chỗ trống. [Xem chi tiết và đặt vé](http://localhost:5500/match/5)\n- Trận Liverpool vs Manchester United, diễn ra vào lúc 20:00 ngày 20/12/2025, ở khu vực A. Giá vé là 150đ và còn có 14000 chỗ trống. [Xem chi tiết và đặt vé](http://localhost:5500/match/2)\n- Trận Liverpool vs Manchester United, diễn ra vào lúc 20:00 ngày 20/12/2025, ở khu vực B. Giá vé là 120đ và còn có 17000 chỗ trống. [Xem chi tiết và đặt vé](http://localhost:5500/match/2)\n\nVậy trận đấu mà bạn muốn mua vé là trận nào?', '2025-12-17 15:13:24.637831', 'frontend-session-1765984371395', 34);

-- Dumping structure for table sport.customer
CREATE TABLE IF NOT EXISTS `customer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `phone_number` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone_number` (`phone_number`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.customer: ~10 rows (approximately)
INSERT INTO `customer` (`id`, `full_name`, `phone_number`, `email`, `created_at`, `updated_at`) VALUES
	(1, 'Nguyễn Thị Huyền My', '0363032808', 'nmhhuong3@gmail.com', '2025-04-23 22:09:36.158034', '2025-05-05 02:43:45.681865'),
	(2, 'Nguyễn Thư', '0123456789', 'n21@student.ptit.edu.vn', '2025-04-24 13:08:56.809778', '2025-04-24 13:08:56.809862'),
	(3, 'Nguyễn Thái Hà', '09259966465', 'thaiha@gmail.com', '2025-04-25 04:00:29.863667', '2025-04-25 04:00:29.863693'),
	(4, 'Nguyễn Thị Huyền My', '03630323323', 'n21dccn147@student.ptithcm.edu.vn', '2025-04-25 05:11:03.854797', '2025-06-12 04:00:12.779454'),
	(6, 'Anh Thu', '1234575489', 'minh@ptut.vn.cbd', '2025-04-25 08:10:42.517681', '2025-04-25 08:10:42.517718'),
	(8, 'Trịnh Trần Phương Tuấn', '0132189796', 'hihi@gmail.com', '2025-05-02 02:10:50.747757', '2025-05-05 02:49:55.412343'),
	(13, 'Minh Thu', '0912312312', 'n21dccn082@student.ptithcm.edu.vn', '2025-05-04 02:20:15.063026', '2025-05-04 02:20:15.063059'),
	(29, 'Trieu Quoc Dat', '0855831615', 'blinks987@gmail.com', '2025-06-15 12:08:29.187942', '2025-06-15 12:08:29.187981'),
	(33, 'NGUYEN THI HUYEN MY', '2435590089', 'test@gmail.com', '2025-06-15 17:06:44.298812', '2025-06-15 17:06:44.298841'),
	(34, 'Nguyễn Phúc', '01284512124', 'uechideptrai@gmail.com', '2025-06-15 17:50:54.454893', '2025-06-15 17:51:46.245190'),
	(35, 'Văn Lĩnh Vũ', 'g689540882333', 'truongthinhphat1973@gmail.com', '2025-12-13 11:59:29.989409', '2025-12-13 11:59:29.990411');

-- Dumping structure for table sport.customer_account
CREATE TABLE IF NOT EXISTS `customer_account` (
  `username` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `is_verified` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `customer_id` int NOT NULL,
  `faceid` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `customer_id` (`customer_id`),
  UNIQUE KEY `faceid` (`faceid`),
  CONSTRAINT `customer_account_customer_id_82794ac9_fk_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.customer_account: ~11 rows (approximately)
INSERT INTO `customer_account` (`username`, `password`, `is_verified`, `is_active`, `customer_id`, `faceid`) VALUES
	('0855831615', 'pbkdf2_sha256$600000$iUFp0WUCNaplfaOwXlw3wT$dvd2z1NTyZAxFdZwFCCAYBiE9uLdtrbDSSBTb3dx5ck=', 0, 1, 29, NULL),
	('1234575489', 'pbkdf2_sha256$600000$32CMNvd9BVrNAhAtj1Jzlf$uSxppk8o3ntA3lqLz1/1BizOBKzASa/ONzZHkmRO8rE=', 0, 1, 6, NULL),
	('2435590089', 'pbkdf2_sha256$600000$pg7kby3rFQbcO2Y349eC8r$nMoaSzi55BADLp2JfHFqCb5XsZvaLlvmoJMkx6hEY2I=', 1, 1, 33, NULL),
	('bacha', 'pbkdf2_sha256$600000$YzXfFPzhYuJaRvxlF7VBNa$FnrFnRyJcFWiwfzViHBWbK6J4AcR4iu4ZAeW00jAQjI=', 1, 1, 3, NULL),
	('hoanganh', 'pbkdf2_sha256$600000$mbRjGeS9z18vCp0EEuiYSy$FvuQVZdKyFs1kMKTxclyA3+Ip/Df7vAZDigcaPHdWPw=', 1, 1, 34, NULL),
	('miekhumkhon', 'pbkdf2_sha256$600000$GH8po0qL2n6HwwqbpTs9k6$ozpL6RsHFvz5++s0rZkiNz9DeBpRtOlF6r+lgISrIoo=', 1, 1, 1, NULL),
	('miemie', 'pbkdf2_sha256$600000$vVWQpsqPpayJFtfvedqJN5$2Ggo4GhUbQq45lfRBRA3WKenS9NZh50YkisiGZ9xLM0=', 1, 1, 4, NULL),
	('miene', 'pbkdf2_sha256$600000$kBFUpmnPs9T7F8DgDLQjKQ$T0ntri99n7TCh4DofEKBZdx/5lzO7ZDmWeIQgEhXA2I=', 1, 1, 8, NULL),
	('minhthu', 'pbkdf2_sha256$600000$EAqnAILunatUEQK8ZgCTCp$nVEAx1wUjlkK+tHXOFZYMyT/wSnQ6vae4GmXKP8SuDE=', 1, 1, 2, NULL),
	('minhthu123', 'pbkdf2_sha256$600000$Ywo1mLQR7yNqXcwyqzigid$ysH+ceDjivP1WZ/pomDJ5SMnWu6D9IvMex5WB8QqiRw=', 1, 1, 13, NULL),
	('truongthinhp', 'pbkdf2_sha256$600000$jaI1j664W3C0fXuukLfQ3Y$eEG6PNmyhpOkX8rnoAmWb0Q+V8J7QvKJLbIDJY/DeQo=', 1, 1, 35, NULL);

-- Dumping structure for table sport.django_admin_log
CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_general_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_employee_account_username` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_employee_account_username` FOREIGN KEY (`user_id`) REFERENCES `employee_account` (`username`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.django_admin_log: ~0 rows (approximately)

-- Dumping structure for table sport.django_content_type
CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.django_content_type: ~30 rows (approximately)
INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
	(10, 'accounts', 'customer'),
	(12, 'accounts', 'customeraccount'),
	(11, 'accounts', 'employee'),
	(13, 'accounts', 'employeeaccount'),
	(1, 'admin', 'logentry'),
	(3, 'auth', 'group'),
	(2, 'auth', 'permission'),
	(6, 'authtoken', 'token'),
	(7, 'authtoken', 'tokenproxy'),
	(8, 'background_task', 'completedtask'),
	(9, 'background_task', 'task'),
	(30, 'chatbot', 'chathistory'),
	(4, 'contenttypes', 'contenttype'),
	(14, 'events', 'league'),
	(15, 'events', 'match'),
	(19, 'events', 'matchhistory'),
	(16, 'events', 'sport'),
	(17, 'events', 'stadium'),
	(18, 'events', 'team'),
	(24, 'orders', 'order'),
	(26, 'orders', 'orderdetail'),
	(25, 'orders', 'payment'),
	(27, 'promotions', 'promotion'),
	(28, 'promotions', 'promotiondetail'),
	(29, 'returns', 'ticketreturn'),
	(5, 'sessions', 'session'),
	(23, 'tickets', 'pricehistory'),
	(22, 'tickets', 'seat'),
	(20, 'tickets', 'section'),
	(21, 'tickets', 'sectionprice');

-- Dumping structure for table sport.django_migrations
CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.django_migrations: ~32 rows (approximately)
INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
	(1, 'contenttypes', '0001_initial', '2025-12-04 04:33:09.735568'),
	(2, 'contenttypes', '0002_remove_content_type_name', '2025-12-04 04:33:10.125016'),
	(3, 'auth', '0001_initial', '2025-12-04 04:33:10.768768'),
	(4, 'auth', '0002_alter_permission_name_max_length', '2025-12-04 04:33:10.897250'),
	(5, 'auth', '0003_alter_user_email_max_length', '2025-12-04 04:33:10.910999'),
	(6, 'auth', '0004_alter_user_username_opts', '2025-12-04 04:33:10.926200'),
	(7, 'auth', '0005_alter_user_last_login_null', '2025-12-04 04:33:10.941943'),
	(8, 'auth', '0006_require_contenttypes_0002', '2025-12-04 04:33:10.953238'),
	(9, 'auth', '0007_alter_validators_add_error_messages', '2025-12-04 04:33:10.968480'),
	(10, 'auth', '0008_alter_user_username_max_length', '2025-12-04 04:33:10.983970'),
	(11, 'auth', '0009_alter_user_last_name_max_length', '2025-12-04 04:33:10.998479'),
	(12, 'auth', '0010_alter_group_name_max_length', '2025-12-04 04:33:11.030791'),
	(13, 'auth', '0011_update_proxy_permissions', '2025-12-04 04:33:11.048893'),
	(14, 'auth', '0012_alter_user_first_name_max_length', '2025-12-04 04:33:11.065816'),
	(15, 'accounts', '0001_initial', '2025-12-04 04:33:12.291884'),
	(16, 'admin', '0001_initial', '2025-12-04 04:33:12.605601'),
	(17, 'admin', '0002_logentry_remove_auto_add', '2025-12-04 04:33:12.624131'),
	(18, 'admin', '0003_logentry_add_action_flag_choices', '2025-12-04 04:33:12.640589'),
	(19, 'authtoken', '0001_initial', '2025-12-04 04:33:12.797836'),
	(20, 'authtoken', '0002_auto_20160226_1747', '2025-12-04 04:33:12.836369'),
	(21, 'authtoken', '0003_tokenproxy', '2025-12-04 04:33:12.848652'),
	(22, 'authtoken', '0004_alter_tokenproxy_options', '2025-12-04 04:33:12.865456'),
	(23, 'background_task', '0001_initial', '2025-12-04 04:33:13.959049'),
	(24, 'background_task', '0002_auto_20170927_1109', '2025-12-04 04:33:13.985677'),
	(25, 'background_task', '0003_alter_completedtask_id_alter_task_id', '2025-12-04 04:33:14.777961'),
	(26, 'chatbot', '0001_initial', '2025-12-04 04:33:15.143898'),
	(27, 'events', '0001_initial', '2025-12-04 04:33:17.303039'),
	(28, 'tickets', '0001_initial', '2025-12-04 04:33:18.665255'),
	(29, 'promotions', '0001_initial', '2025-12-04 04:33:19.326302'),
	(30, 'orders', '0001_initial', '2025-12-04 04:33:20.401024'),
	(31, 'returns', '0001_initial', '2025-12-04 04:33:20.703136'),
	(32, 'sessions', '0001_initial', '2025-12-04 04:33:20.780642'),
	(33, 'accounts', '0002_customeraccount_faceid', '2025-12-13 14:57:01.342125');

-- Dumping structure for table sport.django_session
CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.django_session: ~0 rows (approximately)

-- Dumping structure for table sport.employee
CREATE TABLE IF NOT EXISTS `employee` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `date_of_birth` date NOT NULL,
  `phone_number` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_general_ci NOT NULL,
  `citizen_id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `gender` tinyint(1) NOT NULL,
  `address` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `image` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone_number` (`phone_number`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `citizen_id` (`citizen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.employee: ~27 rows (approximately)
INSERT INTO `employee` (`id`, `full_name`, `date_of_birth`, `phone_number`, `email`, `citizen_id`, `gender`, `address`, `image`, `created_at`, `updated_at`) VALUES
	(2, 'Phan Thành Huy', '1963-07-28', '0912341213', 'uechideptrai@gmail.com', '0123456789', 0, '23 Trần Phú, Cần Thơ', 'employee_images/gorilla_zgYH5nz_37Gf1NN.png', '2025-04-25 07:30:34.054040', '2025-12-15 11:50:32.863100'),
	(3, 'Triệu Quốc Đạt', '2003-12-11', '0879879878', 'vuquochoanganh2k3@gmail.com', '987654321', 0, 'Ho Chi Minh', '', '2025-04-25 07:34:24.396938', '2025-05-05 00:22:11.423014'),
	(4, 'Nguyễn Văn An', '2007-05-02', '0901234567', 'an.nguyen.admin@example.com', '01234598985', 0, '78 man thiện', '', '2025-05-03 13:52:15.541577', '2025-05-03 13:52:15.541613'),
	(6, 'Nguyễn Thảo', '2007-05-04', '01234567878', 'minhthu@gmail.com', '01123351555', 0, '54 Hàm Nghi', '', '2025-05-04 01:23:52.263043', '2025-05-04 01:30:03.337005'),
	(8, 'Nguyễn An', '2007-05-04', '0152345678', 'anguyen@it.vn.edu', '011233515789', 0, '78 man thiện', '', '2025-05-04 01:25:56.384370', '2025-05-04 01:25:56.384414'),
	(10, 'Nguyễn Anh Thư', '2007-05-15', '0123456789', 'nguyenanhthu@gmail.com', '015188231545', 0, 'phú yên', 'employee_images/maomaoo_6hV8Mjl.jpg', '2025-05-04 01:30:45.423974', '2025-06-14 09:51:04.269281'),
	(11, 'Anh Thu', '2007-06-15', '0123456777', 'minh@ptut.vn.cbd', '01123351222', 0, 'Số 1, Đường Láng, Hà Nội', '', '2025-06-15 08:19:03.420996', '2025-06-15 08:19:03.421047'),
	(12, 'Anh Thu', '2007-06-15', '0123456733', 'minhthu@ptut.vn.cbd', '011233512111', 1, 'Thu Duc', '', '2025-06-15 08:20:43.889894', '2025-06-15 08:20:43.889943'),
	(13, 'Thư Nguyễn Thị Minh', '2007-06-15', '0123456773', 'minhthutfboys9210@gmail.com', '011233518888', 1, 'Thôn Phước Lương', '', '2025-06-15 08:59:22.548388', '2025-06-15 08:59:46.775496'),
	(14, 'Nguyễn Hoàng', '2007-05-15', '0123456712', 'nguyenhoang@gmail.com', '015188231789', 0, 'Số 1, Đường Láng, Hà Nội', '', '2025-06-15 11:43:04.589332', '2025-06-15 11:43:04.589374'),
	(18, 'Nguyễn Tùng', '2007-06-15', '0122345465', 'mymy@gmail.com', '0123456012', 0, '54 Hàm Nghi', '', '2025-06-15 11:52:39.952268', '2025-06-15 11:52:39.952322'),
	(21, 'Nguyễn Hảo', '2007-06-15', '0987456321', 'nguyenhao@student.ptithcm.edu.vn', '012345678978', 0, 'Thu Duc', '', '2025-06-15 12:06:54.779899', '2025-06-15 12:06:54.779959'),
	(22, 'Trần My', '2007-06-15', '0363032802', 'mymy2@gmail.com', '01123351789', 0, '65 tăng nhơn phú, phước long b, thủ đức', '', '2025-06-15 12:08:00.425433', '2025-06-15 12:08:00.425480'),
	(23, 'Trần My My', '2007-06-15', '0363032878', 'tranmy@gmail.com', '01123351000', 0, '78 man thiện', '', '2025-06-15 12:09:32.642958', '2025-06-15 12:09:32.642999'),
	(26, 'Nguyễn Văn An', '2007-06-15', '0147852369', 'an.nguyen589@example.com', '011233510000', 0, 'Thôn Phước Lương', '', '2025-06-15 13:10:28.281026', '2025-06-15 13:10:28.281063'),
	(27, 'Nguyễn Thái Hà', '2005-02-04', '0425645653', 'ngthaiha@gmail.com', '2343243244', 1, 'Hà Nội', 'employee_images/ChatGPT_Image_23_53_44_15_thg_6_2025_69FUCMa.png', '2025-06-15 16:50:46.209120', '2025-06-15 16:54:02.370616'),
	(28, 'Nguyen Minh', '2007-06-15', '0363032821', 'nguyenminh@gmail.com', '012345678974', 0, 'Thu Duc', '', '2025-06-15 17:42:40.181941', '2025-06-15 17:42:40.181992'),
	(30, 'Nguyen Chi', '2007-06-15', '0123456445', 'nguyenchi@gmail.com', '015188231500', 0, '78 man thiện', '', '2025-06-15 17:43:51.871995', '2025-06-15 17:43:51.872023'),
	(32, 'Minh Hoang', '2007-06-15', '0356520774', 'anhminhthu@gmail.com', '012340123123', 0, 'Thu Duc', '', '2025-06-15 17:47:03.544259', '2025-06-15 17:47:03.544321'),
	(33, 'Nguyen Phuc', '2007-06-15', '03565207896', 'nguyenphuc@gmail.com', '012340123789', 0, 'Thu Duc', '', '2025-06-15 17:47:55.854676', '2025-06-15 17:47:55.854699'),
	(34, 'Triệu Quốc Đạt', '2006-07-12', '0839452272', 'blinks987@gmail.com2', '123443211234', 0, 'acd', '', '2025-06-16 01:59:46.131043', '2025-06-16 01:59:46.131093'),
	(36, 'Nguyen Thi Huyen My', '2007-06-15', '0912345678', 'huynmy@gmail.com', '02323263262', 0, '105/8', '', '2025-06-16 07:54:36.758557', '2025-06-16 07:54:36.758602'),
	(40, 'Nguyen Thu', '2007-06-16', '0124578132', 'nguyenthu@gmail.com', '012487154812', 0, '105/8', '', '2025-06-16 07:57:10.774135', '2025-06-16 07:57:10.774157'),
	(42, 'Nguyen Thu', '2007-06-16', '0121545212', 'nguyenthu1@gmail.com', '012487154777', 0, '105/8', '', '2025-06-16 07:57:43.911575', '2025-06-16 07:57:43.911595'),
	(44, 'Nguyễn Văn Trọng', '2007-06-16', '0121564887', 'nguyn@gmail.com', '01843518798', 0, '105/8', '', '2025-06-16 07:59:08.270766', '2025-06-16 07:59:08.270786'),
	(46, 'Nguyễn Văn Trọng Trọng', '2007-06-16', '0121567787', 'ngumauyn@gmail.com', '018435187132', 0, '105/8', '', '2025-06-16 08:00:19.610530', '2025-06-16 08:00:19.610573'),
	(48, 'Nguyễn Văn Trọng Trunh', '2007-06-16', '01234578112', 'trongtirnh@gmail.com', '012484351852', 0, '102/3', '', '2025-06-16 08:03:19.112632', '2025-06-16 08:03:19.112652');

-- Dumping structure for table sport.employee_account
CREATE TABLE IF NOT EXISTS `employee_account` (
  `username` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `employee_id` int NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `employee_id` (`employee_id`),
  CONSTRAINT `employee_account_employee_id_12f15358_fk_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.employee_account: ~27 rows (approximately)
INSERT INTO `employee_account` (`username`, `password`, `role`, `is_active`, `employee_id`) VALUES
	('011233510000', 'pbkdf2_sha256$600000$636Tc7vx4tGQm1tODszBqg$iFyyPVIE2rEhZY/1PbVgIqmlpS4soK9PnIGDv1/aW4A=', 'staff', 1, 26),
	('011233512111', 'pbkdf2_sha256$600000$CnfIz49rZEtXEfeGaBJaCe$4Rcoa+Kb+yr+iV0mkxQcCUq3F5H/CR5LRN5JPSXiSlA=', 'staff', 1, 12),
	('01123351222', 'pbkdf2_sha256$600000$MqPVd0z4pFwjzPevbeGHQn$L0NU4mP6ssYXfhzdN2YNiNiN7w+mTuMH0bwkdfNF4Sk=', 'staff', 1, 11),
	('01123351555', 'pbkdf2_sha256$600000$xtMMrlvUx9vKDh72cBYUln$1ZnS0/SNZjTQpzpqszdAsrNxyEpzwYSW09MXB34ozMc=', 'staff', 1, 6),
	('011233515789', 'pbkdf2_sha256$600000$OgydTB26SQsYkmy1s4oA3v$gJ5jkTwVYfE34z5dDQEoNLOi4gtjGJxfXfOvCXYLe+8=', 'staff', 0, 8),
	('01123351789', 'pbkdf2_sha256$600000$eHWF5wzJMgLUGVGcWMtqRG$9owWdV2OGhf87838oALpWe5ZcG1ZPzmnggyiiPe28uI=', 'staff', 1, 22),
	('011233518888', 'pbkdf2_sha256$600000$oKsLRsDUKI2mzHGwDPln4F$1ts4c/CrTGGHAuNbCnaM5KQYTF+yodQ4Jn8SLFItP4U=', 'staff', 0, 13),
	('012340123123', 'pbkdf2_sha256$600000$1jgTKVDzldRlnxpkHiUbcM$jHh07qYqO+a9TctknPl8mCLcWiAmCorJpKuq885uJf8=', 'staff', 1, 32),
	('012340123789', 'pbkdf2_sha256$600000$TU1C33XHXbibpC7sN2JH0W$FI1/0Z9i2ssQIy3tOIX1t07WkYFD+W/2mAcc0u1w91k=', 'staff', 1, 33),
	('0123456012', 'pbkdf2_sha256$600000$JOfq1gAbokqUO0YqX1WwFI$cBvF7UTWv6uFqXsP4+jhwC9X5L1XtJVYrrgxLpD73qU=', 'staff', 1, 18),
	('0123456789', 'pbkdf2_sha256$600000$xxeXNGTA55n9iGDUBy4M7d$byh/pkDzjVjPbBGPyBvg4Sl5AnpwHC5ULe8df7xaTu8=', 'admin', 1, 2),
	('01234567890', 'pbkdf2_sha256$600000$G3jwr8qaLNDOOMaLoMsu5l$Pex52t2qwdFiGshrJLLZ8Uh+nRi/LEM+t+CYHEnInTw=', 'staff', 1, 23),
	('012345678974', 'pbkdf2_sha256$600000$gmnTgp1qTl23OGn1sdJ9VD$qtBRdqzVD00KYS3FptQ+YoCDPqiWeaZhTC9dY86ULhc=', 'staff', 1, 28),
	('012345678978', 'pbkdf2_sha256$600000$HkXpQM805PxddBdguDFAV4$zbkag65B55DiuW2K1HWN/gFW6BsCEOjFRIpZ2BqTI0Y=', 'staff', 1, 21),
	('01234598985', 'pbkdf2_sha256$600000$3YpbNdC5ancxXpeKj4Cz9j$A1VOzHc49ic08B7QqdYzAY7LMj+lB341/OOG98PO2wA=', 'staff', 0, 4),
	('012484351852', 'pbkdf2_sha256$600000$5TfSOBNeFqqBxPFxtV6tYg$eKX/veLBzcPgetEa6tEACbiKZDh3vd+aKfyPud+Z/gw=', 'staff', 1, 48),
	('012487154777', 'pbkdf2_sha256$600000$HGjT1QxVYXxtoUrHxDlKAV$dpd5hctj7Eqnx9Wammx9if2hon2+wvU0Gyax9PPiWFo=', 'staff', 1, 42),
	('012487154812', 'pbkdf2_sha256$600000$H6s0xMKN5Och9QQ4JhapCn$zY5Hi+buNx8pExXz/LVOT9lvw9IWVXQlTFXbw1hmAqE=', 'staff', 1, 40),
	('015188231500', 'pbkdf2_sha256$600000$HE1Patj1QmqAivdybvnu3p$Ihuqr0LU7tMX7x91kfwuQsZlsQ0Ys4EppBPfX34Q6Rw=', 'staff', 1, 30),
	('015188231545', 'pbkdf2_sha256$600000$GEuG7XwoevJwbDMDl3R7YF$yzs9ZCUEvP75uzlO+y0LnzBEwp3gAe9gm1b/FYkjCik=', 'staff', 0, 10),
	('015188231789', 'pbkdf2_sha256$600000$vQwE4gplYFg5Vo7AAmXBpD$gQ2omHiyR4v5Aum1D/QqK140E/+VuUvOjyaPHcFfeng=', 'staff', 1, 14),
	('018435187132', 'pbkdf2_sha256$600000$8XQONqgs3eTyY7VVmFCGWE$2Voq8ldu953oVQ3bTKy0u+GcSKqDygTQrRvbw5YPkOI=', 'staff', 1, 46),
	('01843518798', 'pbkdf2_sha256$600000$l7nndEKxnWgT6HTCpMn5eI$A5b8YOYICU4qo5/mesj74cZOW4+5uQw2NNqglLHkBPM=', 'staff', 1, 44),
	('02323263262', 'pbkdf2_sha256$600000$U638SsU5zszxGIeTXRrgmY$ig94kPfc0I9BD8PBqXB7LjvhMymt0niQzPy5UZWCC0M=', 'staff', 1, 36),
	('123443211234', 'pbkdf2_sha256$600000$uTz2i0Di5fx2CQc7M7C4AT$k/ceN8E/z7SKrZEsWFMK86/r60+n0z9GoCpDR8Mbxv4=', 'staff', 1, 34),
	('2343243244', 'pbkdf2_sha256$600000$ZsMoE3e8l26hBZGCGwjzRW$YxYyLCPZRVk/ksoCSf38GGAOHnKjIsH3yCrqBMQ1Wq8=', 'admin', 1, 27),
	('987654321', 'pbkdf2_sha256$600000$pJQVsi2g2rKBCalmpboRAc$jIepKcOnzBB5K5irnkf8ihnZT8vE75OShhoeLnxjHgs=', 'staff', 1, 3);

-- Dumping structure for table sport.employee_account_groups
CREATE TABLE IF NOT EXISTS `employee_account_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employeeaccount_id` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_account_groups_employeeaccount_id_group_a6becb80_uniq` (`employeeaccount_id`,`group_id`),
  KEY `employee_account_groups_group_id_6c057951_fk_auth_group_id` (`group_id`),
  CONSTRAINT `employee_account_gro_employeeaccount_id_98d6cf58_fk_employee_` FOREIGN KEY (`employeeaccount_id`) REFERENCES `employee_account` (`username`),
  CONSTRAINT `employee_account_groups_group_id_6c057951_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.employee_account_groups: ~0 rows (approximately)

-- Dumping structure for table sport.employee_account_user_permissions
CREATE TABLE IF NOT EXISTS `employee_account_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employeeaccount_id` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_account_user_pe_employeeaccount_id_permi_1c19e578_uniq` (`employeeaccount_id`,`permission_id`),
  KEY `employee_account_use_permission_id_76808304_fk_auth_perm` (`permission_id`),
  CONSTRAINT `employee_account_use_employeeaccount_id_b6d3e5cd_fk_employee_` FOREIGN KEY (`employeeaccount_id`) REFERENCES `employee_account` (`username`),
  CONSTRAINT `employee_account_use_permission_id_76808304_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.employee_account_user_permissions: ~0 rows (approximately)

-- Dumping structure for table sport.league
CREATE TABLE IF NOT EXISTS `league` (
  `league_id` int NOT NULL AUTO_INCREMENT,
  `league_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `league_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `sport_id` int NOT NULL,
  PRIMARY KEY (`league_id`),
  KEY `league_sport_id_75929a4f_fk_sport_sport_id` (`sport_id`),
  CONSTRAINT `league_sport_id_75929a4f_fk_sport_sport_id` FOREIGN KEY (`sport_id`) REFERENCES `sport` (`sport_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.league: ~4 rows (approximately)
INSERT INTO `league` (`league_id`, `league_name`, `league_type`, `start_date`, `end_date`, `created_at`, `updated_at`, `sport_id`) VALUES
	(1, 'Premier League', 'National', '2025-01-01', '2025-04-01', '2025-11-19 08:22:59.000000', '2025-11-19 08:22:59.000000', 1),
	(2, 'La Liga', 'National', '2025-01-01', '2025-05-30', '2025-11-19 08:22:59.000000', '2025-11-19 08:22:59.000000', 1),
	(3, 'Premier League', 'National', '2025-12-01', '2026-12-01', '2025-12-01 18:47:10.000000', '2025-12-01 18:47:12.000000', 1),
	(4, 'VBA', 'National', '2025-12-18', '2025-12-18', '2025-12-18 16:33:11.000000', '2025-12-18 16:33:12.000000', 2);

-- Dumping structure for table sport.match
CREATE TABLE IF NOT EXISTS `match` (
  `match_id` int NOT NULL AUTO_INCREMENT,
  `match_time` datetime(6) NOT NULL,
  `description` longtext COLLATE utf8mb4_general_ci,
  `round` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_hot_match` tinyint(1) NOT NULL,
  `importance` int NOT NULL,
  `league_id` int NOT NULL,
  `stadium_id` int NOT NULL,
  `team_1_id` int NOT NULL,
  `team_2_id` int NOT NULL,
  PRIMARY KEY (`match_id`),
  UNIQUE KEY `unique_match_time_stadium` (`match_time`,`stadium_id`),
  UNIQUE KEY `unique_league_round_teams` (`league_id`,`round`,`team_1_id`,`team_2_id`),
  KEY `match_stadium_id_b9015059_fk_stadium_stadium_id` (`stadium_id`),
  KEY `match_team_1_id_56ede6da_fk_team_team_id` (`team_1_id`),
  KEY `match_team_2_id_1d4fec35_fk_team_team_id` (`team_2_id`),
  CONSTRAINT `match_league_id_23bb3dec_fk_league_league_id` FOREIGN KEY (`league_id`) REFERENCES `league` (`league_id`),
  CONSTRAINT `match_stadium_id_b9015059_fk_stadium_stadium_id` FOREIGN KEY (`stadium_id`) REFERENCES `stadium` (`stadium_id`),
  CONSTRAINT `match_team_1_id_56ede6da_fk_team_team_id` FOREIGN KEY (`team_1_id`) REFERENCES `team` (`team_id`),
  CONSTRAINT `match_team_2_id_1d4fec35_fk_team_team_id` FOREIGN KEY (`team_2_id`) REFERENCES `team` (`team_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.match: ~7 rows (approximately)
INSERT INTO `match` (`match_id`, `match_time`, `description`, `round`, `created_at`, `is_hot_match`, `importance`, `league_id`, `stadium_id`, `team_1_id`, `team_2_id`) VALUES
	(1, '2025-12-01 19:30:00.000000', 'Manchester United vs Liverpool', 'Round 1', '2025-11-19 08:23:00.000000', 1, 1, 1, 1, 1, 2),
	(2, '2025-12-20 20:00:00.000000', 'Liverpool vs Manchester United', 'Round 2', '2025-11-19 08:23:00.000000', 1, 1, 1, 2, 2, 1),
	(3, '2025-12-01 21:00:00.000000', 'Barcelona vs Real Madrid', 'Round 1', '2025-11-19 08:23:00.000000', 1, 1, 2, 3, 3, 4),
	(4, '2025-12-10 23:20:00.000000', 'Real Madrid vs Barcelona', 'Round 2', '2025-11-19 08:23:00.000000', 1, 1, 2, 3, 4, 3),
	(5, '2026-01-03 16:30:00.000000', 'Manchester United vs Liverpool', '16', '2025-12-16 16:31:07.767022', 0, 3, 3, 1, 1, 2),
	(6, '2026-01-29 11:30:00.000000', 'khai mạc', '16', '2025-12-16 16:40:39.467781', 0, 3, 3, 1, 2, 3),
	(7, '2025-12-16 16:35:20.000000', 'SaiGon Heat vs HCM City Wings', 'Round 1', '2025-12-18 16:35:48.000000', 1, 1, 4, 2, 5, 6);

-- Dumping structure for table sport.match_history
CREATE TABLE IF NOT EXISTS `match_history` (
  `m_history_id` int NOT NULL AUTO_INCREMENT,
  `changed_at` datetime(6) NOT NULL,
  `change_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `old_value` json NOT NULL,
  `new_value` json NOT NULL,
  `reason` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `employee_id` int NOT NULL,
  `match_id` int NOT NULL,
  PRIMARY KEY (`m_history_id`),
  KEY `match_history_employee_id_05267eb5_fk_employee_id` (`employee_id`),
  KEY `match_history_match_id_549c7b05_fk_match_match_id` (`match_id`),
  CONSTRAINT `match_history_employee_id_05267eb5_fk_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`),
  CONSTRAINT `match_history_match_id_549c7b05_fk_match_match_id` FOREIGN KEY (`match_id`) REFERENCES `match` (`match_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.match_history: ~0 rows (approximately)

-- Dumping structure for table sport.order
CREATE TABLE IF NOT EXISTS `order` (
  `order_id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `order_status` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `order_method` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `order_user_id_e323497c_fk_customer_id` (`user_id`),
  CONSTRAINT `order_user_id_e323497c_fk_customer_id` FOREIGN KEY (`user_id`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.order: ~73 rows (approximately)
INSERT INTO `order` (`order_id`, `total_amount`, `order_status`, `order_method`, `created_at`, `user_id`) VALUES
	('02322224dfsdfdsfdfsdssfsdsd', 100000.00, 'received', 'online', '2025-12-18 16:45:52.000000', 34),
	('03ef3180572949f4b15344aed2e7be51', 1000000.00, 'received', 'online', '2025-11-23 19:18:56.636025', 3),
	('0584432255674fbb95f7ac3ee7ea5cea', 2500000.00, 'cancelled', 'online', '2025-06-14 10:40:28.648327', 1),
	('063866157c2142e6ac55001bd834de9f', 1900000.00, 'received', 'online', '2025-06-16 07:19:15.771556', 1),
	('07e8e8dad1684914b116055e5e0d208a', 1100000.00, 'received', 'online', '2025-06-15 12:58:05.298023', 1),
	('0d95d00884114cd287435a8ba7dfa63e', 1185000.00, 'received', 'online', '2025-06-15 10:04:20.787562', 1),
	('10aff3e0b89e4202a9ed3a3db3b05bb1', 293000.00, 'received', 'offline', '2025-05-05 02:15:15.479292', 2),
	('159e511a85de4897b5a8dbb1bec48133', 1250000.00, 'received', 'offline', '2025-06-16 04:50:08.426078', 2),
	('1d9af26a28d647ac8c299c612fcb9b9b', 85500.00, 'cancelled', 'online', '2025-05-05 01:04:36.471917', 1),
	('1e33d6d7be984e748618ae9b49b41f64', 1900000.00, 'received', 'offline', '2025-06-16 04:59:12.630330', 2),
	('20d85a309fd0407f8a759ac334fa2953', 1185000.00, 'received', 'offline', '2025-06-13 14:13:35.754849', 3),
	('25331d41f10c49f48d36419c3899b286', 3600000.00, 'cancelled', 'online', '2025-06-14 10:04:45.345952', 1),
	('29a92e1c499b454e97c6fb99edb313d8', 1000000.00, 'cancelled', 'online', '2025-06-13 18:58:06.104909', 3),
	('32bcfebdbb234c27935c72985a1a9a6e', 1100000.00, 'cancelled', 'online', '2025-06-14 07:38:01.310766', 3),
	('33f7af899a5e490c9e5b5e0b5cc01baf', 1200000.00, 'received', 'online', '2025-06-14 10:02:03.014332', 1),
	('3a9004bb1c4d4ffa9d71952e2cea24ae', 1200000.00, 'cancelled', 'online', '2025-06-14 10:41:54.437555', 1),
	('3bf476b367074012b31fd912b02eafa3', 1185000.00, 'cancelled', 'online', '2025-06-12 03:58:42.410646', 1),
	('3d80bee55cf94a8aa0a68611de2524d0', 1100000.00, 'received', 'online', '2025-06-13 19:47:45.619129', 3),
	('3fead25b3521446bbbcf62c7fe0f178a', 1100000.00, 'cancelled', 'online', '2025-06-16 03:56:02.644494', 1),
	('43dd74ce2920465c826dffcebd7615b9', 3000000.00, 'received', 'online', '2025-06-13 18:22:58.037361', 1),
	('4bdfd197cedb4be6aced562fedac9002', 970000.00, 'received', 'online', '2025-06-16 07:49:56.455881', 1),
	('50a1da5aa0344a2980ce228aca912e37', 2200000.00, 'received', 'online', '2025-06-12 06:34:11.335669', 3),
	('52899571a1b9469c84d8599b61ed3f8e', 1700000.00, 'cancelled', 'offline', '2025-06-14 08:03:34.330197', 2),
	('5452ca00c3ed4821a959701f8e476aab', 3600000.00, 'cancelled', 'online', '2025-06-14 10:40:22.411892', 1),
	('55459939c33f41f1a9cc8ab511f6eb92', 3000000.00, 'cancelled', 'online', '2025-06-14 10:39:53.967040', 1),
	('59453bee67724d33b7abf32e509198fa', 3000000.00, 'cancelled', 'online', '2025-06-16 03:55:52.782369', 1),
	('5d691b4469ce4eee8a257a149e5f6108', 1200000.00, 'cancelled', 'offline', '2025-06-12 03:53:15.811976', 6),
	('63a8ec2306ef413caf1e32f5f4073f08', 2720000.00, 'received', 'online', '2025-06-12 06:21:14.033106', 1),
	('66aa53eb07ea4d788e4f832cc7a65de3', 150.00, 'pending', 'online', '2025-11-25 09:16:41.715219', 34),
	('69250b87dd6e454298fbaaccd5e631f8', 1185000.00, 'received', 'online', '2025-06-13 18:57:04.621730', 3),
	('6a7a5bb6633645f6a9327d9cbce66e6f', 6800000.00, 'cancelled', 'online', '2025-06-16 03:55:12.781538', 1),
	('6b81645fc7224ba49d0fdf1b23881e04', 5300000.00, 'cancelled', 'online', '2025-06-16 09:00:50.355450', 1),
	('703725af5e1e432a964ab26180aceb25', 1360000.00, 'cancelled', 'online', '2025-06-16 03:55:28.647220', 1),
	('704840b6875845d8904b2e88aebde7d5', 1235000.00, 'received', 'online', '2025-06-15 10:09:59.910737', 1),
	('710a22c3a03e4ebb8fb5ed565a219382', 90000.00, 'cancelled', 'online', '2025-05-05 00:58:44.911391', 1),
	('71282673a9b44e2fb99c22d589ccb5b7', 3800000.00, 'cancelled', 'online', '2025-06-14 10:40:49.787147', 1),
	('74018f94cf6d4183b4eca11474060dbc', 1250000.00, 'cancelled', 'online', '2025-06-16 03:54:46.678008', 1),
	('77182d73dbf64736933e04948c0a22ad', 2720000.00, 'cancelled', 'online', '2025-06-14 10:41:09.269535', 1),
	('785ed697f13749318c72fa13bb71b7fc', 1185000.00, 'cancelled', 'online', '2025-06-12 04:02:42.166481', 1),
	('7c0aac36e51c4d6ebce0c6da6345a69c', 1200000.00, 'received', 'offline', '2025-06-15 12:09:48.032415', 29),
	('7ebeb4033859429c86b8ba328cfda1e9', 3800000.00, 'cancelled', 'online', '2025-06-16 03:55:21.057694', 1),
	('981a9da6634849e9829a418cd7fec6ec', 1200000.00, 'received', 'offline', '2025-06-12 03:23:36.710059', 3),
	('9dda0ccabfb44aa2b795a6d6683177cb', 1100000.00, 'received', 'online', '2025-06-13 19:50:58.279341', 3),
	('a09732f2ef27437fb0200a9782756a1b', 150000.00, 'received', 'offline', '2025-12-01 07:12:32.681700', 1),
	('a3dc667fa4c24d59afbb3ea7e3d077b7', 7500000.00, 'received', 'online', '2025-06-12 04:28:04.976930', 1),
	('b0c14698e72f4ad2aa7df8aa033e31c8', 172900.00, 'cancelled', 'online', '2025-05-05 01:59:28.302162', 1),
	('b2d0874a3b9a46669dca939339866671', 2370000.00, 'cancelled', 'online', '2025-06-12 03:56:50.555661', 1),
	('b9902886aba94b6bb9bcfc17bb424b11', 2000000.00, 'received', 'online', '2025-06-12 06:32:24.252184', 3),
	('bb4f1063ed3f42ce9c6c32edd2e1d3f5', 1185000.00, 'received', 'offline', '2025-06-14 08:02:39.557467', 1),
	('bb89d1ceff6d44e2b56f44ea2d9fc4ad', 3000000.00, 'received', 'online', '2025-06-16 08:48:12.128164', 1),
	('bc6d9f603bd54979a9ab8341a7e6bb1f', 1100000.00, 'received', 'offline', '2025-06-16 04:55:36.349917', 2),
	('bd816f3674854f209e26abc984b9c29d', 1292000.00, 'received', 'offline', '2025-06-15 09:11:36.492966', 3),
	('bdf3dcab635240f89e1e75e856fa0a3e', 2200000.00, 'cancelled', 'online', '2025-06-12 06:34:11.575975', 3),
	('bf0e938e5a6042c0bea1cf4ece269c7a', 3400000.00, 'received', 'online', '2025-06-12 06:28:14.038942', 3),
	('c1b19006b7a840179de06ffba08830eb', 3400000.00, 'received', 'offline', '2025-06-15 13:16:42.712764', 1),
	('c40c5f35f2344ccaac2a7d8f3b4b98b9', 150000.00, 'cancelled', 'online', '2025-11-25 09:42:18.238810', 34),
	('d15936ece09a40a29821ac0728543a79', 338000.00, 'received', 'online', '2025-05-05 02:51:01.058287', 8),
	('d1713e6aa2f24639bd967e6f5a819c09', 4080000.00, 'received', 'online', '2025-06-12 06:24:31.566776', 1),
	('d1d5aa4a79214a9ebd60bcf8a087e899', 1360000.00, 'received', 'offline', '2025-06-16 04:56:06.029191', 2),
	('d2e41d82bebf4aa683a8281e7b060f6b', 2370000.00, 'cancelled', 'online', '2025-06-12 04:43:49.813757', 1),
	('d7237cdbb58543a8bc6e17511f47a744', 485920.00, 'received', 'online', '2025-05-05 02:06:15.471729', 1),
	('db74d1397e854d118a44e8c6a6d6381b', 1200000.00, 'received', 'online', '2025-06-12 04:05:24.832881', 1),
	('dc39e80b27fe4433856710d3271c8b1e', 2370000.00, 'cancelled', 'online', '2025-06-12 03:48:53.180659', 1),
	('dc68ab73cda84eaca4549e3b50ebc2e7', 3300000.00, 'cancelled', 'online', '2025-06-14 10:40:07.330871', 1),
	('dc83d42260124a598569a29301822942', 2500000.00, 'cancelled', 'online', '2025-06-14 10:04:54.938177', 1),
	('de1c862036c94e3d8dc67c0e4ba1fbcc', 3000000.00, 'received', 'online', '2025-06-12 04:24:13.886612', 1),
	('dea3e8651b8c43a5b5a0221c36348549', 1000000.00, 'received', 'online', '2025-06-13 19:42:29.408294', 3),
	('df800a0388ed4bb6b8bcea1ffa243cf3', 2370000.00, 'received', 'offline', '2025-06-15 08:04:52.712703', 1),
	('e9d42e6bdabd4d41a900862762ea2234', 1500000.00, 'received', 'online', '2025-06-13 18:29:40.703608', 3),
	('ef68868550a743ada81e15bfdb03d249', 1100000.00, 'received', 'offline', '2025-06-15 17:18:23.759314', 33),
	('f124574f5d0745b1b1c0a804678e1135', 150000.00, 'cancelled', 'online', '2025-11-25 09:24:58.603090', 34),
	('fa8fc272854b473fa2e1ba47ae9a4add', 1000000.00, 'cancelled', 'online', '2025-06-13 19:05:21.408968', 3),
	('fb0bad6b219040e2a4a99594466fc400', 6800000.00, 'cancelled', 'online', '2025-06-14 10:40:41.350745', 1);

-- Dumping structure for table sport.order_detail
CREATE TABLE IF NOT EXISTS `order_detail` (
  `detail_id` int NOT NULL AUTO_INCREMENT,
  `qr_code` longtext COLLATE utf8mb4_general_ci,
  `price` decimal(10,2) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `order_id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pricing_id` int NOT NULL,
  `promotion_id` int DEFAULT NULL,
  `seat_id` int DEFAULT NULL,
  PRIMARY KEY (`detail_id`),
  UNIQUE KEY `unique_order_seat` (`order_id`,`seat_id`),
  KEY `order_detail_pricing_id_461608fe_fk_section_price_pricing_id` (`pricing_id`),
  KEY `order_detail_promotion_id_30d78bbe_fk_promotion_promo_id` (`promotion_id`),
  KEY `order_detail_seat_id_e767a2f0_fk_seat_seat_id` (`seat_id`),
  CONSTRAINT `order_detail_order_id_b97dfbdf_fk_order_order_id` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`),
  CONSTRAINT `order_detail_pricing_id_461608fe_fk_section_price_pricing_id` FOREIGN KEY (`pricing_id`) REFERENCES `section_price` (`pricing_id`),
  CONSTRAINT `order_detail_promotion_id_30d78bbe_fk_promotion_promo_id` FOREIGN KEY (`promotion_id`) REFERENCES `promotion` (`promo_id`),
  CONSTRAINT `order_detail_seat_id_e767a2f0_fk_seat_seat_id` FOREIGN KEY (`seat_id`) REFERENCES `seat` (`seat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=295 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.order_detail: ~5 rows (approximately)
INSERT INTO `order_detail` (`detail_id`, `qr_code`, `price`, `updated_at`, `order_id`, `pricing_id`, `promotion_id`, `seat_id`) VALUES
	(1, 'avbccc', 1000000.00, '2025-11-25 13:40:26.000000', '03ef3180572949f4b15344aed2e7be51', 1, NULL, 1),
	(2, 'abgghfgg', 100000.00, '2025-11-25 09:16:41.749736', '02322224dfsdfdsfdfsdssfsdsd', 16, NULL, 7),
	(3, 'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAADAUlEQVR4nO2cS27bMBCGvykFZCkBOUCPQt+s6JF6A+koPkAAallAxt8FH5KbVWpAcuXhQpAVfcAQmfzzomPiy2v69nUGHHLIIYcccsihc0JWVgfMZmbDzZgGMBvALnN94XKIeQ7tD0VJUgKmIYiYgojXDmICIEiSdA/tZ55D+0NzFYCoBeBm0C/op5kBUBTkIPMcOgyyC6CfQ1B1gfC5Pv3P9uTQV1b394Np+OiI124R3ExRNxPzUeY5dBjUSxoBKQUxfV9gsjfZZX7LGiHlcHKMeQ7tDU1mVuuKDuK1w36k8o5duOVS4yjzHNo7aqypQokQ/VIv+af3ucST78mhRyBKVdmixpjvQrkotcKzV1njk+/JoUegqhFzt1jUrQPyxchJZa5DE8RfVqXiyffk0CMQ5c+eklTmzDJqQW1VeajPXCPODJWoESWVgNEvVLdoYQKQEu4RLwDVPGJdvapGZMmAklb0zXOefE8OPQ7l3/7YtwY2wDSUO7tArkgPMs+hI2qNBY35ScgfiWsRkiOJR41XgLZRI2qhjD3rKLQkEgmA4FHjBaBWa5QGBDEFbdQiT8N75TvXiPNDWxUo+eT2Lk8zYmtTuUacHmpRY9uK2KQVWRkS24rUPeL8kMb+t+WJJ/ObiNc3rZMuIIhpOMw8h3bvYucVr5YnXZq+/zbohdEL6BcspnfvYr8A1HqWSxly5boiV5/rRVpf9qhxaqhpRJBBtxRlADRZENOQZJOFRczD/uY5tDtUNSLVPvXadmjFRZl0JfDM8vzQfc8yaC0uNsUowHbw9eR7cugRaDP0Xn1j048YWz/bPeKVoM13umJqx/F7CeaOcmkjsP9jTw49BLVBxuoCdgHsR9ON4haHmOfQAZkl1JFGyzH7knLmF9fQ4VHjzNCnb/DQf1jtVRmCBeJ462B+X7xDdX7os0fMHZoGclPCIJQz+tMQsDjua55Du0Pbc5bKEWKdeZVna6PCa43zQ/fnLMPm0NSmle1nsV8IMv/PZA455JBDDjnk0D9CfwAGTq3KZLZ4YAAAAABJRU5ErkJggg==', 150000.00, '2025-11-25 09:26:54.606217', 'f124574f5d0745b1b1c0a804678e1135', 1, NULL, 1),
	(4, 'iVBORw0KGgoAAAANSUhEUgAAAZoAAAGaAQAAAAAefbjOAAAC/0lEQVR4nO2cTY6jMBBGXw2WZglSHyBHgRvMkVp9pLkBHCUHiISXI4FqFi4bMr3qzggSKBYIEp5ki8pXf3ZE+fIx/Pg6Aw455JBDDjnk0DEhsSMAUUSkmSV/UT4TEel2GZ5D20OtqqqOwNBUSjtWCjFAqxNApaqqeg9tNzyHtodiFgAzAdMI/cjKYGqx0/Ac2g2SDtCPplKRyx8Bqs/56YvNyaGvHOHfD4bmFmivYVLzGrMoca/hObQ5lC2iViCCAirDZYKhqyaIb0kj1krx5HNy6D9Ag4iINCBdDNBeA/I+mhORjjmlGnsNz6GtNWIRAPMQtYWXSpzFFGSP4Tm0OYRllbWq9oD26aqyk46V0pZHVFW1f/I5OfQIlDUiCkp9C8AcSNlnfRNNQsEcaH9L1pInn5NDj0CmEVahWkRhIt329SIPE64Rx4eK15iscNnXZgzJV7TJSsBObhFHh+wlL++8r7VoBCRlSGFFnbXELeL4kEgDDBdVSgGbobFnpIOUke40PId2iiN6wJpcxYmUg3Z0r3EGaOU1lsBh1Qq12EIVqNxrnABiJQN9ue3Td1XKMFI/1DXiHNAq19C+nsgOwyJL2vHuOdeIw0NrjUj1CDWzMMkYMbNY3IlbxJGh/NtP8WSJI9KpuIlaU1HbLeL4UPYapYeROhw517AK1d2VW8QZoHacxUKIa1lgmyoTs90OeTXuq8zJoQc6XUA1CYCCkq4GqZThojAIKLHZfngObQ6VOIKcYZSUQnPOmQLNVXniyefk0CPQutNlt8vbn1bZ56qE6RZxZOgu+9SlC5rNgiXGdIs4EXS3p+tnXkJXq2ofA2kvz9ICe405OfRYrpEqVGQ3EQPSAfK++JTovc8zQHeR5ZhXV9rKqewwgLXrcK9xZOjTDh7qm9BeBSUGlPg26fDrFiC+Tb7O8vjQJ42wRVP5aHObA++GnwtKnQsQKXvDk8OIYWUgdvUic3LoO1DpawBp12/pa6QV2Kuel6/FPgMk/s9kDjnkkEMOOeTQN6G/qMW+65RwbLIAAAAASUVORK5CYII=', 150000.00, '2025-11-25 10:32:37.982816', 'c40c5f35f2344ccaac2a7d8f3b4b98b9', 1, NULL, 1),
	(294, 'iVBORw0KGgoAAAANSUhEUgAAAXIAAAFyAQAAAADAX2ykAAAClklEQVR4nO2bQW7jMAxFH8cGspSBHmCOolxtjtQb2EfJAQrYywI2/iwoxWkGM2nRNLUH5CJQpLf4gEJRJBUTH7Hhx4dwCD744IMPPvjg/8ZbsRaGbvGRHVkMprp2fKCe4O/MZ0nSCDC1SONi6qeDgEaSpLf8V+sJ/s78VDy0fCQJWAwAd+zH6gn+q/gk6Ve3GEPXyI7frif4z/Dt9UR+NpRPBxksJqbH6gn+vnzd3yRgAoYOjPRq5L6sXZZAtqY/+Hfxg5mZdUAeG5FPB8FULtFmZvZYPcHfiXf/fVOkXAzSqwlmdLW2Of3B3zBPfvIIQCP1NII0+9eLBUlSvzX9wd+wsm9J8iS49+lGkmaksRGsq1vTH/wNK/7rewllpNkjcdl9zr+DrekP/t9W78/TkyDNrQZrZPm5Q0yLielptrzG4K3pD/6GFRcdAT+Vx0bq04z6pDoC4nzeJe/+W7Kf9GKQZiyfDrJ8MoCDLOuMbE1/8DdsjbAecMuIcrU6z0X83SVf/Te9tHjVymOtsNzP1Lmlxumt6Q/+htX8aEa9x1/8Eu2rHoQJ/90pf86PapLUw+XVqmx35L875df8aNZgUO9SRilCp7mFqatlyq3pD/6d/GJ29KrkYupTCb3ecxh+xvuNnfIX9SuvNa+VLGjKrvp1Os7nHfK1vlHtas5DL2mO+sae+fX9pDSCede3Wwym1iNxaTxsU3/wN/jz+0k7JsmfTnprsEbix+oJ/k78Zf83116g94/W+AvE+fyf8PnUwmAHqU+v9ma7v0VP8J/i/3g/CWB57Ez51CImA28XPkRP8Pflr99PCmYYusY91ry+keaoP++TZ82K8AdXtRwNtRztPeHIf/fIW/y/O/jggw8++OAfzv8G633Zp+0rrA4AAAAASUVORK5CYII=', 150000.00, '2025-12-01 07:12:33.569978', 'a09732f2ef27437fb0200a9782756a1b', 1, NULL, 2);

-- Dumping structure for table sport.payment
CREATE TABLE IF NOT EXISTS `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `payment_method` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `payment_status` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `transaction_code` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `expiration_time` datetime(6) NOT NULL,
  `order_id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `order_id` (`order_id`),
  UNIQUE KEY `transaction_code` (`transaction_code`),
  CONSTRAINT `payment_order_id_98f7562d_fk_order_order_id` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.payment: ~3 rows (approximately)
INSERT INTO `payment` (`payment_id`, `payment_method`, `payment_status`, `transaction_code`, `created_at`, `expiration_time`, `order_id`) VALUES
	(1, 'momo', 'success', 'abc', '2025-11-25 13:41:53.000000', '2025-11-25 13:41:55.000000', '03ef3180572949f4b15344aed2e7be51'),
	(4, 'cash', 'success', 'CASH-a09732f2-ef27-437f-b020-0a9782756a1b-1764573152', '2025-12-01 07:12:32.887584', '2025-04-30 17:00:00.000000', 'a09732f2ef27437fb0200a9782756a1b'),
	(5, 'cash', 'success', 'abc12', '2025-12-18 16:51:55.000000', '2025-12-18 16:51:56.000000', '02322224dfsdfdsfdfsdssfsdsd');

-- Dumping structure for table sport.price_history
CREATE TABLE IF NOT EXISTS `price_history` (
  `p_history_id` int NOT NULL AUTO_INCREMENT,
  `old_price` decimal(10,2) NOT NULL,
  `new_price` decimal(10,2) NOT NULL,
  `effective_date` datetime(6) NOT NULL,
  `changed_at` datetime(6) NOT NULL,
  `reason` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `changed_by_id` int NOT NULL,
  `pricing_id` int NOT NULL,
  PRIMARY KEY (`p_history_id`),
  KEY `price_history_changed_by_id_4009792c_fk_employee_id` (`changed_by_id`),
  KEY `price_history_pricing_id_44d4ed55_fk_section_price_pricing_id` (`pricing_id`),
  CONSTRAINT `price_history_changed_by_id_4009792c_fk_employee_id` FOREIGN KEY (`changed_by_id`) REFERENCES `employee` (`id`),
  CONSTRAINT `price_history_pricing_id_44d4ed55_fk_section_price_pricing_id` FOREIGN KEY (`pricing_id`) REFERENCES `section_price` (`pricing_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.price_history: ~1 rows (approximately)
INSERT INTO `price_history` (`p_history_id`, `old_price`, `new_price`, `effective_date`, `changed_at`, `reason`, `changed_by_id`, `pricing_id`) VALUES
	(1, 100.00, 200.00, '2025-11-25 14:22:26.000000', '2025-11-25 14:22:27.000000', 'abc', 11, 1);

-- Dumping structure for table sport.promotion
CREATE TABLE IF NOT EXISTS `promotion` (
  `promo_id` int NOT NULL AUTO_INCREMENT,
  `promo_code` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `discount_value` decimal(10,2) NOT NULL,
  `discount_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `start_time` datetime(6) NOT NULL,
  `end_time` datetime(6) NOT NULL,
  `usage_limit` int NOT NULL,
  `description` longtext COLLATE utf8mb4_general_ci,
  `status` tinyint(1) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`promo_id`),
  UNIQUE KEY `promo_code` (`promo_code`),
  KEY `promotion_user_id_3df35996_fk_employee_id` (`user_id`),
  CONSTRAINT `promotion_user_id_3df35996_fk_employee_id` FOREIGN KEY (`user_id`) REFERENCES `employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.promotion: ~1 rows (approximately)
INSERT INTO `promotion` (`promo_id`, `promo_code`, `discount_value`, `discount_type`, `start_time`, `end_time`, `usage_limit`, `description`, `status`, `user_id`) VALUES
	(1, 'ABC', 10.00, 'percentage', '2025-12-04 11:47:00.000000', '2025-12-27 11:47:00.000000', 10, 'giảm dịp giáng sinh', 1, 2);

-- Dumping structure for table sport.promotion_detail
CREATE TABLE IF NOT EXISTS `promotion_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `match_id` int NOT NULL,
  `promo_id` int NOT NULL,
  `section_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_promo_match_section` (`promo_id`,`match_id`,`section_id`),
  KEY `promotion_detail_match_id_0de2c18b_fk_match_match_id` (`match_id`),
  KEY `promotion_detail_section_id_b53a14b6_fk_section_section_id` (`section_id`),
  CONSTRAINT `promotion_detail_match_id_0de2c18b_fk_match_match_id` FOREIGN KEY (`match_id`) REFERENCES `match` (`match_id`),
  CONSTRAINT `promotion_detail_promo_id_007c9c61_fk_promotion_promo_id` FOREIGN KEY (`promo_id`) REFERENCES `promotion` (`promo_id`),
  CONSTRAINT `promotion_detail_section_id_b53a14b6_fk_section_section_id` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.promotion_detail: ~0 rows (approximately)

-- Dumping structure for table sport.seat
CREATE TABLE IF NOT EXISTS `seat` (
  `seat_id` int NOT NULL AUTO_INCREMENT,
  `seat_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `seat_number` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `status` int NOT NULL,
  `section_id` int NOT NULL,
  PRIMARY KEY (`seat_id`),
  UNIQUE KEY `seat_code` (`seat_code`),
  KEY `seat_section_id_5b7568e1_fk_section_section_id` (`section_id`),
  CONSTRAINT `seat_section_id_5b7568e1_fk_section_section_id` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.seat: ~10 rows (approximately)
INSERT INTO `seat` (`seat_id`, `seat_code`, `seat_number`, `status`, `section_id`) VALUES
	(1, '111acx', '554', 0, 1),
	(2, '111bx', '222', 0, 1),
	(3, '11bx', '4444', 0, 1),
	(4, '11bxx', '3455', 0, 10),
	(5, '12bc', '234', 1, 10),
	(6, '23bv', '454', 0, 10),
	(7, 'HEATA1', '1', 0, 14),
	(8, 'HEATA2', '2', 0, 14),
	(9, 'HEATA3', '3', 0, 14),
	(10, 'HEATA4', '4', 0, 14);

-- Dumping structure for table sport.section
CREATE TABLE IF NOT EXISTS `section` (
  `section_id` int NOT NULL AUTO_INCREMENT,
  `section_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `capacity` int NOT NULL,
  `stadium_id` int NOT NULL,
  PRIMARY KEY (`section_id`),
  UNIQUE KEY `unique_stadium_section_name` (`stadium_id`,`section_name`),
  CONSTRAINT `section_stadium_id_9aecacd0_fk_stadium_stadium_id` FOREIGN KEY (`stadium_id`) REFERENCES `stadium` (`stadium_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.section: ~14 rows (approximately)
INSERT INTO `section` (`section_id`, `section_name`, `capacity`, `stadium_id`) VALUES
	(1, 'A', 3, 1),
	(2, 'B', 18000, 1),
	(3, 'C', 20000, 1),
	(4, 'A', 15000, 2),
	(5, 'B', 18000, 2),
	(6, 'C', 20000, 2),
	(7, 'A', 10, 3),
	(8, 'B', 11, 3),
	(9, 'C', 12, 3),
	(10, 'D', 1000, 1),
	(11, 'A', 200, 4),
	(12, 'B', 500, 4),
	(13, 'C', 200, 4),
	(14, 'D', 4, 4);

-- Dumping structure for table sport.section_price
CREATE TABLE IF NOT EXISTS `section_price` (
  `pricing_id` int NOT NULL AUTO_INCREMENT,
  `price` decimal(10,2) NOT NULL,
  `available_seats` int NOT NULL,
  `is_closed` tinyint(1) NOT NULL,
  `sell_date` datetime(6) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `match_id` int NOT NULL,
  `section_id` int NOT NULL,
  PRIMARY KEY (`pricing_id`),
  UNIQUE KEY `unique_match_section` (`match_id`,`section_id`),
  KEY `section_price_section_id_0629ec4b_fk_section_section_id` (`section_id`),
  CONSTRAINT `section_price_match_id_4463eea9_fk_match_match_id` FOREIGN KEY (`match_id`) REFERENCES `match` (`match_id`),
  CONSTRAINT `section_price_section_id_0629ec4b_fk_section_section_id` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.section_price: ~15 rows (approximately)
INSERT INTO `section_price` (`pricing_id`, `price`, `available_seats`, `is_closed`, `sell_date`, `created_at`, `match_id`, `section_id`) VALUES
	(1, 150000.00, 2, 1, '2025-11-19 08:23:00.000000', '2025-11-19 08:23:00.000000', 1, 1),
	(2, 120.00, 17000, 1, '2025-11-19 08:23:00.000000', '2025-11-19 08:23:00.000000', 1, 2),
	(3, 90.00, 19000, 1, '2025-11-19 08:23:00.000000', '2025-11-19 08:23:00.000000', 1, 3),
	(4, 150.00, 14000, 0, '2025-11-19 08:23:00.000000', '2025-11-19 08:23:00.000000', 2, 4),
	(5, 120.00, 17000, 0, '2025-11-19 08:23:00.000000', '2025-11-19 08:23:00.000000', 2, 5),
	(6, 90.00, 19000, 0, '2025-11-19 08:23:00.000000', '2025-11-19 08:23:00.000000', 2, 6),
	(7, 150.00, 14000, 1, '2025-11-19 08:23:00.000000', '2025-11-19 08:23:00.000000', 3, 7),
	(8, 120.00, 17000, 1, '2025-11-19 08:23:00.000000', '2025-11-19 08:23:00.000000', 3, 8),
	(9, 90.00, 19000, 1, '2025-11-19 08:23:00.000000', '2025-11-19 08:23:00.000000', 3, 9),
	(10, 150.00, 4, 1, '2025-11-19 08:23:00.000000', '2025-11-19 08:23:00.000000', 4, 7),
	(11, 120.00, 3, 1, '2025-11-19 08:23:00.000000', '2025-11-19 08:23:00.000000', 4, 8),
	(12, 90.00, 2, 1, '2025-11-19 08:23:00.000000', '2025-11-19 08:23:00.000000', 4, 9),
	(14, 100000.00, 2, 1, '2025-11-28 09:53:00.000000', '2025-11-26 09:54:09.950953', 1, 10),
	(15, 150000.00, 8, 0, '2025-12-16 16:52:00.000000', '2025-12-16 16:49:30.087854', 5, 1),
	(16, 100000.00, 3, 1, '2025-12-15 16:42:38.000000', '2025-12-18 16:42:39.000000', 7, 14);

-- Dumping structure for table sport.sport
CREATE TABLE IF NOT EXISTS `sport` (
  `sport_id` int NOT NULL AUTO_INCREMENT,
  `sport_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`sport_id`),
  UNIQUE KEY `sport_name` (`sport_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.sport: ~2 rows (approximately)
INSERT INTO `sport` (`sport_id`, `sport_name`, `description`) VALUES
	(1, 'Football', 'Football match system'),
	(2, 'Basketball', 'Basketball match system');

-- Dumping structure for table sport.stadium
CREATE TABLE IF NOT EXISTS `stadium` (
  `stadium_id` int NOT NULL AUTO_INCREMENT,
  `stadium_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `stadium_code` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `capacity` int DEFAULT NULL,
  `stadium_layouts` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`stadium_id`),
  UNIQUE KEY `stadium_name` (`stadium_name`),
  UNIQUE KEY `stadium_code` (`stadium_code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.stadium: ~4 rows (approximately)
INSERT INTO `stadium` (`stadium_id`, `stadium_name`, `stadium_code`, `location`, `capacity`, `stadium_layouts`) VALUES
	(1, 'Old Trafford', 'OTR', 'Manchester, UK', 74000, 'Layout A'),
	(2, 'Anfield', 'ANF', 'Liverpool, UK', 54000, 'Layout A'),
	(3, 'Camp Nou', 'CPN', 'Barcelona, Spain', 99000, 'Layout B'),
	(4, 'Hồ Xuân Hương', 'ABC', 'TPHCM,VietNam', 1000, 'Layout A');

-- Dumping structure for table sport.team
CREATE TABLE IF NOT EXISTS `team` (
  `team_id` int NOT NULL AUTO_INCREMENT,
  `team_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `logo` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `head_coach` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `rating` int NOT NULL,
  `sport_id` int NOT NULL,
  PRIMARY KEY (`team_id`),
  UNIQUE KEY `unique_team_name_per_sport` (`sport_id`,`team_name`),
  CONSTRAINT `team_sport_id_0846fb5e_fk_sport_sport_id` FOREIGN KEY (`sport_id`) REFERENCES `sport` (`sport_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.team: ~6 rows (approximately)
INSERT INTO `team` (`team_id`, `team_name`, `logo`, `head_coach`, `description`, `rating`, `sport_id`) VALUES
	(1, 'Manchester United', NULL, 'Erik ten Hag', 'Premier League club', 5, 1),
	(2, 'Liverpool', NULL, 'Jurgen Klopp', 'Premier League club', 5, 1),
	(3, 'Barcelona', NULL, 'Hansi Flick', 'La Liga club', 5, 1),
	(4, 'Real Madrid', NULL, 'Carlo Ancelotti', 'La Liga club', 5, 1),
	(5, 'SaiGon Heat', NULL, 'ABC', 'abc', 5, 2),
	(6, 'HCM City Wings', NULL, 'BCD', 'abc', 5, 2);

-- Dumping structure for table sport.ticket_return
CREATE TABLE IF NOT EXISTS `ticket_return` (
  `return_id` int NOT NULL AUTO_INCREMENT,
  `return_reason` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `return_status` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `refund_method` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `return_time` datetime(6) NOT NULL,
  `processed_time` datetime(6) DEFAULT NULL,
  `refund_amount` decimal(10,2) DEFAULT NULL,
  `note` longtext COLLATE utf8mb4_general_ci,
  `detail_id` int NOT NULL,
  `employee_id` int DEFAULT NULL,
  PRIMARY KEY (`return_id`),
  UNIQUE KEY `detail_id` (`detail_id`),
  KEY `ticket_return_employee_id_93879c5f_fk_employee_id` (`employee_id`),
  CONSTRAINT `ticket_return_detail_id_5a3698d3_fk_order_detail_detail_id` FOREIGN KEY (`detail_id`) REFERENCES `order_detail` (`detail_id`),
  CONSTRAINT `ticket_return_employee_id_93879c5f_fk_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table sport.ticket_return: ~0 rows (approximately)
INSERT INTO `ticket_return` (`return_id`, `return_reason`, `return_status`, `refund_method`, `return_time`, `processed_time`, `refund_amount`, `note`, `detail_id`, `employee_id`) VALUES
	(1, 'abc', 'pending', 'cash', '2025-12-02 12:00:27.000000', '2025-12-02 19:00:28.000000', 500.00, 'avc', 1, 11);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
