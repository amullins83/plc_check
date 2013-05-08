#Serve JSON to our AngularJS client
models = models || require "../models"
url = require "url"
Assignment = {}

models.ready ->
	Assignment = models.Assignment

exports.name = (req, res)->
  res.json
  	name: 'TSTC Leadership Institute'

renderJSON = (res)->
	(err, objects)->
		if(err)
			res.json err
		else
			res.json objects

exports.assignments =
	get: (req, res)->
		query = url.parse(req.url).query
		findObject = {}
		if query?
			for keyVal in query.split("&")
				findObject[keyVal.split("=")[0]] = unescape(keyVal.split("=")[1]).replace("+", " ")
				Assignment.find findObject, renderJSON(res)
		else
			Assignment.find renderJSON(res)

	create: (req, res)->
		Assignment.create req.body, renderJSON(res)

	edit:  (req, res)->
		Assignment.findOneAndUpdate req.body.findObject, req.body.updateObject, renderJSON(res)

	destroy: (req, res)->
		Assignment.remove req.body, renderJSON(res)