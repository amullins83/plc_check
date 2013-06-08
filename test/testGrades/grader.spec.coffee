(->
    "use strict"

    Grader = require "../../grade/Grader.coffee"
    Find = require "../../models/RSLParser/find.coffee"
    fs = require "fs"

    describe "Grader", ->

        it "exists", ->
            expect(Grader).toBeDefined()

        submissionPath = "./submissions/ch1_2/Dishon"
        submittedFiles = fs.readdirSync submissionPath

        examplePath = "./submissions/ch1_2/Examples"
        exampleFiles = Find.filter fs.readdirSync(examplePath), /^(\d+)-(\d+)([a-z]?)\.rsl$/i

        

        describe "constructor", ->

            myGrader = null

            beforeEach ->
                myGrader = new Grader submissionPath

            it "makes an object", ->
                expect(typeof myGrader).toBe "object"

        describe "initializeProblems", ->

            myGrader = null

            beforeEach ->
                myGrader = new Grader submissionPath
                myGrader.initializeProblems()

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
            myGrader = null

            beforeEach ->
                myGrader = new Grader submissionPath
                myGrader.initializeProblems()
                myGrader.addTest "1-1a", "this passes", 5, {}, {}
                myGrader.addTest "2-2", "this fails", 5, {}, {hey: "ho"}

            it "exists", ->
                expect(myGrader.addTest).toBeDefined()

            it "adds a test function to the specified problem", ->
                expect(myGrader.problems["1-1a"].tests.length).toBe 1
                expect(myGrader.problems["2-2"].tests.length).toBe 1

        describe "addSimpleTest", ->

            myGrader = null

            beforeEach ->
                myGrader = new Grader submissionPath
                myGrader.initializeProblems()

            it "exists", ->
                expect(myGrader.addSimpleTest).toBeDefined()

            it "adds an equivalent test based on arrays instead of dataTable objects", ->
                myGrader.addTest "2-2", "this should always fail",  5, {I: {1: {0: false}}}, {O: {2: {0: true} } }
                myGrader.addSimpleTest "2-2", "this should always fail", 5, [false], [0]
                expect(myGrader.problems["2-2"].tests.length).toBe 2
                expect(myGrader.problems["2-2"].tests[0]()).toEqual myGrader.problems["2-2"].tests[1]()

                myGrader.addTest "2-1", "this should always pass", 5, {I: {1: {0: true}}}, {}
                myGrader.addSimpleTest "2-1", "this should always pass", 5, [true], []

                expect(myGrader.problems["2-1"].tests[0]()).toEqual myGrader.problems["2-1"].tests[1]()
                

        describe "testReport", ->
            myGrader = null

            beforeEach ->
                myGrader = new Grader submissionPath

            it "exists", ->
                expect(myGrader.testReport).toBeDefined()

            it "returns an object with result and feedback keys", ->
                report = myGrader.testReport true, "hey", 5
                expect(report).toEqual {result: true, feedback: "hey", points: 5}

        describe "run", ->
            myGrader = null

            beforeEach ->
                myGrader = new Grader submissionPath

            it "exists", ->
                expect(myGrader.run).toBeDefined()

            it "creates max and score properties", ->
                myGrader.initializeProblems()
                expect(myGrader.max).not.toBeDefined()
                myGrader.run()
                expect(myGrader.max).toBeDefined()
                expect(myGrader.score).toBeDefined()

            describe "returns correct values", ->
                myGrader = null

                beforeEach -> 
                    myGrader = new Grader submissionPath
                    myGrader.initializeProblems()
                    myGrader.addTest "1-1a", "this passes", 15, {}, {}
                    myGrader.addTest "1-2", "this fails", 5, {}, {hey:"ho"}
                    myGrader.run()
                
                it "sets max equal to total possible points", ->
                    expect(myGrader.max).toBe 20

                it "sets score equal to total points earned", ->
                    expect(myGrader.score).toBe 15

).call this