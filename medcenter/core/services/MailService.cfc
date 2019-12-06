component attributeName='mailService' output='false'{

    instance.mailer=createObject("component", "mail");
    // айпи или хост-имя SMTP-сервера
    instance.mailer.SetServer('192.168.1.150');
    // порт почтового сервера
    instance.mailer.SetPort(25);
    // логин для сервера
    instance.mailer.SetUserName('support');
    // пароль для сервера
    instance.mailer.SetPassword('Qtx75uN3');
    // адрес отправителя
    instance.mailer.SetFrom('support@digann.ru');
    // кодировка
    instance.mailer.SetCharset('utf-8');
    // НЕ ПРОВЕРЕНО! адрес для отправки сообщения об ошибке
    instance.mailer.SetFailTo('odmin@digann.ru');
    // НЕ ПРОВЕРЕНО! идентификатор программы отправившей сообщение
    instance.mailer.SetMailerId('ColdFusion Application Server');

  function Init() {
    return this;
  }

  function Send(to,subject,body) {
    mailer=instance.mailer;
    mailer.SetTo(arguments.to);
    mailer.SetSubject(arguments.subject);
    // mailer.SetCc();   // копии письма
    // mailer.SetBcc();  // скрытые копии
    mailer.Send(body=arguments.body); 
  }

}