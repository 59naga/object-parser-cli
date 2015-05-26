# Dependencies
CLI= (require '../src').CLI

OP= require 'object-parser'

# Environment
pkg= require '../package'

process.stdin.setMaxListeners(0)

# Fixture
$opc= (args,stdin)->
  if stdin?
    process.nextTick ->
      process.stdin.emit 'data',stdin
      process.stdin.emit 'end'

  stdout= ''
  reporter= (string)->
    stdout+= string

  argv= ['node',__filename]
  for arg in args.match /".*?"|[^\s]+/g
    argv.push arg.replace /^"|"$/g,''

  cli= new CLI
  cli.parse argv,reporter
  .then ->
    [cli,stdout]

# Specs
describe 'CLI',->
  describe 'Transfrom',->
    it '$ opc package -t yaml',(done)->
      $opc 'package -t yaml'
      .spread (cli,stdout)->

        expect(stdout).toMatch /^name: object-parser-cli/
        done()

    it '$ opc package -t json5',(done)->
      $opc 'package -t json5'
      .spread (cli,stdout)->

        expect(stdout).toMatch /^{\n  name: "object-parser-cli",/
        done()

    it '$ opc test/fixture.xml -t json5',(done)->
      $opc 'test/fixture.xml -t json5 -i 0'
      .spread (cli,stdout)->

        # coffeelint: disable=max_line_length
        expect(stdout).toBe '[["ul",["li",{style:"color:red"},"foo"],["li",{title:"Some hover text.",style:"color:green"},"bar"],["li",["span",{class:"code-example-third"},"baz"]]]]'
        # coffeelint: enable=max_line_length
        done()

  describe 'Use DOM',->
    it '$ opc test/fixture.xml li',(done)->
      $opc 'test/fixture.xml li'
      .spread (cli,stdout)->

        expect(stdout).toBe 'foo'
        done()

    it '$ opc test/fixture.xml li:nth-child(2)',(done)->
      $opc 'test/fixture.xml li:nth-child(2)'
      .spread (cli,stdout)->

        expect(stdout).toBe 'bar'
        done()

    it '$ opc test/fixture.xml "li span"',(done)->
      $opc 'test/fixture.xml "li span"'
      .spread (cli,stdout)->

        expect(stdout).toBe 'baz'
        done()

    it '$ opc test/fixture.xml li?style',(done)->
      $opc 'test/fixture.xml li?style'
      .spread (cli,stdout)->

        expect(stdout).toBe 'color:red'
        done()

    it '$ opc test/fixture.xml li li:nth-child(2) "li span" li?style',(done)->
      $opc 'test/fixture.xml li li:nth-child(2) "li span" li?style'
      .spread (cli,stdout)->

        expect(stdout).toBe 'foo bar baz color:red'
        done()

  describe 'Use Object',->
    it '$ opc package name',(done)->
      $opc 'package name'
      .spread (cli,stdout)->

        expect(stdout).toBe pkg.name
        done()

    it '$ opc package name version',(done)->
      $opc 'package name version'
      .spread (cli,stdout)->

        expect(stdout).toBe pkg.name+' '+pkg.version
        done()

    it '$ opc package files',(done)->
      $opc 'package files'
      .spread (cli,stdout)->

        expect(stdout).toBe pkg.files.join ' '
        done()

    it '$ opc .travis.yml language',(done)->
      $opc '.travis.yml language'
      .spread (cli,stdout)->

        expect(stdout).toBe 'node_js'
        done()

  describe 'Change separator',->
    it '$ opc package files',(done)->
      $opc 'package files --separator "&&"'
      .spread (cli,stdout)->

        expect(stdout).toBe pkg.files.join '&&'
        done()
  