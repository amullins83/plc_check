(->
    "use strict"

    Grader = require "../../grade/Grader.coffee"
    fs = require "fs"

    describe "Grader", ->
        myGrader = null

        it "exists", ->
            expect(Grader).toBeDefined()

        describe "constructor", ->

            submissionPath = "./submissions/ch1_2/Dishon"
            submittedFiles = fs.readdirSync submissionPath

            examplePath = "./submissions/ch1_2/Examples"
            exampleFiles = fs.readdirSync examplePath



            it "makes an object", ->
                myGrader = new Grader "./submissions/ch1_2/Examples"
                expect(typeof myGrader).toBe "object"

            it "creates problems array", ->
                expect(typeof myGrader.problems).toBe "object"

            it "adds a problem for every file in Examples", ->
                expect(Grader.len(myGrader.problems)).toBe exampleFiles.length
                for file in exampleFiles
                    if file.match /\.rsl$/
                        expect(myGrader.problems[file.replace /\.rsl/, ""]).toBeDefined()

            it "gets submissions from the folderPath", ->
                for file in submittedFiles
                    if file.match /\.rsl$/
                        expect(myGrader.problems[file.replace /\.rsl/, ""].submission.match(/SOR,\d+ .* EOR,\d+/)[0]).toEqual fs.readFileSync("#{submissionPath}/#{file}").toString().match(/SOR,\d+ .* EOR,\d+/)[0]

        describe "addTest", ->

            it "exists", ->
                expect(myGrader.addTest).toBeDefined()

        describe "testReport", ->

            it "exists", ->
                expect(myGrader.testReport).toBeDefined()

        describe "run", ->

            it "exists", ->
                expect(myGrader.run).toBeDefined()


).call this