#Serve JSON to our AngularJS client
models = models || require "../models"
http = require "http"
url = require "url"
querystring = require "querystring"
fs = require "fs"
Assignment = {}

Grader = require "../grade/grader"

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
        

exports.grade = 
    post: (req, res)->
        res.setHeader('Content-Type', 'text/html');
        g = new Grader
        problemId = req.params.problemId
        filePath = req.files.file.path
        file = fs.readFileSync(filePath).toString()
        console.log problemId
        if problemId.match(/^[12]-\w+$/)?
            chapterString = "1_2"
        else
            chapterString = problemId.match(/^(\d+)/)[1]
        console.log chapterString
        console.log file
        Assignment.findOne {id: "ch#{chapterString}"}, (err, assignment)->
            if err
                res.json err
            else
                theTests = []
                for problem in assignment.problems
                    if problem.id == problemId
                        theTests = problem.tests
                        break
                g.problems = {}
                g.problems[problemId] = {submission: file, tests: []}
                for test in theTests
                    g.addOrTest problemId, test.description, test.points, test.in, test.out
                g.run()
                result = 
                    feedback: g.feedback.split("\n")
                    upload:   file
                res.json result