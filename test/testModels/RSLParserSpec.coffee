(->
    "use strict"
    
    process.env.test = true
    
    describe "RSLParser", ->
        
        RSLParser = require "../../models/RSLParserComplete.coffee"
        
        it "should exist", ->
            expect(RSLParser).toBeDefined

        describe "execute method", ->

            it "returns the dataTable on unrecognized instruction", ->
                expect(RSLParser.execute "what", {data: "table"}).toEqual {data: "table"}

            describe "executing start and end instructions", ->

                it "Starts a rung with SOR", ->
                    expect(RSLParser.execute "SOR,0", {data: "table"}).toEqual
                        data : 'table'
                        rungs : [ '0' ]
                        activeRung : '0'
                        rungOpen : true
                        programOpen : true

                it "Ends a rung with EOR", ->
                    expect(RSLParser.execute("EOR,0",
                        rungOpen    : true
                        programOpen : true
                        activeRung  : "0"
                        rungs       : ['0']
                    ).rungOpen).toBe false
).call this