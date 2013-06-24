#Serve JSON to our AngularJS client
models = models || require "../models"
http = require "http"
url = require "url"
querystring = require "querystring"
Assignment = {}

models.ready ->
	Assignment = models.Assignment

exports.name = (req, res)->
  res.json
  	name: 'PLC Grader'

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
		if req.params.id?
			return Assignment.findOne({id:req.params.id}).exec renderJSON(res)
		else
			if query?
				for keyVal in query.split("&")
					findObject[keyVal.split("=")[0]] = unescape(keyVal.split("=")[1]).replace("+", " ")
		Assignment.find(findObject).sort("id").exec renderJSON(res)

	create: (req, res)->
		Assignment.create req.body, renderJSON(res)

	edit:  (req, res)->
		if req.params.id?
			return Assignment.findOneAndUpdate({id:req.params.id}, req.body.updateObject).exec renderJSON(res)
		Assignment.findOneAndUpdate req.body.findObject, req.body.updateObject, renderJSON(res)

	destroy: (req, res)->
		if req.params.id?
			return Assignment.remove {id: req.params.id}, renderJSON(res)
		Assignment.remove req.body, renderJSON(res)
		
	count: (req, res)->
		Assignment.count renderJSON(res)
		

	
	