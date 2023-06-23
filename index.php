<?php
require("dbconnect.php");
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>WebCalendar</title>
    <link rel="stylesheet" href="sass/styles.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="js/script.js"></script>
</head>

<body>
    <div class="container_main">
        <div class="header">
            <a href="index.php" class="header__logo">
                <img src="media/logo.png">
            </a>
            <?php
            if (isset($_SESSION['username'])) {
                echo ('<div class="header__authenticated">
                    <a href="#" class="header__button">Группы</a>
                    <a href="#" class="header__button">Расписание</a>
                <div class="header__user">');
                echo ($_SESSION['username']);
                echo ('</div></div>');
            } else {
                echo ('<div class="header__unauthenticated">
                    <a href="index.php?page=login" class="header__button">Вход</a>
                    <a href="index.php?page=register" class="header__button">Регистрация</a>
                </div>');
            }
            ?>

        </div>
        <div class="main_page_content">
            <?php
            //require ("message.php");
            switch ($_GET['page']) {
                case 'login':
                    echo('<div class="login__body">
                    <div class="login__square width-greater" id="login_border">
                    <i style="--clr:#00ff0a;"></i>
                    <i style="--clr:#ff0057;"></i>
                    <i style="--clr:#fffd44;"></i>');
                    require("login.php");
                    echo ('</div>
                    </div>');
                    break;
                case 'register':
                    echo ('<div class="login__body">
                    <div class="login__square width-greater" id="login_border">
                    <i style="--clr:#00ff0a;"></i>
                    <i style="--clr:#ff0057;"></i>
                    <i style="--clr:#fffd44;"></i>');
                    require("register.php");
                    echo ('</div>
                    </div>');
                    break;
            }
            ?>
            <!-- <div class="left_panel">

            </div>
            <div class="calendar_page">

            </div> -->
        </div>
    </div>
</body>

</html>