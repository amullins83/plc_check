# Dependencies

express = require('express')
routes = require('./routes')
api = require('./routes/api')
models = require('./models')

app = module.exports = express()

# Configure

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static(__dirname + '/public')
  app.use app.router

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use express.errorHandler()

# Routes

app.get '/', routes.index
app.get '/partial/:name', routes.partial

# JSON API

app.get '/api/name', api.name
app.get '/api/assignments?:findObject', api.assignments.get
app.post '/api/assignments?:postObject', api.assignments.create
app.put '/api/assignments?findObject=:findObject&updateObject=:updateObject', api.assignments.edit
app.delete	'/api/assignments?:deleteObject', api.assignments.destroy

# redirect all others to the index (HTML5 history)
app.get '*', routes.index

# Start server

app.listen process.env.PORT, ->
  console.log "Server started percolating on port #{process.env.PORT}"
