# Peteshow

> a customizable framework for filling out forms with fake data


![Imgur](http://i.imgur.com/JcT5eMS.png)

## Getting Started
See the [Wiki on GitHub](https://github.com/brousalis/peteshow/wiki) for documentation.

- [Setup](https://github.com/brousalis/peteshow/wiki/Setup)
- [Usage](https://github.com/brousalis/peteshow/wiki/Usage)
- [Custom plugins](https://github.com/brousalis/peteshow/wiki/Custom-plugins)
- [Plugin example](https://github.com/brousalis/peteshow/wiki/Plugin-example)
- [Change log](https://github.com/brousalis/peteshow/wiki/Change-log)

Also specific pages for frameworks:
- [Ruby on Rails](https://github.com/brousalis/peteshow/wiki/Ruby-on-Rails-gem)

## API

#### Peteshow.init()

Adds the seen above menu to the top left of your page. Press backtick <code>`</code> to toggle the menu.

#### Peteshow.fillOutForms()

Using the [default ruleset](https://github.com/brousalis/peteshow/blob/master/src/peteshow-core.js#L2), fills out inputs, checkboxes, selects, and radio buttons. While the menu is open, press `f` to call this method.

#### Peteshow.fillOutFormsAndSubmit()

Does the same as above, but also submits the form. Press `q` to call this method.

It also has several other methods exposed:

Methods             | Description
--------------------|------------------------------------------------
`submitForm()`                | Submits the form on the page, can be customized using init options
`destroy()`                   | Removes the Peteshow menu from the dom
`hide()`                      | Hides the Peteshow menu
`show()`                      | Shows the Peteshow menu
`formatDate(format, Date)`    | Returns a string with the specified format
`randomChars(length, chars)`  | Returns a string made up of specific characters
`randomDate(format)`          | Returns a random date string
`randomEmail()`               | Returns a random email, customized using init options
`randomLetters(length)`       | Returns random letters
`randomNumber(length, prefix)`| Returns a random number, prefix optional
`randomNumberRange(min,max)`  | Returns a number between `min` and `max`
`storage.clear()`             | Clears saved fields from cookies and localstorage
`storage.get()`               | Prints out the saved fields used in the `reuse` option
`storage.set(hash)`           | Sets either cookie or localstorage, takes a hash

## Default options

Peteshow can be customized by creating a [custom plugin](https://github.com/brousalis/peteshow/wiki/Custom-plugins). Here are the default options:

```javascript
options = {
  emailPrefix : 'test-',
  emailDomain : 'example.com',
  form        : '',
  blur        : false,
  cookies     : false,
  rules       : {},
  ignore      : [],
  filter      : [],
  force       : {},
  reuse       : {},
  commands    : '',
  special     : function(){},
  events      : function(){},
}
$(function() {
  Peteshow.init(options)
})
```



### Further notes
[![enova](https://www.enova.com/wp-content/uploads/2014/01/Enova-logo.jpg)](http://www.enova.com)

Developed by [Pete Brousalis](http://twitter.com/brousalis) in his spare time for use at [Enova](http://www.enova.com/) in Chicago, IL.

Special thanks to Matthew Bergman & Marak Squires for [Faker.js](http://github.com/marak/Faker.js/), Adam Gschwender for [jquery.formatDateTime](https://github.com/agschwender/jquery.formatDateTime), Klaus Hartl for [jquery.cookie](https://github.com/carhartl/jquery-cookie), all used by Peteshow.

And especially Donnie Hall for creating the original `Peepshow`
