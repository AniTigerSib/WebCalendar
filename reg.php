<?php
require('dbconnect.php');

if (isset($_POST['login'])) {
    $login = $_POST['login'];
    $password = $_POST['password'];
    $email = $_POST['email'];
    $_SESSION['register_error'] = 0;

    // Генерация случайной соли
    $salt = bin2hex(openssl_random_pseudo_bytes(16)); // 16 байтов = 32 символа в hex формате

    // Хеширование пароля с использованием соли
    $hashedPassword = hash('sha256', $password . $salt);

    // Проверка на уникальность email
    $checkEmailQuery = $conn->prepare("SELECT * FROM users WHERE email = ?");
    $checkEmailQuery->bind_param("s", $email);
    $checkEmailQuery->execute();
    $result = $checkEmailQuery->get_result();

    if ($result->num_rows > 0) {
        // Email уже существует
        $_SESSION['register_error'] = 1;
        $_SESSION['message'] = 'Пользователь с таким email уже зарегистрирован';
        header("Location: index.php?page=register");
        die();
    }

    // Проверка на уникальность логина
    $checkLoginQuery = $conn->prepare("SELECT * FROM users WHERE login = ?");
    $checkLoginQuery->bind_param("s", $login);
    $checkLoginQuery->execute();
    $result = $checkLoginQuery->get_result();

    if ($result->num_rows > 0) {
        // Логин уже существует
        $_SESSION['register_error'] = 1;
        $_SESSION['message'] = 'Пользователь с таким логином уже зарегистрирован';
        header("Location: index.php?page=register");
        die();
    }

    // Подготовка и выполнение SQL-запроса на вставку новой записи в таблицу 'users'
    $insertQuery = $conn->prepare("INSERT INTO users (login, password, salt, email) VALUES (?, ?, ?, ?)");
    $insertQuery->bind_param("ssss", $login, $hashedPassword, $salt, $email);
    
    if ($insertQuery->execute()) {
        // Регистрация прошла успешно
        $_SESSION['login_error'] = 1;
        $_SESSION['register_error'] = 0;
        $_SESSION['message'] = 'Вы успешно зарегистрировались!<br>Войдите для продолжения.';
        header("Location: index.php?page=login");
        die();
    } else {
        // Ошибка при выполнении запроса
        $_SESSION['register_error'] = 1;
        $_SESSION['message'] = 'Ошибка при регистрации. Пожалуйста, попробуйте снова.';
        header("Location: index.php?page=register");
        die();
    }
}

header("Location: index.php?page=register");
die();