exports.name = (req, res)->
  res.json
    name: 'PLC Grader'

exports.assignments = assignments = require "./api/assignments"

Assignment = exports.Assignment = assignments.Assignment

exports.grade = require "./api/grade"

exports.user = require "./api/user"
