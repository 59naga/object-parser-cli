# Object-parser-cli [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> the Object preprocessor.

## Installation
```bash
$ npm install object-parser-cli --global
$ opc -V
# 0.0.0-alpha.0
```
```bash
$ opc

#  Usage: opc <stdin/file/url> [path/locator...] [options...]
#
#  Options:
#
#    -h, --help              output usage information
#    -V, --version           output the version number
#    -t, --transform <type>  Transform to <json/json5/yaml/html>
#    -i, --indent <digit>    Adjust indents <2>
```

# Transform
## `opc <stdin/file/url> --transfrom <type>`
Convert other format the passed value. (alias `-t`)
Support the `<type>`: `json`, `json5`, `yaml`, `html`

## JSON / JSON5 / [JsonML](http://www.jsonml.org/)
```bash
# foo.json: [["body",["h1",{"foo":"bar"},"baz"]]]

$ opc foo.json --transfrom json5
# [["body",["h1",{foo:"bar"},"baz"]]]

$ opc foo.json --transfrom yaml
# -
#   - body
#   - [h1, {foo: bar}, baz]

$ opc foo.json --transfrom html
# <body>
#   <h1 foo="bar">baz</h1>
# </body>
```

## YAML
```bash
# foo.yml: '-\n  - body\n  - [h1, {foo: bar}, baz]' > 

$ opc foo.yml --transfrom json
# [["body",["h1",{"foo":"bar"},"baz"]]]

$ opc foo.yml --transfrom json5
# [["body",["h1",{foo:"bar"},"baz"]]]

$ opc foo.yml --transfrom html
# <body>
#   <h1 foo="bar">baz</h1>
# </body>
```

# Traversing the `DOM`
## `opc <stdin/file/url> locator [locator...]`

```bash
# example.html: <title>foo</title>
$ opc example.html title # foo

# example.xml: <body id="baz"><h1>bar</h1></body>
$ opc example.xml body # bar
$ opc example.xml body?id # baz

# example.json: [["li",["a",{"href":"booooop"}],"beep"]]
$ opc example.json li # beep
$ opc example.json "li a"?href # booooop
```

`locator` is `selector?attribute`.
> `selector` is https://github.com/fb55/css-select#supported-selectors

Get [text()](https://github.com/cheeriojs/cheerio#-selector-context-root-) if selector hasn't `?attribute`.

# Get the value of `Object`
## `opc <stdin/file/url> path [path...]`

```bash
# bower.json: {"name":"bar","ignore":["baz","beep","boop"]}
$ opc bower name # bar
$ opc bower ignore # baz beep boop
$ opc bower name ignore # bar baz beep boop

# .travis.yml: language: node_js
$ opc .travis.yml language # node_js
```

Note: extension __`.json`__ is optional.

> `path` is https://lodash.com/docs#get

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[npm-image]:https://img.shields.io/npm/v/object-parser-cli.svg?style=flat-square
[npm]: https://npmjs.org/package/object-parser-cli
[travis-image]: http://img.shields.io/travis/59naga/object-parser-cli.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/object-parser-cli
[coveralls-image]: http://img.shields.io/coveralls/59naga/object-parser-cli.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/object-parser-cli?branch=master
