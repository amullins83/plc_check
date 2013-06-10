describe "Grader_ch8", ->

    Grader8 = require "../../grade/grader_ch8"
    submissionPath = "./submissions/ch8/Examples"
    examplePath = "./submissions/ch8/Examples"
    fs = require "fs"

    it "exists", ->
        expect(Grader8).toBeDefined()

    describe "constructor", ->
        myGrader = null

        beforeEach ->
            myGrader = new Grader8 submissionPath

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
                "01":10
                "02":23
                "03":12
                "07a":8
                "07b":14
                "22":24
                "38":38

            myGrader = new Grader8 submissionPath

        it "adds all problems in problem set", ->
            for problem of pointValues
                expect(myGrader.problems["8-#{problem}"]).toBeDefined()

        it "gives the right number of points for each test", ->
            for problem, pointValue of pointValues
                pointSum = 0
                for test in myGrader.problems["8-#{problem}"].tests
                    pointSum += test().points
                expect("8-#{problem}: #{pointSum}").toEqual "8-#{problem}: #{pointValue}"


    describe "run", ->
        myGrader = null
        expectedGrade = 100
        expectedMax = 129

        beforeEach ->
            myGrader = new Grader8 submissionPath
            fs.writeFile "./chapter8Feedback.txt", myGrader.feedback

        it "returns the right grade", ->
            expect(myGrader.grade).toBe expectedGrade

        it "offers a maximum of #{expectedMax} points", ->
            expect(myGrader.max).toBe expectedMax

