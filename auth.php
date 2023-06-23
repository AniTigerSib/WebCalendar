<?php
require('dbconnect.php');

if (isset($_POST['login'])) {
    $login = $_POST['login'];
    $password = $_POST['password'];
    $_SESSION['error_id'] = 0;

    // Выполняем запрос к базе данных для выборки пользователя по login
    $query = $conn->prepare("SELECT * FROM users WHERE login = ?");
    $query->bind_param("s", $login);
    $query->execute();
    $result = $query->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();

        // Хешируем пароль с использованием соли из базы данных
        $hashedPassword = hash('sha256', $password . $row['salt']);

        if ($hashedPassword == $row['password']) {
            // Авторизация успешна
            $_SESSION['username'] = $_POST['login'];
            $_SESSION['user_id'] = $row['user_id'];
            $_SESSION['message'] = 'Вы успешно вошли в систему';
            header("Location: index.php");
            die();
        } else {
            // Неправильный пароль
            $_SESSION['login_error'] = 1;
            $_SESSION['message'] = 'Неверный пароль!';
            header("Location: index.php?page=login");
            die();
        }
    } else {
        // Пользователь с указанным login не найден
        $_SESSION['login_error'] = 1;
        $_SESSION['message'] = 'Пользователь с указанным логином не найден!';
        header("Location: index.php?page=login");
        die();
    }
}

if ($_GET['logout'] == 1) {
    unset($_SESSION['username']);
    unset($_SESSION['user_id']);
    $_SESSION['message'] = 'Вы успешно вышли из системы';
    header("Location: index.php");
    die();
}

header("Location: index.php?page=login");
die();
?>