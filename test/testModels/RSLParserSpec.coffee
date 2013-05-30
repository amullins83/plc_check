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

            describe "start and end instructions", ->

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

                it "Ends a program with END", ->
                    expect(RSLParser.execute("END,1",
                        rungOpen    : true
                        programOpen : true
                        activeRung : "1"
                        rungs : ['0', '1']
                    ).programOpen).toBe false

            describe "bitwise input instructions", ->
                describe "XIC", ->
                    it "returns false when input is false", ->
                        expect(RSLParser.execute "XIC,I:1/0", 
                            "I":
                                "1":
                                    "0":false
                        ).toBe false

                    it "returns the dataTable when input is true", ->
                        dt = 
                            "I":
                                "1":
                                    "0":true
                        expect(RSLParser.execute "XIC,I:1/0", dt).toEqual dt
).call this