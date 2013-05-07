#Serve JSON to our AngularJS client
models = models || require "../models"
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
		console.log req.params.findObject
		Assignment.find req.params.findObject || {}, renderJSON(res)

	create: (req, res)->
		Assignment.create req.body, renderJSON(res)

	edit:  (req, res)->
		Assignment.findOneAndUpdate req.params.findObject, req.body.updateObject, renderJSON(res)

	destroy: (req, res)->
		Assignment.remove req.params.deleteObject, renderJSON(res)