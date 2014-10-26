module.exports = +function($) {
  var cookies = false

  Peteshow.storage.init = function(options) {
    cookies = options.cookies
  }

  Peteshow.storage.set = function(data) {
    data = JSON.stringify(data)

    if(cookies)  $.cookie('peteshow', data, {domain: getDomain()})
    else         localStorage.setItem('peteshow', data)
  }

  Peteshow.storage.get = function() {
    var saved = cookies ? $.cookie('peteshow') : localStorage.getItem('peteshow')
    return (saved != undefined || saved != null) ? JSON.parse(saved) : {}
  }

  Peteshow.storage.output = function() {
    var base = ''

    if(savedFieldsExist()) {
      base += "<li class='list'>"
        base += "<div class='inner'>"
          $.each(Peteshow.storage.get(), function(k,v) {
            base += '<div>' + k + '<span>' + v + '</span></div>'
          })
        base += "</div>"
      base += "</li>"
      base += "<li><a data-command='R' href='#' id='clear'>Clear stored</a></li>"
    }

    return base
  }

  Peteshow.storage.clear = function() {
    clearLocalStorage()
    clearCookies()
    Peteshow.initCommands()
  }

  savedFieldsExist = function() {
    var saved = cookies ? $.cookie('peteshow') : localStorage.getItem('peteshow')
    return (saved != undefined || saved != null)
  }

  getDomain = function() {
    // http://rossscrivener.co.uk/blog/javascript-get-domain-exclude-subdomain
    var i=0, domain=document.domain, p=domain.split('.'), s='_gd'+(new Date()).getTime()
    while(i<(p.length-1) && document.cookie.indexOf(s+'='+s)==-1){
      domain = p.slice(-1-(++i)).join('.')
      document.cookie = s+"="+s+";domain="+domain+";"
    }
    document.cookie = s+"=;expires=Thu, 01 Jan 1970 00:00:01 GMT;domain="+domain+";"
    return domain == 'localhost' ? '' : domain
  }

  clearLocalStorage = function() {
    localStorage.removeItem('peteshow')
    Peteshow.initCommands()
  }

  clearCookies = function() {
    $.removeCookie('peteshow', {domain: getDomain()})
    Peteshow.initCommands()
  }

}(jQuery)
