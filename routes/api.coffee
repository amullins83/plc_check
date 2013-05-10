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
		
	count: (req, res)->
		Assignment.count renderJSON(res)
		
exports.moodle = (originalRequest, myResponse)->
	assignment = originalRequest.body.assignment
	submission = originalRequest.body.submission
	posting = {}
	posting.subject = assignment.name
	posting.message = ""
	posting.path = assignment.postURL
	switch submission
		when "Post 1"
			posting.message = assignment.postText[0]
		when "Post 2"
			posting.message = assignment.postText[1]
		when "Post 3"
			posting.message = assignment.postText[2]
		when "Reflection"
			posting.message = assignment.reflectText
			path = assignment.reflectURL
	parsedURL = url.parse(path, true)
	replyID = parsedURL.query.reply
	posting.sesskey = "aq0BxeVOVr"
	posting.subscribe="1"
	posting.timestart="0"
	posting.timeend="0"
	posting.course="41515"
	posting.forum="0"
	posting.discussion="236205"
	posting.parent=replyID
	posting.userid="54773"
	posting.groupid="3672"
	posting.edit="0"
	posting.reply=replyID
	posting._qf__mod_forum_post_form="1"
	
	
	options =
	  hostname: url.parse(path).hostname
	  port: 80
	  path: url.parse(path).pathname
	  method: 'POST'

	req = http.request options, (res)->
		myResponse.json
			message: "This posting to #{path} was successful!"
			name: posting.name
			text: posting.text
			path: path
			ok: 1
			originalStatus: 200


	req.on 'error', (e)->
		myResponse.send 403, JSON.stringify {
			message: "something bad happened"
			ok: 0
			originalStatus: 403
		}
		
	req.write JSON.stringify(posting)
	req.end();
	
	