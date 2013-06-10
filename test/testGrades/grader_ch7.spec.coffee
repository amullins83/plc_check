describe "Grader_ch7", ->

    Grader7 = require "../../grade/grader_ch7"
    submissionPath = "./submissions/ch7/Examples"
    examplePath = "./submissions/ch7/Examples"
    fs = require "fs"

    it "exists", ->
        expect(Grader7).toBeDefined()

    describe "constructor", ->
        myGrader = null

        beforeEach ->
            myGrader = new Grader7 submissionPath

        it "returns an object", ->
            expect(typeof myGrader).toBe "object"

        it "calls initializeProblems", ->
            expect(typeof myGrader.problems).toBe "object"

        it "calls run", ->
            expect(myGrader.grade).toBeDefined()

    describe "initializeProblems", ->

        myGrader = null
        pointValues = {}

        beforeEach ->
            pointValues = {"01":6, "05":10, "07":11, "09":16, "10":12, "13":10, "17a":9, "17b":10, "22":14}
            myGrader = new Grader7 submissionPath

        it "adds all problems in problem set", ->
            for problem of pointValues
                expect(myGrader.problems["7-#{problem}"]).toBeDefined()

        it "gives the right number of points for each test", ->
            for problem, pointValue of pointValues
                pointSum = 0
                for test in myGrader.problems["7-#{problem}"].tests
                    pointSum += test().points
                expect("7-#{problem}: #{pointSum}").toEqual "7-#{problem}: #{pointValue}"


    describe "run", ->
        myGrader = null
        expectedGrade = 100
        expectedMax = 98

        beforeEach ->
            myGrader = new Grader7 submissionPath
            fs.writeFile "./testFeedback.txt", myGrader.feedback

        it "returns the right grade", ->
            expect(myGrader.grade).toBe expectedGrade

        it "offers a maximum of #{expectedMax} points", ->
            expect(myGrader.max).toBe expectedMax

