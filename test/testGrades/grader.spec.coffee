(->
    "use strict"

    Grader = require "../../grade/Grader.coffee"
    Find = require "../../models/find.coffee"
    DataTable = require "../../models/dataTable.coffee"
    RSLParser = require "../../models/RSLParser.coffee"
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
                myGrader.addTest "1-01a", "this passes", 5, {}, {}
                myGrader.addTest "2-002", "this fails", 5, {}, {hey: "ho"}
                myGrader.addTest "5", "five is right out", 2, {should: not "get here"}, {}

            it "exists", ->
                expect(myGrader.addTest).toBeDefined()

            it "adds a test function to the specified problem", ->
                expect(myGrader.problems["1-01a"].tests.length).toBe 1
                expect(myGrader.problems["2-002"].tests.length).toBe 1

            
        describe "simpleAdd", ->

            myGrader = null

            beforeEach ->
                myGrader = new Grader submissionPath
                myGrader.initializeProblems()

            it "exists", ->
                expect(myGrader.simpleAdd).toBeDefined()

            it "adds an equivalent test", ->
                myGrader.addTest "2-02", "this should always fail",  5, {I: {1: {0: false}}, O: {2: {}}}, {O: {2: {0: true}}}
                myGrader.simpleAdd "2-02", "this should always fail", 5, {0:false}, {}, {0:true}
                expect(myGrader.problems["2-02"].tests.length).toBe 2
                expect(myGrader.problems["2-02"].tests[1]()).toEqual myGrader.problems["2-02"].tests[0]()

                myGrader.addTest "2-01", "this should always pass", 5, {I: {1: {0: true}}}, {}
                myGrader.simpleAdd "2-01", "this should always pass", 5, {0:true}, {}, {}

                expect(myGrader.problems["2-01"].tests[1]()).toEqual myGrader.problems["2-01"].tests[0]()
                

        describe "testReport", ->
            myGrader = null
            report = null

            beforeEach ->
                myGrader = new Grader submissionPath
                report = myGrader.testReport true, "hey", 5, "ho"

            it "exists", ->
                expect(typeof myGrader.testReport).toEqual "function"

            it "returns an object with result key boolean", ->
                expect(typeof report.result).toEqual "boolean"

            it "returns an object with feedback string", ->
                expect(typeof report.feedback).toEqual "string"

            it "returns an object with debug string", ->
                expect(typeof report.debug).toEqual "string"

        describe "addOrTest", ->
            myGrader = null

            beforeEach ->
                myGrader = new Grader submissionPath
                myGrader.initializeProblems()

            it "adds a test that passes when any give condition set is true", ->
                myGrader.addOrTest("2-02", "output O:2/0 should be on if I:1/0 is on or off", 5, [{I: {1: {0:true}}}, {I: {1: {0:false}}}], [{O: {2: {0:true}}}, {O: {2: {0:true}}}])
                expect(myGrader.problems["2-02"].tests[0]().result).toBe true

            it "pushes a test that returns a test report", ->
                failDescription = "nothing to see here"
                points = 5
                myGrader.addOrTest("2-02", failDescription, points, [{I: {1: {0:false}}}], [{O: {2: {0:true}}}])
                myGrader.addOrTest("2-02", failDescription, points, [{I: {1: {0:false}}}], [{O: {2: {0:false}}}])
                expect(myGrader.problems["2-02"].tests[0]()).toEqual myGrader.testReport false, failDescription, points
                expect(myGrader.problems["2-02"].tests[1]()).toEqual myGrader.testReport true,  "Good!", points

        describe "simpleAddOr", ->
            myGrader = null

            beforeEach ->
                myGrader = new Grader submissionPath
                myGrader.initializeProblems()

            it "adds an equivalent OR test", ->
                myGrader.addOrTest "2-02", "this should always fail",  5, [{I: {1: {0: false}}, O: {2: {}}}, {I: {1: {1:false}}, O: {2: {}}}], [{O: {2: {0: true}}}, {O: {2: {0:true}}}]
                myGrader.simpleAddOr "2-02", "this should always fail", 5, [{0:false}, {1:false}], [{}, {}], [{0:true}, {0:true}]
                expect(myGrader.problems["2-02"].tests.length).toBe 2
                expect(myGrader.problems["2-02"].tests[1]()).toEqual myGrader.problems["2-02"].tests[0]()

                myGrader.addOrTest "2-01", "this should always pass", 5, [{I: {1: {0: true}}}, {I: {1: {0:false}}}], [{}, {}]
                myGrader.simpleAdd "2-01", "this should always pass", 5, [{0:true}, {0:false}], [{},{}], [{},{}]

                expect(myGrader.problems["2-01"].tests[1]()).toEqual myGrader.problems["2-01"].tests[0]()
             

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
                    myGrader.addTest "1-01a", "this passes", 15, {}, {}
                    myGrader.addTest "1-02", "this fails", 5, {}, {hey:"ho"}
                    myGrader.run()
                
                it "sets max equal to total possible points", ->
                    expect(myGrader.max).toBe 20

                it "sets score equal to total points earned", ->
                    expect(myGrader.score).toBe 15

        describe "runThroughTwice", ->
            
            describe 'returns a function', ->
                myGrader = firstInput = secondInput = programText = null

                beforeEach ->
                    myGrader = new Grader submissionPath
                    firstInput = {0:true, 1:false}
                    secondInput = {0:false, 1:true}
                    programText = """
                        SOR,0 XIO,I:1/0 XIC,O:2/1 OTE,O:2/0 EOR,0
                        SOR,1 XIO,I:1/1 XIO,O:2/0 OTE,O:2/1 EOR,1
                        SOR,2 END,2
                    """
                    myGrader.problems = 
                        test:
                            submission: programText
                            tests: []
                    
                
                it ".", ->
                    expect(typeof myGrader.runThroughTwice("test", firstInput, secondInput)).toBe "function"

                it "that runs through the program twice", ->
                    runThrough = myGrader.runThroughTwice("test", firstInput, secondInput)

                    initialDataTable = new DataTable()
                    for bit, value of firstInput
                        initialDataTable.I[1][bit] = value

                    intermediateDataTable = RSLParser.runRoutine programText, initialDataTable

                    for bit, value of secondInput
                        intermediateDataTable.I[1][bit] = value

                    finalDataTable = RSLParser.runRoutine programText, intermediateDataTable

                    expect(runThrough()).toEqual finalDataTable

        describe "runThroughXtimes", ->
            
            describe 'returns a function', ->
                myGrader = inputArray = programText = null
                
                beforeEach ->
                    myGrader = new Grader submissionPath
                    inputArray = ({0: i % 2 == 0} for i in [0...50])
                    programText = "SOR,0 XIC,I:1/0 CTU,C5:0,50 EOR,0 SOR,1 END,1"
                    myGrader.problems = 
                        test:
                            submission: programText
                            tests: []
                    
                
                it ".", ->
                    expect(typeof myGrader.runThroughXtimes("test", inputArray)).toBe "function"

                it "that runs through the program n times (with n=50)", ->
                    runThrough = myGrader.runThroughXtimes("test", inputArray)

                    dt = new DataTable()
                    
                    for inputObject in inputArray
                        dt.I[1] = inputObject
    
                        dt = RSLParser.runRoutine programText, dt

                    expect(runThrough()).toEqual dt

).call this