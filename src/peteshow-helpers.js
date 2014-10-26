module.exports = +function($) {
  Peteshow.randomChars = function (length, chars) {
    var string = ''

    for (var i = 0; i < length; i++) {
      var num = Math.floor(Math.random() * chars.length)
      string += chars.substring(num, num + 1)
    }

    return string
  }

  Peteshow.randomLetters = function (length) {
    return function() {
      return Peteshow.randomChars(length, 'ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz')
    }
  }

  Peteshow.randomNumberRange = function (min, max) {
    return function() {
      return Math.floor(Math.random() * (max - min + 1)) + min
    }
  }

  Peteshow.randomNumber = function (length, prefix) {
    if(typeof prefix == 'undefined') { prefix = '' }

    return function() {
      return prefix + Peteshow.randomChars(1, '123456789') + Peteshow.randomChars(length-1, '0123456789')
    }
  }

  Peteshow.randomDate = function(format) {
    if(typeof format === 'undefined' || format === null) format = 'yy-mm-dd'

    var start   = new Date(1942, 1, 1),
        end     = new Date(1970, 1, 1)

    var random  = new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime())),
        day     = parseInt(random.getDate())

    if(day % 2 == 1) {
      if(day < 30)  random.setTime(random.getTime() + (24 * 60 * 60 * 1000))
      else          random.setTime(random.getTime() - (24 * 60 * 60 * 1000))
    }

    return Peteshow.formatDate(format, random)
  }

  Peteshow.randomEmail = function() {
    return function() {
      return Peteshow.defaults.emailPrefix + Peteshow.randomNumber(6)() + '@' + Peteshow.defaults.emailDomain
    }
  }

  Peteshow.formatDate = function(format, date, settings) {
    return $.formatDateTime(format, date, settings)
  }

}(jQuery)
