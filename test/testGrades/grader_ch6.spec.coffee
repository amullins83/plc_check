describe "Grader_ch6", ->

    Grader6 = require "../../grade/grader_ch6"
    submissionPath = "./submissions/ch6/Examples"
    examplePath = "./submissions/ch6/Examples"
    fs = require "fs"

    it "exists", ->
        expect(Grader6).toBeDefined()

    describe "constructor", ->
        myGrader = null

        beforeEach ->
            myGrader = new Grader6 submissionPath

        it "returns an object", ->
            expect(typeof myGrader).toBe "object"

        it "calls initializeProblems", ->
            expect(typeof myGrader.problems).toBe "object"

        it "calls run", ->
            expect(myGrader.grade).toBeDefined()


    describe "run", ->
        myGrader = null
        expectedGrade = 100

        beforeEach ->
            myGrader = new Grader6 submissionPath
            fs.writeFile "./testFeedback.txt", myGrader.feedback

        it "returns the right grade", ->
            expect(myGrader.grade).toBe expectedGrade