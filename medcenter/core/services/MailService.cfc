component attributeName='mailService' output='false'{

    instance.mailer=createObject("component", "mail");
    // ���� ��� ����-��� SMTP-�������
    instance.mailer.SetServer('192.168.1.150');
    // ���� ��������� �������
    instance.mailer.SetPort(25);
    // ����� ��� �������
    instance.mailer.SetUserName('support');
    // ������ ��� �������
    instance.mailer.SetPassword('Qtx75uN3');
    // ����� �����������
    instance.mailer.SetFrom('support@digann.ru');
    // ���������
    instance.mailer.SetCharset('utf-8');
    // �� ���������! ����� ��� �������� ��������� �� ������
    instance.mailer.SetFailTo('odmin@digann.ru');
    // �� ���������! ������������� ��������� ����������� ���������
    instance.mailer.SetMailerId('ColdFusion Application Server');

  function Init() {
    return this;
  }

  function Send(to,subject,body) {
    mailer=instance.mailer;
    mailer.SetTo(arguments.to);
    mailer.SetSubject(arguments.subject);
    // mailer.SetCc();   // ����� ������
    // mailer.SetBcc();  // ������� �����
    mailer.Send(body=arguments.body); 
  }

}