# Peteshow

> a customizable javascript framework for filling out forms with fake data

![Imgur](https://i.imgur.com/v9eDfED.png)

## Getting Started
See the [Wiki on GitHub](https://github.com/brousalis/peteshow/wiki) for documentation.

- [Setup](https://github.com/brousalis/peteshow/wiki/Setup)
- [Usage](https://github.com/brousalis/peteshow/wiki/Usage)
- [Custom plugins](https://github.com/brousalis/peteshow/wiki/Custom-plugins)
- [Plugin example](https://github.com/brousalis/peteshow/wiki/Plugin-example)
- [Change log](https://github.com/brousalis/peteshow/wiki/Change-log)

Also specific pages for frameworks:
- [Ruby on Rails](https://github.com/brousalis/peteshow/wiki/Ruby-on-Rails)

## API

#### `Peteshow.init()`

Adds the seen above menu to the top left of your page. Press backtick <code>`</code> to toggle the menu.

#### `Peteshow.fillOutForms()`

Using the [default rules](https://github.com/brousalis/peteshow/blob/master/src/peteshow-core.js#L2), fills out inputs, checkboxes, selects, and radio buttons. While the menu is open, press `f` to call this method.

#### `Peteshow.fillOutFormsAndSubmit()`

Does the same as above, but also submits the form. Press `q` to call this method.

---

It also has several other methods exposed:

Methods             | Description
--------------------|------------------------------------------------
`submitForm()`                | Submits the form on the page, can be customized
`destroy()`                   | Removes the Peteshow menu from the dom
`hide()`                      | Hides the Peteshow menu
`show()`                      | Shows the Peteshow menu
`formatDate(format, Date)`    | Returns a string with the specified format
`randomChars(length, chars)`  | Returns a string made up of specific characters
`randomDate(format)`          | Returns a random date string
`randomEmail()`               | Returns a random email, customized using init options
`randomLetters(length)`       | Returns random letters
`randomNumber(length)`        | Returns a random number, you can pass an optional prefix
`randomNumberRange(min,max)`  | Returns a number between `min` and `max`

To access the stored values used in the [reuse](https://github.com/brousalis/peteshow/wiki/Custom-plugins#reuse) option, use `Peteshow.storage`:

Methods             | Description
--------------------|------------------------------------------------
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

Name                  |  Description
----------------------|---------------------------------------------------------------
`emailPrefix`  | Prefix for your generated email addresses. Random numbers are added to the end
`emailDomain`  | The domain for your generated email addresses
`form`         | The selector of the form/forms you want to be filled out, defaults to last form on page
`blur`         | Triggers blur() event after filling out an input
`cookies`      | Store saved fields (from [reuse](https://github.com/brousalis/peteshow/wiki/Custom-plugins#reuse)) in cookies rather than localStorage
[rules](https://github.com/brousalis/peteshow/wiki/Custom-plugins#rules)       | A hash of selectors to values that you want to be used when filling out forms. It ignores hidden inputs
[special](https://github.com/brousalis/peteshow/wiki/Custom-plugins#special)   | Called after the rules are applied and can include custom javascript
[ignore](https://github.com/brousalis/peteshow/wiki/Custom-plugins#ignore)     | An array of selectors you wish to have fill out forms ignore
[force](https://github.com/brousalis/peteshow/wiki/Custom-plugins#force)       | Similar to rules, but can be used for hidden inputs
[filters](https://github.com/brousalis/peteshow/wiki/Custom-plugins#filter)    | Filters out options from select boxes
[reuse](https://github.com/brousalis/peteshow/wiki/Custom-plugins#reuse)       | Define input selectors to be saved and reused on certain URLs
[events](https://github.com/brousalis/peteshow/wiki/Custom-plugins#events)     | Used in the off chance you need to add extra javascript on Peteshow's init

### Further notes
[![enova](https://www.enova.com/wp-content/uploads/2014/01/Enova-logo.jpg)](http://www.enova.com)

Developed by [Pete Brousalis](http://twitter.com/brousalis) in his spare time for use at [Enova](http://www.enova.com/) in Chicago, IL.

Special thanks to Matthew Bergman & Marak Squires for [Faker.js](http://github.com/marak/Faker.js/), Adam Gschwender for [jquery.formatDateTime](https://github.com/agschwender/jquery.formatDateTime), Klaus Hartl for [jquery.cookie](https://github.com/carhartl/jquery-cookie), all used by Peteshow.

And especially Donnie Hall for creating the original `Peepshow`
