<form method="post" action="reg.php" id="regForm" class="login__main">
    <h2>Регистрация</h2>
    <div class="login__main__inputBx">
        <input type="text" name="login" id="register_username_field" placeholder="Придумайте логин">
    </div>
    <span id="register_username_error" class="error"></span>
    <div class="login__main__inputBx">
        <input type="text" name="email" id="register_email_field" placeholder="Введите почту">
    </div>
    <span id="register_email_error" class="error"></span>
    <div class="login__main__inputBx">
        <input type="password" name="password" id="register_password_field" placeholder="Придумайте пароль">
    </div>
    <span id="register_password_error" class="error"></span>
    <div class="login__main__inputBx">
        <input type="password" name="password_accept" id="register_password_accept" placeholder="Повторите пароль">
    </div>
    <span id="register_password_accept_error" class="error"></span>
    <?php if ($_SESSION['register_error']) : ?>
        <span id="register_error">
            <?php echo ($_SESSION['message']) ?>
        </span>
    <?php endif;
    $_SESSION['register_error'] = 0; ?>
    <div class="login__main__inputBx">
        <input type="submit" id="register_submit_button" class="enabled_button" value="Зарегистрироваться">
    </div>
    <div class="login__main__links register_links">
        <a href="index.php?page=login">Уже есть аккаунт?</a>
    </div>
</form>