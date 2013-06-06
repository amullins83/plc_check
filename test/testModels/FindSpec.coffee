(->
    "use strict"

    process.env.test = true

    describe "Find", ->
        Find = require("../../models/RSLParser/find.coffee")
    
        testArray = [
            {
                what:"ho"
                hey:"yeah"
            },
            {
                what:"yeah"
                hey:"ho"
            },
            {
                nada:"ningun"
                nohay:"nada"
            }
        ]

        describe "Find", ->
            it "exists", ->
                expect(typeof Find).toEqual "function"
    
            it "finds the first element", ->
                expect(Find.find testArray, {what:"ho", hey:"yeah"}).toEqual 0
        
            it "finds the last element", ->
                expect(Find.find testArray, {nada:"ningun", nohay:"nada"}).toEqual 2
        
            it "finds the middle element", ->
                expect(Find.find testArray, {what:"yeah", hey:"ho"}).toEqual 1
        
            it "returns -1 for unfound object", ->
                expect(Find.find testArray, {notARealProperty:"nothing to see here"}).toEqual -1
).call this