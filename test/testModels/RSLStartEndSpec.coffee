(->
    "use strict"
    
    process.env.test = true
    
    describe "RSLStartEnd", ->
        
        RSLStartEnd = require "../../models/RSLParser/RSLStartEnd.coffee"
        
        it "should exist", ->
            expect(RSLStartEnd).toBeDefined

        describe "constructor", ->

            it "does nothing", ->
                expect(new RSLStartEnd()).toBeDefined

        describe "SOR", ->

                it "Returns a dataTable with activeRung = '0'", ->
                    expect(RSLStartEnd.SOR(["SOR,0", "0"], {data: "table"}).activeRung).toEqual '0'

).call this