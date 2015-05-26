# Dependencies
CommandFile= (require 'commander-file').CommandFile

OP= require 'object-parser'
cheerio= require 'cheerio'
_= require 'lodash'

path= require 'path'
fs= require 'fs'

# Public
class CLI extends CommandFile
  constructor: ->
    super
    @config.fileExtension= '.json'

    @version require('../package').version
    @usage '<stdin/file/url> [path/locator...] [options...]'
    @option '-t, --transform <type>','Transform to <json/json5/yaml/html>'
    @option '-i, --indent <digit>','Adjust indents <2>',2
    @option '-s, --separator <string>','Change separator (default:" ")',' '

  getType: (data)->
    switch data[0]
      when '<' then 'html'
      when '[' then 'jsonml'
      when '{' then 'json5'
      else 'yaml'

  parse: (argv,reporter=null)->
    reporter?= (string)->
      process.stdout.write string

    super argv
    .then (data)=>
      return @help() unless data?

      object= @parseString data
      if @args.length
        type= @getType data

        data=
          switch type
            when 'jsonml'
              dom= cheerio.load OP.stringify 'jsonml',data

              values= @find dom,@args
              values.join @separator

            when 'html'
              dom= cheerio.load data

              values= @find dom,@args
              values.join @separator

            else
              object= OP.parse type,data

              values= @get object,@args
              values.join @separator

      else
        @transform?= 'json'

        data= @convert object,@transform,@indent

      data

    .then reporter

  parseString: (data)->
    type=
      switch data[0]
        when '<' then 'jsonml'
        when '[' then 'json5'
        when '{' then 'json5'
        else 'yaml'
    object= OP.parse type,data

  convert: (object,transform,indent)->
    transform=
      switch transform
        when 'html' then 'jsonml'
        else transform
    string= OP.stringify transform,object,null,~~indent

    string

  get: (object,paths)->
    for path in paths
      value= _.get object,path

      if value instanceof Array
        value.join @separator
      else
        value

  find: (dom,locators)->
    for locator in locators
      [selector,attribute]= locator.split '?',2

      if attribute?
        dom(selector).eq(0).attr attribute
      else
        dom(selector).eq(0).text()

module.exports= new CLI
module.exports.CLI= CLI