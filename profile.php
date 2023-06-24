<div class="profile_page">
    <div class="left_panel">

    </div>
    <div class="right_panel">
        <?php
        if (isset($_SESSION['user_id'])) {
            $userId = $_SESSION['user_id'];

            // Запрос к базе данных для получения данных пользователя
            $userProfile = $conn->prepare("SELECT first_name, last_name, login, email FROM users WHERE user_id = ?");
            $userProfile->bind_param("s", $userId);
            $userProfile->execute();
            $result = $userProfile->get_result();

            if ($result->num_rows > 0) {
                $row = $result->fetch_assoc();
                $firstname = $row['first_name'];
                $lastname = $row['last_name'];
                $login = $row['login'];
                $email = $row['email'];
        ?>
                <div class="profile">
                    <h1>Профиль пользователя</h1>
                    <form action="update_profile.php" method="post" id="profileForm" enctype="multipart/form-data">
                        <label for="photo">Фотография:</label>
                        <input type="file" name="photo" id="photo" accept="image/*">
                        <small>(Максимальный размер: 2MB)</small>
                        <div class="input-group">
                            <input type="text" name="lastname" id="lastname" class="" value="<?php if (isset($lastname)){echo $lastname;} ?>" required>
                            <label for="lastname">Фамилия:</label>
                        </div>
                        <div class="input-group">
                            <input type="text" name="firstname" id="firstname" class="" value="<?php if(isset($firstname)){echo $firstname;} ?>" required>
                            <label for="firstname">Имя:</label>
                        </div>
                        <div class="input-group">
                            <input type="text" name="username" id="username" class="not_empty" value="<?php echo $login; ?>" readonly>
                            <label for="username">Логин:</label>
                        </div>
                        <div class="input-group">
                            <input type="email" name="email" id="email" class="" value="<?php echo $email; ?>" required>
                            <label for="email">Почта:</label>
                        </div>

                        <button type="submit">Сохранить</button>
                    </form>
                </div>
        <?php
            } else {
                echo "Пользователь не найден.";
            }
        } else {
            header("Location: index.php?page=login");
            die();
        }
        ?>
    </div>
</div>