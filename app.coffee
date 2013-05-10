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
app.get '/api/assignments', api.assignments.get
app.post '/api/assignments', api.assignments.create
app.put '/api/assignments', api.assignments.edit
app.delete	'/api/assignments', api.assignments.destroy
app.get '/api/assignments/count', api.assignments.count

#app.post '/api/moodle', api.moodle

# redirect all others to the index (HTML5 history)
app.get '*', routes.index

# Start server

app.listen process.env.PORT, ->
  console.log "Server started percolating on port #{process.env.PORT}"
