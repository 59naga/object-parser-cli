# Dependencies
CommandFile= (require 'commander-file').CommandFile

OP= require 'object-parser'
_= require 'lodash'

# Public
class CLI extends CommandFile
  constructor: ->
    super

    @version require('../package').version
    @usage '<stdin/file/url> [options...]'

  parse: (argv)->
    super argv

    .then (data)=>
      console.log data
      return @help() unless data?

module.exports= new CLI
module.exports.CLI= CLI