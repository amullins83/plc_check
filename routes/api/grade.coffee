Find = require "../../models/find"
fs = require "fs"
knox = require 'knox'
uploaderFinished = false
graderFinished = false
Grader = require "../../grade/grader"
Assignment = {}
models = require("../../models")
models.ready ->
    Assignment = models.Assignment

upload = (filePath, folder, name)->

    uploaderFinished = false

    client = knox.createClient
        key: process.env.S3_KEY
        secret: process.env.S3_SECRET
        bucket: "plc-grader"

    client.putFile filePath, "submissions/ch#{folder}/#{name}", (err, res)->
        if err
            console.error "unable to upload:", err.stack

        console.log "file available at https://plc-grader.s3.amazon.com/submissions/ch#{folder}/#{name}"
        uploaderFinished = true
        if graderFinished
            fs.unlinkSync filePath

grade =
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
