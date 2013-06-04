(->
    "use strict"

    process.env.test = true

    describe "Find", ->
        find = require("../../models/RSLParser/find.coffee").find
    
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

        describe "find", ->
            it "exists", ->
                expect(typeof find).toEqual "function"
    
            it "finds the first element", ->
                expect(find testArray, {what:"ho", hey:"yeah"}).toEqual 0
        
            it "finds the last element", ->
                expect(find testArray, {nada:"ningun", nohay:"nada"}).toEqual 2
        
            it "finds the middle element", ->
                expect(find testArray, {what:"yeah", hey:"ho"}).toEqual 1
        
            it "returns -1 for unfound object", ->
                expect(find testArray, {notARealProperty:"nothing to see here"}).toEqual -1
).call this