<?php
// Параметры подключения к базе данных
$servername = "localhost";  // Имя сервера базы данных (обычно localhost)
$username = "root";  // Имя пользователя базы данных
$password = "";  // Пароль пользователя базы данных
$dbname = "main_webcalendar_backup";  // Имя базы данных, к которой вы хотите подключиться

ini_set('session.gc_maxlifetime', 1800); // Установка максимального времени жизни сессии в 30 минут (1800 секунд)
session_start(["use_strict_mode" => true, "cookie_secure" => true]);


// Создание подключения к базе данных
$conn = new mysqli($servername, $username, $password, $dbname);

// Проверка подключения на наличие ошибок
if ($conn->connect_error) {
    die("Ошибка подключения: " . $conn->connect_error);
}

// Установка кодировки соединения
$conn->set_charset("utf8");

// Ваш код для выполнения операций с базой данных...

// Закрытие соединения с базой данных
// $conn->close();
