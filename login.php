<form method="post" action="auth.php" class="login__main">
    <h2>Вход</h2>
    <div class="login__main__inputBx">
        <input type="text" name="login" id="username_field" placeholder="Логин">
    </div>
    <div class="login__main__inputBx">
        <input type="password" name="password" id="password_field" placeholder="Пароль">
    </div>
    <?php if ($_SESSION['login_error']) : ?>
        <div id="login_error">
            <?php echo ($_SESSION['message']) ?>
        </div>
    <?php endif;
    $_SESSION['login_error'] = 0; ?>
    <div class="login__main__inputBx">
        <input type="submit" class="enabled_button" value="Войти">
    </div>
    <div class="login__main__links">
        <a href="#">Забыли пароль?</a>
        <a href="index.php?page=register">Зарегистрироваться</a>
    </div>
</form>