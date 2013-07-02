exports.name = (req, res)->
  res.json
    name: 'PLC Grader'

exports.assignments = require "./api/assignments"
    
exports.grade = require "./api/grade"

exports.user = require "./api/user" 
