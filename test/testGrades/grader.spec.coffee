(->
    "use strict"

    Grader = require "../../grade/Grader.coffee"
    Find = require "../../models/RSLParser/find.coffee"
    DataTable = require "../../models/dataTable.coffee"
    fs = require "fs"

    describe "Grader", ->

        it "exists", ->
            expect(Grader).toBeDefined()

        submissionPath = "./submissions/ch1_2/Dishon"
        submittedFiles = Find.filter fs.readdirSync(submissionPath), /^(\d+)-(\d+)([a-z]?)\.rsl$/i


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
                myGrader.addTest "5", "five is right out", 2, {should: not "get here"}, {}

            it "exists", ->
                expect(myGrader.addTest).toBeDefined()

            it "adds a test function to the specified problem", ->
                expect(myGrader.problems["1-1a"].tests.length).toBe 1
                expect(myGrader.problems["2-2"].tests.length).toBe 1

            it "automatically fails if no submission text exists", ->
                expect(myGrader.problems["5"].tests[0]().result).toBe false

        describe "simpleAdd", ->

            myGrader = null

            beforeEach ->
                myGrader = new Grader submissionPath
                myGrader.initializeProblems()

            it "exists", ->
                expect(myGrader.simpleAdd).toBeDefined()

            it "adds an equivalent test", ->
                myGrader.addTest "2-2", "this should always fail",  5, {I: {1: {0: false}}, O: {2: {}}}, {O: {2: {0: true}}}
                myGrader.simpleAdd "2-2", "this should always fail", 5, {0:false}, {}, {0:true}
                expect(myGrader.problems["2-2"].tests.length).toBe 2
                expect(myGrader.problems["2-2"].tests[1]()).toEqual myGrader.problems["2-2"].tests[0]()

                myGrader.addTest "2-1", "this should always pass", 5, {I: {1: {0: true}}}, {}
                myGrader.simpleAdd "2-1", "this should always pass", 5, {0:true}, {}, {}

                expect(myGrader.problems["2-1"].tests[1]()).toEqual myGrader.problems["2-1"].tests[0]()
                

        describe "testReport", ->
            myGrader = null

            beforeEach ->
                myGrader = new Grader submissionPath

            it "exists", ->
                expect(myGrader.testReport).toBeDefined()

            it "returns an object with result and feedback keys", ->
                report = myGrader.testReport true, "hey", 5
                expect(report).toEqual {result: true, feedback: "hey", points: 5}

        describe "addOrTest", ->
            myGrader = null

            beforeEach ->
                myGrader = new Grader submissionPath
                myGrader.initializeProblems()

            it "adds a test that passes when any give condition set is true", ->
                myGrader.addOrTest("2-2", "output O:2/0 should be on if I:1/0 is on or off", 5, [{I: {1: {0:true}}}, {I: {1: {0:false}}}], [{O: {2: {0:true}}}, {O: {2: {0:true}}}])
                expect(myGrader.problems["2-2"].tests[0]().result).toBe true

            it "pushes a test that returns a test report", ->
                failDescription = "nothing to see here"
                points = 5
                myGrader.addOrTest("2-2", failDescription, points, [{I: {1: {0:false}}}], [{O: {2: {0:true}}}])
                myGrader.addOrTest("2-2", failDescription, points, [{I: {1: {0:false}}}], [{O: {2: {0:false}}}])
                expect(myGrader.problems["2-2"].tests[0]()).toEqual myGrader.testReport false, failDescription, points
                expect(myGrader.problems["2-2"].tests[1]()).toEqual myGrader.testReport true,  "Good!", points

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