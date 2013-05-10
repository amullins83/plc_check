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
	assignment = JSON.parse originalRequest.body.assignment
	submission = originalRequest.body.submission
	posting = {}
	posting.subject = assignment.name
	posting.message = ""
	path = assignment.postURL
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
	posting.sesskey = "NvrxGMITg1"
	posting.subscribe = "1"
	posting.timestart = "0"
	posting.timeend = "0"
	posting.course = "34464"
	posting.forum = "0"
	posting.discussion = "183732"
	posting.parent = replyID
	posting.userid = "54773"
	posting.groupid = "0"
	posting.edit = "0"
	posting.reply = replyID
	posting._qf__mod_forum_post_form = "1"
	
	
	options =
	  hostname: parsedURL.hostname
	  port: 80
	  path: parsedURL.pathname
	  method: 'POST'

	req = http.request options, (res)->
		responseText = ""
		res.on "data", (data)->
			responseText += data

			if responseText.match /<\/html>/
				myResponse.json
					message: (()->
						if res.statusCode == 200
							return "Successfully posted to #{path}"
						else
							return "Failed: status #{res.statusCode}"
					)() 
					name: assignment.name
					text: posting.text
					path: path
					ok: 1
					originalStatus: res.statusCode
					responseBody: responseText


	req.on 'error', (e)->
		myResponse.send 500, JSON.stringify {
			message: "something bad happened"
			ok: 0
			originalStatus: 500
		}
		
	req.write JSON.stringify(posting)
	req.end();
	
	