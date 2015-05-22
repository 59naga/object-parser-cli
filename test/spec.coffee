# Dependencies
CLI= (require '../src').CLI

# Fixtures
stdin= (data)->
  return unless data

  process.nextTick ->
    process.stdin.emit 'data',data
    process.stdin.emit 'end'

command= (args...)->
  argv= ['node',__filename]
  argv.concat args...

# Specs
describe 'CLI',->
  it '',(done)->
    stdin null
    argv= command []

    cli= new CLI
    cil.parse argv
    .then (data)->
      expect(data).toBe null
      done()
