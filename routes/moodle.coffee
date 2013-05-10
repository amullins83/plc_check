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