+function($) {
  getDefaultRules = function() {
    return {
      'input[type=password]'      : 'password',
      'input[type=text]'          : Peteshow.randomLetters(8),
      'input[type=email]'         : Peteshow.randomEmail(),
      'input[type=number]'        : Peteshow.randomNumber(8),
      'input[type=date]'          : Peteshow.randomDate(),
      'input[name*=email]'        : Peteshow.randomEmail(),
      'input[name*=number]'       : Peteshow.randomNumber(8),
      'input[class*=number]'      : Peteshow.randomNumber(8),
      'input[class*=decimal]'     : Peteshow.randomNumber(8),
      'input[name*=phone]'        : Faker.PhoneNumber.phoneNumberFormat(5),
      'input[name*=first_name]'   : Faker.Name.firstName(),
      'input[name*=last_name]'    : Faker.Name.lastName(),
      'input[name*=company]'      : Faker.Company.companyName(),
      'input[name*=line1]'        : Faker.Address.streetName(),
      'input[name*=street]'       : Faker.Address.streetName(),
      'input[name*=suite]'        : Faker.Address.secondaryAddress(),
      'input[name*=line2]'        : Faker.Address.secondaryAddress(),
      'input[name*=city]'         : Faker.Address.city(),
      'input[name*=zip]'          : Faker.Address.zipCodeFormat(0),
      'input[name*=postal]'       : Faker.Address.zipCodeFormat(0),
      'input[name*=state]'        : Faker.Address.usState(),
      'input[name*=job_title]'    : Faker.Company.catchPhrase(),
      'input[name*=intent]'       : Faker.Lorem.sentence(),
      'input[name*=income]'       : Peteshow.randomNumber(4),
      'input[name*=amount]'       : Peteshow.randomNumber(4),
      'input[name*=branch]'       : '400001',
      'input[name*=routing]'      : '400001',
      'input[name*=card_type_cd]' : '001',
      'input[name*=card_number]'  : '4111111111111111',
      'input[name*=cvv]'          : '123'
    }
  }

  Peteshow.init = function(options) {
    _options  = $.extend(true, Peteshow.defaults, options || {})

    $div      = $('<div/>', { id: 'peteshow' })
    $toggle   = $('<a/>',   { id: 'peteshow-toggle', href: '#' }).append('<i/>')
    $tools    = $('<div/>', { id: 'peteshow-tools' })
    $commands = $('<ul/>',  { id: 'peteshow-commands' })

    $div.append($toggle)
        .append($tools.append($commands))

    $('body').append($div)

    initCommands()
  }

  Peteshow.destroy = function() {
    Peteshow.hide()
    $div.remove();
  }

  Peteshow.hide = function() {
    $div.hide()
    $div.removeClass('active')
  }

  Peteshow.toggle = function() {
    $tools.toggle()
    $div.toggleClass('active')
  }

  Peteshow.show = function() {
    $div.show()
    $tools.show()

    if(!$div.hasClass('active'))
      $div.addClass('active')
  }

  handleKeypress = function(e) {
    var key   = (typeof e.which == 'number') ? e.which : e.keyCode,
        code  = String.fromCharCode(e.keyCode)

    // modifier keys
    if(e.ctrlKey) code = 'ctrl_'+code
    if(e.altKey || (e.originalEvent && e.originalEvent.metaKey)) code = 'alt_'+code
    if(e.shiftKey) code = 'shift_'+code
    if($.inArray(e.keyCode, [9,16,17,18, 91, 93, 224]) != -1) return
    if(e.metaKey) return

    if(e.keyCode == 192) // backtick
      Peteshow.toggle()

    var action  = $("[data-command='"+code+"']"),
        visible = $tools.is(':visible')

    if(action.length > 0 && visible)
      action.click()
  }

  initCommands = function() {
    var base =  "<li><a data-command='F' href='#' id='fill-out-forms'>Fill Out Forms</a></li>"
        base += "<li><a data-command='Q' href='#' id='fill-out-forms-and-submit'>Fill Out and Submit</a></li>"
        base += outputSavedFields()
        base += "<li><a data-command='H' href='#' id='hide-peteshow'>Hide</a></li>"

    $commands.html(_options.commands + base)

    // bind events
    var commands = [
      [ $toggle,                          Peteshow.toggle ],
      [ $('#fill-out-forms'),             Peteshow.fillOutForms ],
      [ $('#fill-out-forms-and-submit'),  Peteshow.fillOutFormsAndSubmit ],
      [ $('#clear'),                      Peteshow.clearSaved ],
      [ $('#hide-peteshow'),              Peteshow.hide ]
    ]

    $.each(commands, function() {
      var command = $(this)
      $(command[0]).on('click', function() {
        command[1](); return false
      });
    });

    _options.events()
  }

  handleKeypress = function(e) {
    var key  = (typeof e.which == 'number') ? e.which : e.keyCode,
        code = String.fromCharCode(e.keyCode)

    if(e.ctrlKey) code = 'ctrl_'+code
    if(e.altKey || (e.originalEvent && e.originalEvent.metaKey)) code = 'alt_'+code
    if(e.shiftKey) code = 'shift_'+code
    if($.inArray(e.keyCode, [9,16,17,18,91,93,224]) != -1) return
    if(e.metaKey) return

    if(e.keyCode == 192) // backtick
      Peteshow.toggle()

    var action  = $("[data-command='"+code+"']"),
        visible = $tools.is(':visible')

    if(action.length > 0 && visible) action.click()
  }

  Peteshow.fillOutForms = function() {
    var rules   = $.extend(true, getDefaultRules(), _options.rules || {})
        reused  = {},
        saved   = Peteshow.getSavedFields()

    $('input[type=checkbox]')
      .filterFields()
      .prop('checked', true)

    randomRadioValue()

    $('select').each(randomSelectValue)

    // force rules (for hidden fields)
    $.each(_options.force, function(element,v) {
      $(element)
        .filterFields()
        .val($.isFunction(v) ? v() : v)

      if(_options.blur)
        $(element).blur()
    })

    // fill out fields with rules
    $.each(rules, function(element,v) {
      $(element)
        .filter(':visible')
        .filterFields()
        .val($.isFunction(v) ? v() : v)

      if(_options.blur) $(element).blur()
    })

    // special rules
    _options.special()

    // localstorage functionality
    reuseLocalStorage()
  }

  reuseLocalStorage = function() {
    var reused  = {},
        saved   = Peteshow.getSavedFields()

    $.each(_options.reuse, function(element,v) {
      var url = _options.reuse[element]

      // exists on page
      if($(element).length > 0) {
        // element isnt in saved, save it
        if(!(element in saved))
          reused[element] = $(element).val()

        // element is saved and we're not on the reused url, save it
        if((element in saved) && window.location.href.indexOf(url) < 0)
          reused[element] = $(element).val()
      }
    })

    // save if found rules to reuse
    if(!$.isEmptyObject(reused)) {
      $.extend(saved, reused)
      Peteshow.setSavedFields(saved)
    }

    // apply saved rule values if they exist and on the right page
    if(savedFieldsExist()) {
      $.each(Peteshow.getSavedFields(), function(element,v) {
        var url = _options.reuse[element]
        if(window.location.href.indexOf(url) > -1) $(element).val(v)
      })

      // redraw menu
      initCommands()
    }
  }

  Peteshow.setSavedFields = function(data) {
    data = JSON.stringify(data)

    if(_options.cookies)  $.cookie('peteshow', data, {domain: getDomain()})
    else                  localStorage.setItem('peteshow', data)
  }

  Peteshow.getSavedFields = function() {
    var saved = _options.cookies ? $.cookie('peteshow') : localStorage.getItem('peteshow')
    return (saved != undefined || saved != null) ? JSON.parse(saved) : {}
  }

  outputSavedFields = function() {
    var base = ''

    if(savedFieldsExist()) {
      base += "<li class='list'>"
        base += "<div class='inner'>"
          $.each(Peteshow.getSavedFields(), function(k,v) {
            base += '<div>' + k + '<span>' + v + '</span></div>'
          })
        base += "</div>"
      base += "</li>"
      base += "<li><a data-command='R' href='#' id='clear'>Clear stored</a></li>"
    }

    return base
  }

  savedFieldsExist = function() {
    var saved = _options.cookies ? $.cookie('peteshow') : localStorage.getItem('peteshow')
    return saved != undefined || saved != null
  }

  getDomain = function() {
    // http://rossscrivener.co.uk/blog/javascript-get-domain-exclude-subdomain
    var i=0, domain=document.domain, p=domain.split('.'), s='_gd'+(new Date()).getTime();
    while(i<(p.length-1) && document.cookie.indexOf(s+'='+s)==-1){
      domain = p.slice(-1-(++i)).join('.');
      document.cookie = s+"="+s+";domain="+domain+";";
    }
    document.cookie = s+"=;expires=Thu, 01 Jan 1970 00:00:01 GMT;domain="+domain+";";
    return domain == 'localhost' ? '' : domain;
  }

  Peteshow.clearSaved = function() {
    Peteshow.clearLocalStorage()
    Peteshow.clearCookies()
    initCommands()
  }

  Peteshow.clearLocalStorage = function() {
    localStorage.removeItem('peteshow')
    initCommands()
  }

  Peteshow.clearCookies = function() {
    $.removeCookie('peteshow', {domain: getDomain()})
    initCommands()
  }

  randomSelectValue = function(i,select) {
    var options   = $(select).find('option'),
        filters   = _options.filter.toString().replace(new RegExp(',', 'g'), '|'),
        regex     = new RegExp('other|select'+(filters == '' ? '' : '|' + filters),'gi'),
        filtered  = []

    $.each(options, function(e) {
      var value = $(this).val()

      if(value.match(regex) == null && value != '')
        filtered.push(value)
    });

    var random = Math.floor(Math.random() * filtered.length)

    $(select)
      .filterFields()
      .val(filtered[random])
      .change()
  }

  randomRadioValue = function() {
    var names = $('input:radio').map(function() {
      return $(this).attr('name')
    })

    $.unique(names)

    $.each(names, function(i, name) {
      var radios = $('input:radio[name="'+name+'"]')

      $(radios[Math.floor(Math.random() * radios.length)])
        .filterFields()
        .prop('checked', true)
        .change()
    })
  }

  $.fn.filterFields = function() {
    return this.filter(function() {
      return _options.ignore.indexOf(this.name) === -1
    })
  }

  Peteshow.submitForm = function() {
    $(_options.form).submit()
    $('form[name*=registration], .simple_form').submit()
    $('form').last().submit()
  };

  Peteshow.fillOutFormsAndSubmit = function() {
    Peteshow.fillOutForms()
    Peteshow.submitForm()
  }

  Peteshow.destroy = function() {
    Peteshow.hide()
    $div.remove();
  }

  Peteshow.hide = function() {
    $div.hide()
    $div.removeClass('active')
  }

  Peteshow.toggle = function() {
    $tools.toggle()
    $div.toggleClass('active')
  }

  Peteshow.show = function() {
    $div.show()
    $tools.show()
    if(!$div.hasClass('active')) $div.addClass('active')
  }

  $(document).keydown(handleKeypress);
}(jQuery)

