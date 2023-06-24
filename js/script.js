$(document).ready(function() {
  size();
    //$('#login_error').hide();
    var currentPage = window.location.href;
    if (currentPage == 'http://localhost/index.php?page=register') {
      // При изменении значения любого из полей ввода
      $('#username_field, #password_field').on('input', function() {
        $('#login_error').hide();
    });
    //checkWidthGreaterThanHeight();
    }
    if(currentPage == 'http://localhost/index.php?page=profile') {
      checkProfileInput();
      $('#lastname, #firstname, #email').on('input', function () {
        checkProfileInput();
      });
      // $('#profileForm').on('submit', function(event) {
      //    event.preventDefault(); // Предотвращаем отправку формы по умолчанию

      //    if (validateNames('#lastname') && validateNames('#firstname') && validateProfileEmail()) {
      //      // Если форма прошла все проверки, можно выполнить отправку формы
      //      this.submit();
      //    }
      // });
  }
});

function size() {
  var sqrtValue = Math.sqrt(2);
  var maxWidthValue = 50 * $(window).width() * sqrtValue / 100; // Процент от ширины окна

  $('#login_body').css('max-width', maxWidthValue + 'px');
}

function checkProfileInput() {
  if ($('#lastname').val() === '') {
    $('#lastname').removeClass('not_empty');
  } else {
    $('#lastname').addClass('not_empty');
  }
  if ($('#firstname').val() === '') {
    $('#firstname').removeClass('not_empty');
  } else {
    $('#firstname').addClass('not_empty');
  }
  if ($('#email').val() === '') {
    $('#email').removeClass('not_empty');
  } else {
    $('#email').addClass('not_empty');
  }
}

// function checkWidthGreaterThanHeight() {
//   var width = $(window).width();
//   var height = $(window).height();
//   var currentPage = window.location.href;

//   if ((currentPage == 'http://localhost/index.php?page=register' || currentPage == 'http://localhost/index.php?page=login') && width > height) {
//     $("#login_border").addClass("width-greater");
//   } else {
//     $("#login_border").removeClass("width-greater");
//   }
// }
$(window).resize(function () { 
  var sqrtValue = Math.sqrt(2);
  var maxWidthValue = 50 * $(window).width() * sqrtValue / 100; // Процент от ширины окна

  $('#login_body').css('max-width', maxWidthValue + 'px');
});

//$(window).resize(checkWidthGreaterThanHeight);
window.onload = function() {
  var currentPage = window.location.href;
  if (currentPage === 'http://localhost/index.php?page=register') {
    validateEmptyForm();
    $('#register_username_error').hide();
    $('#register_email_error').hide();
    $('#register_password_error').hide();
    $('#register_password_accept_error').hide();
  }
};

$(document).ready(function() {
  if ($(window).width() < 400) {
    var listItem1 = '<li><a href="#">Группы</a></li>';
    var listItem2 = '<li><a href="#">Расписание</a></li>';

    $('#dropdown-menu ul').append(listItem1);
    $('#dropdown-menu ul').append(listItem2);
  }
});

$(document).ready(function() {
  $('#usermenu-btn').click(function(e) {
    e.stopPropagation();
    $('#dropdown-menu').slideDown();
    
  });

  $(document).click(function(e) {
    if ($('#dropdown-menu').is(":visible") && !$(e.target).closest('#dropdown-menu').length) {
      $('#dropdown-menu').slideUp();
    }
  });
});

$(document).ready(function() {
  var currentPage = window.location.href;
  if(currentPage == 'http://localhost/index.php?page=register') {
    $('#regForm').on('submit', function(event) {
         event.preventDefault(); // Предотвращаем отправку формы по умолчанию

         if (validateForm()) {
           // Если форма прошла все проверки, можно выполнить отправку формы
           this.submit();
         }
      });
  }
      $('#register_username_field, #register_email_field, #register_password_field, #register_password_accept').on('input', function () {
        $('#register_error').hide();
      });
      $('#register_username_field').on('input', function() {
        $('#register_username_error').hide();
        validateEmptyForm();
      });
      $('#register_username_field').on('blur', validateUsername);
      $('#register_email_field').on('input', function() {
        $('#register_email_error').hide();
        validateEmptyForm();
      });
      $('#register_email_field').on('blur', validateEmail);
      $('#register_password_field').on('input', function() {
        $('#register_password_error').hide();
        validateEmptyForm();
      });
      $('#register_password_field').on('blur', validatePassword);
      $('#register_password_accept').on('input', function() {
        $('#register_password_accept_error').hide();
        validateEmptyForm();
      });
      $('#register_password_accept').on('blur', validatePasswordAccept);
    });

    function validateForm() {
      let valid1 = validateEmptyForm();
      let valid2 = validateUsername();
      let valid3 = validateEmail();
      let valid4 = validatePassword();
      let valid5 = validatePasswordAccept();
      if (valid1 && valid2 && valid3 && valid4 && valid5){
        return true;
      } else {
        return false;
      }
    }

    function validateEmptyForm() {
      let isValid = true;

      if ($('#register_username_field').val() === '' || $('#register_email_field').val() === '' || $('#register_password_field').val() === '' ||
      $('#register_password_accept').val() === '') {
        isValid = false;
      }

      if (isValid) {
        $('#register_submit_button').prop('disabled', false).removeClass('disabled_button');
        $('#register_submit_button').addClass('enabled_button');
      } else {
        $('#register_submit_button').prop('disabled', true).addClass('disabled_button');
        $('#register_submit_button').removeClass('enabled_button');
      }

      return isValid;
    }

    function validateUsername() {
      const username = $('#register_username_field').val();
      let isValid = true;

      if (username.length < 6 || username.length > 20) {
        $('#register_username_error').text('Имя пользователя должно содержать от 6 до 20 символов');
        $('#register_username_error').show();
        isValid = false;
      } else if (!/^[a-zA-Z0-9]+$/.test(username)) {
        $('#register_username_error').text('Имя пользователя должно содержать только латинские строчные и заглавные буквы и цифры');
        $('#register_username_error').show();
        isValid = false;
      } else {
        //$('#register_username_error').text('');
        $('#register_username_error').hide();
      }
      return isValid;
    }

    function validateEmail() {
      const email = $('#register_email_field').val();
      const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      let isValid = true;

      if (email === '') {
        $('#register_email_error').text('Поле "Электронная почта" не должно быть пустым');
        $('#register_email_error').show();
        isValid = false;
      } else if (!emailPattern.test(email)) {
        $('#register_email_error').text('Некорректный формат электронной почты');
        $('#register_email_error').show();
        isValid = false;
      } else {
        //$('#register_email_error').text('');
        $('#register_email_error').hide();
      }
      return isValid;
    }

    function validatePassword() {
      const password = $('#register_password_field').val();
      let isValid = true;

      if (password.length < 8) {
        $('#register_password_error').text('Пароль должен содержать не менее 8 символов');
        $('#register_password_error').show();
        isValid = false;
      } else if (!/^[a-zA-Z0-9/.,:;~]+$/.test(password)) {
        $('#register_password_error').text('Пароль должен содержать только латинские строчные и заглавные буквы, цифры, символы /, ., ,, :, ;, ~');
        $('#register_password_error').show();
        isValid = false;
      } else {
        //$('#register_password_error').text('');
        $('#register_password_error').hide();
      }
      return isValid;
    }

    function validatePasswordAccept() {
      const password = $('#register_password_field').val();
      const passwordAccept = $('#register_password_accept').val();
      let isValid = true;

      if (password !== passwordAccept) {
        $('#register_password_accept_error').text('Пароли не совпадают');
        $('#register_password_accept_error').show();
        isValid = false;
      } else {
        $('#register_password_accept_error').text('');
        $('#register_password_accept_error').hide();
        isValid = false;
      }
      return isValid;
    }

    function validateNames(fieldId) {
      const fieldValue = $(fieldId).val();
      let isValid = true;

      if (fieldValue === ''){
        isValid = true;
      } else if (!/^([А-ЯЁ][а-яё]+)$/.test(fieldValue)) {
        //$('#register_username_error').text('Это поле может содержать только кириллицу');
        isValid = false;
      } else {
        //$('#register_username_error').text('');
        // $('#register_username_error').hide();
      }
      return isValid;
    }
    function validateProfileEmail() {
      const email = $('#email').val();
      const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      let isValid = true;

      if (email === '') {
        isValid = false;
      } else if (!emailPattern.test(email)) {
        isValid = false;
      } else {
        //$('#register_email_error').text('');
        //$('#register_email_error').hide();
      }
      return isValid;
    }

