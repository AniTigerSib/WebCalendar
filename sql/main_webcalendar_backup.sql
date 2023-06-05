-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Июн 05 2023 г., 13:22
-- Версия сервера: 10.4.27-MariaDB
-- Версия PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `main_webcalendar_backup`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_event_creator_status` ()   BEGIN
    UPDATE events
    SET event_name = CONCAT(event_name, ' (Автор события удалён)')
    WHERE creator_id IS NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_table_column_value` (IN `tableName` VARCHAR(255), IN `columnName` VARCHAR(255), IN `conditionColumn` VARCHAR(255), IN `conditionValue` VARCHAR(255), IN `newValue` VARCHAR(255))   BEGIN
    SET @query = CONCAT('UPDATE ', tableName, ' SET ', columnName, ' = ', newValue, ' WHERE ', conditionColumn, ' = ''', conditionValue, '''');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

--
-- Функции
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_all_events_for_currunt_user_and_day` (`userId` INT, `eventDate` DATE) RETURNS INT(11)  BEGIN
	DECLARE eventCount INT;
    
    SELECT COUNT(*)
    INTO eventCount
	FROM events as e
	WHERE ((e.creator_id = userId and e.is_group_event = 0) OR (e.group_id IN(SELECT group_id FROM group_users WHERE user_id = userId)))
      AND DATE(event_date) = eventDate;
      
	RETURN eventCount;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_all_recurring_events_for_currunt_group` (`groupId` INT) RETURNS INT(11)  BEGIN
	DECLARE eventCount INT;
    
    SELECT COUNT(*)
    INTO eventCount
	FROM events as e
	WHERE e.group_id = groupId and e.is_recurring = 1;
      
	RETURN eventCount;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `events`
--

CREATE TABLE `events` (
  `event_id` int(11) NOT NULL,
  `event_name` varchar(200) NOT NULL COMMENT 'Название события',
  `creator_id` int(11) NOT NULL,
  `is_group_event` tinyint(1) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `event_date` date NOT NULL,
  `is_recurring` tinyint(1) NOT NULL,
  `repeat_interval` int(11) DEFAULT NULL COMMENT 'Интервал повторений события',
  `recurring_end_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `has_exceptions` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `events`
--

INSERT INTO `events` (`event_id`, `event_name`, `creator_id`, `is_group_event`, `group_id`, `event_date`, `is_recurring`, `repeat_interval`, `recurring_end_date`, `start_time`, `end_time`, `has_exceptions`) VALUES
(1, 'Event 7626', 1, 0, NULL, '2023-05-01', 0, NULL, NULL, '10:00:00', '11:00:00', 1),
(2, 'Event 9813', 2, 0, NULL, '2023-05-05', 0, NULL, NULL, '14:00:00', '16:00:00', 0),
(3, 'Event 6187', 3, 1, 1, '2023-05-08', 1, 7, '2023-06-30', '09:30:00', '10:30:00', 1),
(4, 'Event 1499', 4, 0, NULL, '2023-05-10', 0, NULL, NULL, '16:00:00', '17:30:00', 1),
(5, 'Event 8936', 5, 0, NULL, '2023-05-15', 1, 14, '2023-08-01', '13:00:00', '14:30:00', 1),
(6, 'Event 180', 6, 1, 2, '2023-05-18', 0, NULL, NULL, '10:30:00', '12:00:00', 0),
(7, 'Event 4093', 7, 1, 3, '2023-05-20', 1, 7, '2023-07-31', '15:00:00', '16:00:00', 1),
(8, 'Event 9926', 8, 0, NULL, '2023-05-25', 0, NULL, NULL, '11:00:00', '12:30:00', 0),
(9, 'Event 7353', 9, 0, NULL, '2023-05-28', 1, 30, '2023-08-31', '18:00:00', '19:00:00', 0),
(10, 'Event 6987', 10, 1, 4, '2023-06-01', 0, NULL, NULL, '09:00:00', '10:00:00', 1),
(11, 'Event 2878', 11, 0, NULL, '2023-06-05', 0, NULL, NULL, '13:00:00', '14:30:00', 0),
(12, 'Event 3426', 12, 0, NULL, '2023-06-10', 1, 7, '2023-07-31', '16:00:00', '17:30:00', 1),
(13, 'Event 8500', 13, 1, 1, '2023-06-15', 1, 14, '2023-09-01', '10:00:00', '11:30:00', 0),
(14, 'Event 2221', 14, 1, 2, '2023-06-18', 0, NULL, NULL, '14:30:00', '16:00:00', 0),
(15, 'Event 5605', 15, 0, NULL, '2023-06-20', 0, NULL, NULL, '09:30:00', '11:00:00', 1),
(16, 'Event 1362', 16, 0, NULL, '2023-06-25', 1, 30, '2023-08-31', '15:00:00', '16:30:00', 0),
(17, 'Event 9995', 17, 1, 3, '2023-07-02', 1, 7, '2023-08-31', '11:00:00', '12:30:00', 0),
(18, 'Event 5892', 18, 0, NULL, '2023-07-05', 0, NULL, NULL, '14:00:00', '15:30:00', 1),
(19, 'Event 9474', 19, 0, NULL, '2023-07-10', 0, NULL, NULL, '10:30:00', '11:30:00', 0),
(20, 'Event 9694', 20, 1, 4, '2023-07-15', 1, 14, '2023-09-01', '16:00:00', '17:30:00', 1),
(21, 'Event 48', 21, 0, NULL, '2023-07-20', 0, NULL, NULL, '12:00:00', '13:00:00', 0),
(22, 'Event 1157', 22, 0, NULL, '2023-07-25', 1, 30, '2023-10-31', '09:30:00', '11:00:00', 0),
(23, 'Event 5643', 1, 1, 1, '2023-08-01', 0, NULL, NULL, '14:30:00', '16:00:00', 1),
(24, 'Event 4746', 2, 0, NULL, '2023-08-05', 0, NULL, NULL, '10:00:00', '11:30:00', 0),
(25, 'Event 6800', 3, 0, NULL, '2023-08-10', 1, 7, '2023-09-30', '16:00:00', '17:30:00', 0),
(26, 'Event 9765', 4, 1, 2, '2023-08-15', 1, 14, '2023-11-01', '09:00:00', '10:30:00', 1),
(27, 'Event 8422', 5, 1, 3, '2023-08-18', 0, NULL, NULL, '13:30:00', '14:30:00', 1),
(28, 'Event 2817', 6, 0, NULL, '2023-08-20', 0, NULL, NULL, '11:00:00', '12:00:00', 0),
(29, 'Event 8820', 7, 0, NULL, '2023-08-25', 1, 30, '2023-11-30', '15:00:00', '16:00:00', 0),
(30, 'Event 5649', 8, 1, 4, '2023-09-01', 0, NULL, NULL, '10:30:00', '12:00:00', 1),
(31, 'Event 1786', 9, 1, 5, '2023-09-05', 0, NULL, NULL, '14:00:00', '15:30:00', 0),
(32, 'Event 1981', 10, 1, 4, '2023-09-10', 1, 7, '2023-10-31', '10:00:00', '11:30:00', 0),
(33, 'Event 4549', 11, 0, NULL, '2023-09-15', 0, NULL, NULL, '16:30:00', '18:00:00', 0),
(34, 'Event 6804', 12, 0, NULL, '2023-09-20', 0, NULL, NULL, '11:30:00', '13:00:00', 0),
(35, 'Event 371', 13, 1, 1, '2023-09-25', 1, 30, '2023-12-31', '09:30:00', '11:00:00', 0),
(36, 'Event 1443', 14, 1, 2, '2023-10-01', 0, NULL, NULL, '13:00:00', '14:30:00', 0),
(37, 'Event 6104', 15, 0, NULL, '2023-10-05', 0, NULL, NULL, '09:00:00', '10:30:00', 0),
(38, 'Event 6190', 16, 0, NULL, '2023-10-10', 1, 7, '2023-11-30', '16:00:00', '17:30:00', 0),
(39, 'Event 2639', 17, 1, 3, '2023-10-15', 1, 14, '2023-12-31', '10:30:00', '12:00:00', 0),
(40, 'Event 4628', 18, 0, NULL, '2023-10-20', 0, NULL, NULL, '15:00:00', '16:30:00', 0),
(41, 'Event 5220', 19, 0, NULL, '2023-10-25', 1, 30, '2023-12-31', '11:30:00', '13:00:00', 0),
(42, 'Event 2220', 20, 1, 4, '2023-11-01', 0, NULL, NULL, '14:30:00', '16:00:00', 0),
(43, 'Event 5438', 21, 0, NULL, '2023-11-05', 0, NULL, NULL, '10:00:00', '11:30:00', 0),
(44, 'Event 530', 22, 0, NULL, '2023-11-10', 1, 7, '2023-12-31', '15:00:00', '16:30:00', 0),
(45, 'Event 6337', 1, 1, 1, '2023-11-15', 1, 14, '2024-01-31', '09:00:00', '10:30:00', 0),
(46, '', 5, 0, NULL, '2023-09-20', 0, NULL, NULL, '14:24:00', '16:00:00', 0),
(47, 'Event 2056', 12, 0, NULL, '2023-09-21', 0, NULL, NULL, '10:00:00', '12:00:00', 0),
(48, 'Event 1428', 5, 0, NULL, '2023-11-23', 0, NULL, NULL, '19:30:00', '20:00:00', 0),
(49, 'Event 1342', 17, 1, 3, '2023-05-25', 0, NULL, NULL, '12:00:00', '15:00:00', 0);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `events_by_current_user`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `events_by_current_user` (
`event_id` int(11)
,`event_name` varchar(200)
,`creator_id` int(11)
,`is_group_event` tinyint(1)
,`group_id` int(11)
,`event_date` date
,`is_recurring` tinyint(1)
,`repeat_interval` int(11)
,`recurring_end_date` date
,`start_time` time
,`end_time` time
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `events_by_user`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `events_by_user` (
`creator_id` int(11)
,`event_count` bigint(21)
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `events_with_group`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `events_with_group` (
`event_id` int(11)
,`event_name` varchar(200)
,`group_name` varchar(20)
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `events_with_long_duration`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `events_with_long_duration` (
`event_id` int(11)
,`creator_id` int(11)
,`is_group_event` tinyint(1)
,`group_id` int(11)
,`event_date` date
,`is_recurring` tinyint(1)
,`repeat_interval` int(11)
,`recurring_end_date` date
,`start_time` time
,`end_time` time
);

-- --------------------------------------------------------

--
-- Структура таблицы `event_exceptions`
--

CREATE TABLE `event_exceptions` (
  `exception_id` int(11) NOT NULL COMMENT 'ID исключения',
  `event_id` int(11) NOT NULL COMMENT 'ID события',
  `exception_start_date` date NOT NULL COMMENT 'Дата исключения',
  `exception_end_date` date NOT NULL COMMENT 'Дата окончания периода исключения (если он задан)',
  `new_start_time` time DEFAULT NULL COMMENT 'Время начала',
  `new_end_time` time DEFAULT NULL COMMENT 'Время окончания',
  `is_deleted` tinyint(1) NOT NULL COMMENT 'Флаг удаления'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `event_exceptions`
--

INSERT INTO `event_exceptions` (`exception_id`, `event_id`, `exception_start_date`, `exception_end_date`, `new_start_time`, `new_end_time`, `is_deleted`) VALUES
(1, 3, '2023-06-15', '2023-06-15', NULL, NULL, 1),
(2, 10, '2023-06-01', '2023-06-01', '10:30:00', '11:30:00', 0),
(3, 20, '2023-07-15', '2023-07-15', NULL, NULL, 1),
(4, 26, '2023-08-15', '2023-08-15', '09:30:00', '10:30:00', 0),
(5, 30, '2023-09-01', '2023-09-01', NULL, NULL, 1),
(6, 12, '2023-06-20', '2023-06-20', '16:30:00', '17:30:00', 0),
(7, 18, '2023-07-05', '2023-07-05', '14:30:00', '15:00:00', 0),
(8, 23, '2023-08-01', '2023-08-01', NULL, NULL, 1),
(9, 27, '2023-08-18', '2023-08-18', '13:30:00', '14:00:00', 0),
(10, 15, '2023-06-20', '2023-06-20', '09:00:00', '10:00:00', 0),
(11, 7, '2023-05-20', '2023-05-20', NULL, NULL, 1),
(12, 5, '2023-05-15', '2023-05-15', '12:30:00', '13:30:00', 0),
(13, 1, '2023-05-01', '2023-05-01', '11:30:00', '12:30:00', 0),
(14, 4, '2023-05-10', '2023-05-10', '16:30:00', '18:00:00', 0);

--
-- Триггеры `event_exceptions`
--
DELIMITER $$
CREATE TRIGGER `update_has_exceptions` AFTER INSERT ON `event_exceptions` FOR EACH ROW BEGIN 
    IF (SELECT e.has_exceptions FROM events as e WHERE e.event_id = NEW.event_id) = 0 THEN 
    	UPDATE events as e SET e.has_exceptions = 1 WHERE e.event_id = NEW.event_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `groups`
--

CREATE TABLE `groups` (
  `group_id` int(11) NOT NULL COMMENT 'ID группы',
  `group_name` varchar(20) NOT NULL COMMENT 'Название группы',
  `creator_id` int(11) NOT NULL COMMENT 'ID создателя',
  `date_of_creation` date NOT NULL COMMENT 'Дата создания группы'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `groups`
--

INSERT INTO `groups` (`group_id`, `group_name`, `creator_id`, `date_of_creation`) VALUES
(1, 'Random group', 3, '2022-01-01'),
(2, 'Группа 1', 1, '2022-02-14'),
(3, 'Команда 1', 7, '2022-03-10'),
(4, 'Someones', 2, '2022-04-23'),
(5, 'Dreamteam', 4, '2022-05-08'),
(6, 'Тестирование', 11, '2022-06-18');

--
-- Триггеры `groups`
--
DELIMITER $$
CREATE TRIGGER `cascade_delete_events_for_group` BEFORE DELETE ON `groups` FOR EACH ROW BEGIN 
	DELETE FROM event_exceptions
    WHERE (event_exceptions.event_id IN(SELECT e.event_id FROM events as e WHERE e.group_id = OLD.group_id));
    DELETE FROM events
    WHERE events.group_id = OLD.group_id;
    DELETE FROM group_users
    WHERE group_users.group_id = OLD.group_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `group_users`
--

CREATE TABLE `group_users` (
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `group_users`
--

INSERT INTO `group_users` (`group_id`, `user_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(3, 6),
(3, 7),
(3, 8),
(4, 9),
(5, 10),
(5, 11),
(6, 12),
(6, 21);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `longest_events_for_group`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `longest_events_for_group` (
`event_id` int(11)
,`event_name` varchar(200)
,`creator_id` int(11)
,`is_group_event` tinyint(1)
,`group_id` int(11)
,`event_date` date
,`is_recurring` tinyint(1)
,`repeat_interval` int(11)
,`recurring_end_date` date
,`start_time` time
,`end_time` time
,`has_exceptions` tinyint(1)
);

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `login` char(20) NOT NULL,
  `password` varchar(64) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`user_id`, `login`, `password`, `last_name`, `first_name`, `email`) VALUES
(1, 'AniTiger', 'skipskip', 'Khudoleev', 'Michael', 'example@mail.ru'),
(2, 'ExampleMan', 'skipskop', 'Example', 'Man', 'exampleman86@mail.ru'),
(3, 'john_doe', 'mypassword123', 'Doe', 'John', 'john.doe@example.com'),
(4, 'jane_smith', 'securepass456', 'Smith', 'Jane', 'jane.smith@example.com'),
(5, 'иван_иванов', 'пароль123', 'Иванов', 'Иван', 'ivan.ivanov@example.com'),
(6, 'sam_jackson', 'strongpass789', 'Jackson', 'Samantha', 'samantha.jackson@example.com'),
(7, 'robert_smith', 'secretword321', 'Smith', 'Robert', 'robert.smith@example.com'),
(8, 'emily_williams', 'pass123word', 'Williams', 'Emily', 'emily.williams_1234567890@example.com'),
(9, 'alex_johnson', 'alexpass456', 'Johnson', 'Alex', 'alex.johnson@example.com'),
(10, 'lisa_miller', 'lisapass789', 'Miller', 'Lisa', 'lisa.miller@example.com'),
(11, 'michael_brown', 'mikepass123', 'Brown', 'Michael', 'michael.brown@example.com'),
(12, 'sarah_davis', 'sarahpass321', 'Davis', 'Sarah', 'sarah.davis@example.com'),
(13, 'david_wilson', 'davidpass987', 'Wilson', 'David', 'david.wilson@example.com'),
(14, 'jennifer_thompson', 'jenniferpass654', 'Thompson', 'Jennifer', 'jennifer.thompson@example.com'),
(15, 'steven_clark', 'stevenpass789', 'Clark', 'Steven', 'steven.clark@example.com'),
(16, 'amy_hall', 'amypass123', 'Hall', 'Amy', 'amy.hall@example.com'),
(17, 'ryan_mitchell', 'ryanpass456', 'Mitchell', 'Ryan', 'ryan.mitchell@example.com'),
(18, 'jessica_adams', 'jessicapass789', 'Adams', 'Jessica', 'jessica.adams@example.com'),
(19, 'kevin_cook', 'kevinpass123', 'Cook', 'Kevin', 'kevin.cook@example.com'),
(20, 'melissa_turner', 'melissapass321', 'Turner', 'Melissa', 'melissa.turner@example.com'),
(21, 'patrick_rogers', 'patrickpass987', 'Rogers', 'Patrick', 'patrick.rogers@example.com'),
(22, 'natalie_parker', 'nataliepass654', 'Parker', 'Natalie', 'natalie.parker@mail.com');

-- --------------------------------------------------------

--
-- Структура для представления `events_by_current_user`
--
DROP TABLE IF EXISTS `events_by_current_user`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `events_by_current_user`  AS SELECT `events`.`event_id` AS `event_id`, `events`.`event_name` AS `event_name`, `events`.`creator_id` AS `creator_id`, `events`.`is_group_event` AS `is_group_event`, `events`.`group_id` AS `group_id`, `events`.`event_date` AS `event_date`, `events`.`is_recurring` AS `is_recurring`, `events`.`repeat_interval` AS `repeat_interval`, `events`.`recurring_end_date` AS `recurring_end_date`, `events`.`start_time` AS `start_time`, `events`.`end_time` AS `end_time` FROM `events` WHERE `events`.`creator_id` = 12WITH CASCADEDCHECK OPTION  ;

-- --------------------------------------------------------

--
-- Структура для представления `events_by_user`
--
DROP TABLE IF EXISTS `events_by_user`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `events_by_user`  AS SELECT `events`.`creator_id` AS `creator_id`, count(0) AS `event_count` FROM `events` GROUP BY `events`.`creator_id` ;

-- --------------------------------------------------------

--
-- Структура для представления `events_with_group`
--
DROP TABLE IF EXISTS `events_with_group`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `events_with_group`  AS SELECT `e`.`event_id` AS `event_id`, `e`.`event_name` AS `event_name`, `g`.`group_name` AS `group_name` FROM (`events` `e` join `groups` `g` on(`e`.`group_id` = `g`.`group_id`)) ;

-- --------------------------------------------------------

--
-- Структура для представления `events_with_long_duration`
--
DROP TABLE IF EXISTS `events_with_long_duration`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `events_with_long_duration`  AS SELECT `events`.`event_id` AS `event_id`, `events`.`creator_id` AS `creator_id`, `events`.`is_group_event` AS `is_group_event`, `events`.`group_id` AS `group_id`, `events`.`event_date` AS `event_date`, `events`.`is_recurring` AS `is_recurring`, `events`.`repeat_interval` AS `repeat_interval`, `events`.`recurring_end_date` AS `recurring_end_date`, `events`.`start_time` AS `start_time`, `events`.`end_time` AS `end_time` FROM `events` WHERE timediff(`events`.`end_time`,`events`.`start_time`) > '01:30:00' ;

-- --------------------------------------------------------

--
-- Структура для представления `longest_events_for_group`
--
DROP TABLE IF EXISTS `longest_events_for_group`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `longest_events_for_group`  AS SELECT `events`.`event_id` AS `event_id`, `events`.`event_name` AS `event_name`, `events`.`creator_id` AS `creator_id`, `events`.`is_group_event` AS `is_group_event`, `events`.`group_id` AS `group_id`, `events`.`event_date` AS `event_date`, `events`.`is_recurring` AS `is_recurring`, `events`.`repeat_interval` AS `repeat_interval`, `events`.`recurring_end_date` AS `recurring_end_date`, `events`.`start_time` AS `start_time`, `events`.`end_time` AS `end_time`, `events`.`has_exceptions` AS `has_exceptions` FROM `events` WHERE timediff(`events`.`end_time`,`events`.`start_time`) = (select max(timediff(`events`.`end_time`,`events`.`start_time`)) from `events` where `events`.`group_id` = 1) AND `events`.`group_id` = 1 ;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `event_creator` (`creator_id`),
  ADD KEY `group_event` (`group_id`);

--
-- Индексы таблицы `event_exceptions`
--
ALTER TABLE `event_exceptions`
  ADD PRIMARY KEY (`exception_id`),
  ADD KEY `parent_event` (`event_id`);

--
-- Индексы таблицы `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`group_id`),
  ADD KEY `creator_id` (`creator_id`) USING BTREE;

--
-- Индексы таблицы `group_users`
--
ALTER TABLE `group_users`
  ADD KEY `userID` (`user_id`) USING BTREE,
  ADD KEY `groupID` (`group_id`) USING BTREE;

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_login` (`login`),
  ADD UNIQUE KEY `user_email` (`email`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `events`
--
ALTER TABLE `events`
  MODIFY `event_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT для таблицы `event_exceptions`
--
ALTER TABLE `event_exceptions`
  MODIFY `exception_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID исключения', AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT для таблицы `groups`
--
ALTER TABLE `groups`
  MODIFY `group_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID группы', AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `creator` FOREIGN KEY (`creator_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `group_event` FOREIGN KEY (`group_id`) REFERENCES `groups` (`group_id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `event_exceptions`
--
ALTER TABLE `event_exceptions`
  ADD CONSTRAINT `parent_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `groups`
--
ALTER TABLE `groups`
  ADD CONSTRAINT `creator_id` FOREIGN KEY (`creator_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `group_users`
--
ALTER TABLE `group_users`
  ADD CONSTRAINT `group_id` FOREIGN KEY (`group_id`) REFERENCES `groups` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
--
-- События
--
CREATE DEFINER=`root`@`localhost` EVENT `procedures_calling` ON SCHEDULE EVERY 15 MINUTE STARTS '2023-05-20 10:02:35' ON COMPLETION NOT PRESERVE ENABLE DO CALL update_event_creator_status()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
