models = require "../models"

models.ready ->
    Assignment = models.Assignment
    problemId = "1-01a"
    Assignment.findOne {id:"ch1_2"}, (err, assignment)->
        theTests = []
        for problem in assignment.problems
            theTests = problem.tests if problem.id == problemId
        console.log theTests[0].description