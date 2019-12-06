component displayName='errorHandler' {

  instance.logging=true;
  instance.section='';
  instance.type='';
  instance.description='';
  instance.redirect=false;
  instance.redirectUrl='';
  instance.redirectMessage='';
  service.logger=createObject('component','core.services.cLog').Init();
  service.redirect=createObject('component','core.services.redirector').Init();
  instance.ajaxFlag=IsAjax();

  function Init() {
    return this;
  }

  function Handler(exception) {
      if (StructKeyExists(arguments.exception,'cause')) {
        locType=arguments.exception.cause.type;
        locDetail=arguments.exception.cause.detail;
        locMessage=arguments.exception.cause.message;
        locExtendedInfo=arguments.exception.cause.extendedInfo;
        locTagContext=arguments.exception.cause.tagContext;
      } else {
        locType=arguments.exception.type;
        locDetail=arguments.exception.detail;
        locMessage=arguments.exception.message;
        locExtendedInfo=arguments.exception.extendedInfo;
        locTagContext=arguments.exception.tagContext;
      }
      //WriteDump(exception);
      dumpArray=ParseArray(locTagContext);
      switch(locType) {
        case 'Database':
          instance.section='Database';
          instance.type='SYSTEM';
          instance.description='#locDetail# [#arguments.exception.cause.sql#]';
          break;
        case 'MissingInclude':
          instance.section='MissingInclude';
          instance.type='SYSTEM';
          instance.description='#locDetail#  [#arguments.exception.cause.MissingFileName#]';
          break;
        case 'Template':
          instance.section='Template';
          instance.type='SYSTEM';
          instance.description='#locDetail# [snipet]';
          break;
        case 'Object':
          //этой ошибки добиться не смог
          instance.section='Object';
          instance.type='SYSTEM';
          instance.description='#locDetail#';
          break;
        case 'Security':
          //этой ошибки добиться не смог
          instance.section='Security';
          instance.type='SYSTEM';
          instance.description='#locDetail#';
          break;
        case 'Expression':
          instance.section='Expression';
          instance.type='SYSTEM';
          instance.description='#locDetail#';
          break;
        case 'Lock':
          //этой ошибки добиться не смог
          instance.section='Lock';
          instance.type='SYSTEM';
          instance.description='#locDetail#';
          break;
        case 'SearchEngine':
          //этой ошибки добиться не смог
          instance.section='SearchEngine';
          instance.type='SYSTEM';
          instance.description='#locDetail#';
          break;
        case 'Application':
          instance.section='Application';
          instance.type='SYSTEM';
          instance.description='#locDetail#';
          break;
          //--------------------------------------------------------------------
          //--- пользовательские искоючения ------------------------------------
          //--------------------------------------------------------------------
        default:
          instance.section=locMessage;
          instance.type=locType;
          instance.description=locDetail;
          if (locExtendedInfo!='') {
            instance.redirect=true;
            instance.redirectUrl=ListGetAt(locExtendedInfo,1);
            instance.redirectMessage=ListGetAt(locExtendedInfo,2);
          }
          break;
      }
      errorString='<br>section=#instance.section#<br>type=#instance.type#<br>description=#instance.description#<br>dumpArray=#dumpArray#<hr>';
      if (instance.ajaxFlag) {
        //Writeoutput('{"REDIR":"http:\/\/127.0.0.1\/","STRUCT":{"MESSAGE":"База не доступна!"},"LOGGEDIN":0.0}');
        Writeoutput('{"RETVAL": 0, "RETDESC":"Произошла внутренняя ошибка серевера!"}');
      } else {
        title='Дебагер дамп';
        text='';
        data=errorString;
        include '/core/Builder/page/error.cfm';
      }
      if (instance.logging) {
        service.logger.AddLogging(ssection='System ERROR',type=instance.type,description=errorString);
        //service.logger.SaveLogging();
      }
      if (instance.redirect) {
        service.redirect.SetRedirect('/?page=#instance.redirectUrl#','message=#UrlEncodedFormat("#instance.redirectMessage#")#');
        service.redirect.Redirect();
      }
    return true;
  }

  //============================================================================

  function IsAjax() {
    accept=GetHttpRequestData().headers.accept;
    if (Find('application/json',accept)) {
      return true;
    } else {
      return false;
    }
  }

  function ParseArray(arrayStruct) {
    result='type:#arguments.arrayStruct[1].type#, template:#arguments.arrayStruct[1].template#, line:#arguments.arrayStruct[1].line#, column:#arguments.arrayStruct[1].column#';
    return result;
  }

}