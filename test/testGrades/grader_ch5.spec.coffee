describe "Grader_ch5", ->

    Grader5 = require "../../grade/grader_ch5"
    submissionPath = "./submissions/ch5/Examples"
    examplePath = "./submissions/ch5/Examples"
    fs = require "fs"

    it "exists", ->
        expect(Grader5).toBeDefined()

    describe "constructor", ->
        myGrader = null

        beforeEach ->
            myGrader = new Grader5 submissionPath

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
            pointValues =
                "02":5
                "03":5
                "04":8
                "05a":5
                "05b":5
                "06":10
                "07":5
                "08":8
                "09":6
                "10":5
                "11":4
                "12a":4
                "12b":4
                "13":10
                "14a":4
                "14b":8

            myGrader = new Grader5 submissionPath

        it "adds all problems in problem set", ->
            for problem of pointValues
                expect(myGrader.problems["5-#{problem}"]).toBeDefined()

        it "gives the right number of points for each test", ->
            for problem, pointValue of pointValues
                pointSum = 0
                for test in myGrader.problems["5-#{problem}"].tests
                    pointSum += test().points
                expect("5-#{problem}: #{pointSum}").toEqual "5-#{problem}: #{pointValue}"


    describe "run", ->
        myGrader = null
        expectedGrade = 100
        expectedMax = 96

        beforeEach ->
            myGrader = new Grader5 submissionPath
            fs.writeFile "./chapter5Feedback.txt", myGrader.feedback

        it "returns the right grade", ->
            expect(myGrader.grade).toBe expectedGrade

        it "offers a maximum of #{expectedMax} points", ->
            expect(myGrader.max).toBe expectedMax

