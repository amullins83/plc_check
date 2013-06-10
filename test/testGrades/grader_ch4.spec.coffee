describe "Grader_ch4", ->

    Grader4 = require "../../grade/grader_ch4"
    submissionPath = "./submissions/ch4/Examples"
    examplePath = "./submissions/ch4/Examples"
    fs = require "fs"

    it "exists", ->
        expect(Grader4).toBeDefined()

    describe "constructor", ->
        myGrader = null

        beforeEach ->
            myGrader = new Grader4 submissionPath

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
                "01":6
                "02":9
                "03":3
                "04":3
                "05":4
                "06":5
                "07":4
                "08":5
                "09":3
                "10":5
                "11":6
                "12":6
                "13":7
                "14":5
                "15":5
                "16":5
                "17":5
                "18":6
                "19":5
                "20":4
                "21":5
                "22":6
                "23":7
                "24":5
                "25":5
                "26":4
                "27":4

            myGrader = new Grader4 submissionPath

        it "adds all problems in problem set", ->
            for problem of pointValues
                expect(myGrader.problems["4-#{problem}"]).toBeDefined()

        it "gives the right number of points for each test", ->
            for problem, pointValue of pointValues
                pointSum = 0
                for test in myGrader.problems["4-#{problem}"].tests
                    pointSum += test().points
                expect("4-#{problem}: #{pointSum}").toEqual "4-#{problem}: #{pointValue}"


    describe "run", ->
        myGrader = null
        expectedGrade = 100
        expectedMax = 137

        beforeEach ->
            myGrader = new Grader4 submissionPath
            fs.writeFile "./chapter4Feedback.txt", myGrader.feedback

        it "returns the right grade", ->
            expect(myGrader.grade).toBe expectedGrade

        it "offers a maximum of #{expectedMax} points", ->
            expect(myGrader.max).toBe expectedMax

