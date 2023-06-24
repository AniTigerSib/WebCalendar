<?php
require('dbconnect.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = $_SESSION['user_id'];
    $lastname = $_POST["lastname"];
    $firstname = $_POST["firstname"];
    $email = $_POST["email"];
    if (!empty($_FILES["photo"]["tmp_name"])){
        // Обработка загруженной фотографии
        $targetDir = "uploads/";
        $filename = "avatar." . $user_id; // Генерация нового имени файла
        $targetFile = $targetDir . $filename;
        $imageFileType = strtolower(pathinfo($targetFile, PATHINFO_EXTENSION));
        $maxFileSize = 2 * 1024 * 1024; // 2MB

        // Проверка размера файла
        if ($_FILES["photo"]["size"] > $maxFileSize) {
            echo "Ошибка: превышен максимальный размер файла.";
            exit;
        }

        // Проверка типа файла
        $allowedTypes = array("image/jpg", "image/jpeg", "image/png");
        if (!in_array($_FILES["photo"]["type"], $allowedTypes)) {
            echo "Ошибка: разрешены только файлы JPG, JPEG и PNG.";
            exit;
        }

        if (file_exists($targetFile)) {
            unlink($targetFile);
        }
        
        // Перемещение файла в папку назначения с новым именем
        if (move_uploaded_file($_FILES["photo"]["tmp_name"], $targetFile)) {
            echo "Фотография успешно загружена.";

            // Сохранение нового имени файла в базе данных
            $stmt = $conn->prepare("UPDATE users SET user_avatar = ?, last_name = ?, first_name = ?, email = ? WHERE user_id = ?");
            $stmt->bind_param("ssssi", $filename, $lastname, $firstname, $email, $user_id);
            $stmt->execute();
            $stmt->close();
            header("Location: index.php");
        } else {
            echo "Ошибка при загрузке файла.";
            exit;
        }
    }
    else {
        $stmt2 = $conn->prepare("UPDATE users SET last_name = ?, first_name = ?, email = ? WHERE user_id = ?");
        $stmt2->bind_param("sssi", $lastname, $firstname, $email, $user_id);
        $stmt2->execute();
        $stmt2->close();
        header("Location: index.php");
    }
} else {
    echo "Ошибка обработки формы.";
    header("Location: index.php");
    exit;
}