#Serve JSON to our AngularJS client
models = models || require "../models"
Find = require "../models/find"
http = require "http"
url = require "url"
querystring = require "querystring"
fs = require "fs"
Assignment = {}
s3 = require 's3'
uploaderFinished = false
graderFinished = false


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
        findObject = {}
        if req.params.id?
            return Assignment.findOne({id:req.params.id}).exec renderJSON(res)
        if req.query?
            findObject = req.query
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
        

upload = (filePath, folder, name)->

    uploaderFinished = false

    client = s3.createClient
        key: process.env.S3_KEY
        secret: process.env.S3_SECRET
        bucket: "plc-grader"

    uploader = client.upload filePath, "submissions/ch#{folder}/#{name}"
    
    uploader.on 'error', (err)->
      console.error "unable to upload:", err.stack

    uploader.on 'progress', (amountDone, amountTotal)->
        console.log "progress", amountDone, amountTotal

    uploader.on 'end', (url)->
        console.log "file available at", url
        uploaderFinished = true
        if graderFinished
            fs.unlinkSync filePath
    




exports.grade = 
    post: (req, res)->
        res.setHeader('Content-Type', 'text/html');
        g = new Grader
        problemId = req.params.problemId
        filePath = req.files.file.path
        fileRaw = fs.readFileSync(filePath)
        
        
        if problemId.match(/^[12]-\w+$/)?
            chapterString = "1_2"
        else
            chapterString = problemId.match(/^(\d+)/)[1]
        
        graderFinished = false
        upload filePath, chapterString, problemId
        
        file = fileRaw.toString()

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
                    feedback: Find.filter g.feedback.split("\n"), /\w/
                    grade:    g.grade
                console.log result

                graderFinished = true
                if uploaderFinished
                    fs.unlinkSync filePath
                res.json result
