describe "Grader_ch1_2", ->

    Grader1 = require "../../grade/grader_ch1_2"
    submissionPath = "./submissions/ch1_2/Dishon"
    examplePath = "./submissions/ch1_2/Examples"
    fs = require "fs"

    it "exists", ->
        expect(Grader1).toBeDefined()

    describe "constructor", ->
        myGrader = null

        beforeEach ->
            myGrader = new Grader1 submissionPath

        it "returns an object", ->
            expect(typeof myGrader).toBe "object"

        it "calls initializeProblems", ->
            expect(typeof myGrader.problems).toBe "object"

        it "calls run", ->
            expect(myGrader.grade).toBeDefined()


    describe "run", ->
        myGrader = null
        expectedGrade = 1.0

        beforeEach ->
            myGrader = new Grader1 submissionPath
            fs.writeFile "./testFeedback.txt", myGrader.feedback

        it "returns the right grade", ->
            expect(myGrader.grade).toBe expectedGrade