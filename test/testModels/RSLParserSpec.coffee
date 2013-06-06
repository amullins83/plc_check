(->
    "use strict"
    
    process.env.test = true
    
    describe "RSLParser", ->
        
        RSLParser = require "../../models/RSLParser.coffee"
        Find = require "../../models/RSLParser/find.coffee"
        DataTable = require "../../models/dataTable.coffee"

        it "should exist", ->
            expect(RSLParser).toBeDefined

        

        describe "execute method", ->

            it "returns the dataTable on unrecognized instruction", ->
                expect(RSLParser.execute "what", {data: "table"}).toEqual {data: "table"}

            describe "start and end instructions", ->

                it "Starts a rung with SOR", ->
                    expect(RSLParser.execute "SOR,0", {data: "table"}).toEqual
                        data : 'table'
                        rungs : [ 0 ]
                        activeRung : 0
                        activeBranch: 0
                        rungOpen : true
                        programOpen : true

                it "Ends a rung with EOR", ->
                    expect(RSLParser.execute("EOR,0",
                        rungOpen    : true
                        programOpen : true
                        activeRung  : 0
                        activeBranch: 0
                        rungs       : [0]
                    ).rungOpen).toBe false

                it "Ends a program with END", ->
                    expect(RSLParser.execute("END,1",
                        rungOpen    : true
                        programOpen : true
                        activeRung : 1
                        activeBranch: 0
                        rungs : [0, 1]
                    ).programOpen).toBe false

            describe "bitwise input instructions", ->
                dt_true = new DataTable true
                dt_false = new DataTable false

                dt_true_closed = new DataTable true
                dt_true_closed.rungOpen = false

                dt_false_closed = new DataTable false
                dt_false_closed.rungOpen = false

                dt_false_with_branch = new DataTable false
                dt_false_with_branch.addBranch()

                dt_false_with_branch_closed = new DataTable false
                dt_false_with_branch_closed.addBranch()
                dt_false_with_branch_closed.branches[0].topLine = false

                describe "XIC", ->
                    it "returns dataTable with rungOpen == false when input is false and activeBranch == 0", ->
                        expect(RSLParser.execute "XIC,I:1/0", dt_false).toEqual dt_false_closed

                    it "returns the dataTable when input is true", ->
                        expect(RSLParser.execute "XIC,I:1/0", dt_true).toEqual dt_true

                    it "sets active branch to false when input is false", ->
                        expect(RSLParser.execute "XIC,I:1/0", dt_false_with_branch).toEqual dt_false_with_branch_closed

                describe "XIO", ->
                    it "returns dataTable with rungOpen == false when input is true", ->
                        expect(RSLParser.execute "XIO,I:1/0", dt_true).toEqual dt_true_closed
                    it "returns the dataTable when input is false", ->
                        expect(RSLParser.execute "XIO,I:1/0", dt_false).toEqual dt_false

            describe "bitwise output instructions", ->
                dt_true = new DataTable true

                dt_true_output_on = new DataTable true
                dt_true_output_on.addOutput 2,0


                dt_false = new DataTable false

                dt_false_output_on = new DataTable false
                dt_false_output_on.addOutput 2,0

                dt_true_output_on_latched = new DataTable true
                dt_true_output_on_latched.addOutput 2,0
                dt_true_output_on_latched.addLatch "O", 2, 0

                dt_true_output_off_unlatched = new DataTable true
                dt_true_output_off_unlatched.addOutput 2,0
                dt_true_output_off_unlatched.O[2][0] = false
                dt_true_output_off_unlatched.latch = []

                describe "OTE", ->
                    it "returns the dataTable with chosen address turned on", ->
                        expect(RSLParser.execute "OTE,O:2/0", dt_true).toEqual dt_true_output_on               
                        expect(RSLParser.execute "OTE,O:2/0", dt_false).toEqual dt_false_output_on

                describe "OTL", ->
                    it "returns the dataTable with chosen address turned on and added to latch list", ->
                        expect(RSLParser.execute "OTL,O:2/0", dt_true).toEqual dt_true_output_on_latched

                describe "OTU", ->
                    it "finds the latched output", ->
                        removeIndex = Find.find dt_true_output_on_latched["latch"], {file: "O", rank: 2, bit: 0}
                        expect(removeIndex).toBe 0

                    it "returns the dataTable with chosen address turned off and removed from latch list", ->
                        expect(RSLParser.execute "OTU,O:2/0", dt_true_output_on_latched).toEqual dt_true_output_off_unlatched

            describe "branch instructions", ->

                dt_true_no_branch = new DataTable(true)

                dt_false_no_branch = new DataTable(false)

                dt_true_branch_top = new DataTable(true)
                dt_true_branch_top.addBranch()
                dt_true_branch_top.activeBranch = 1

                dt_false_branch_top = new DataTable(false)
                dt_false_branch_top.addBranch()
                dt_false_branch_top.activeBranch = 1

                dt_true_new_branch = new DataTable(true)
                dt_true_new_branch.addBranch()
                dt_true_new_branch.addBranch()
                dt_true_new_branch.activeBranch = 2

                dt_true_new_branch_bottom = ->
                    _dt_true_new_branch_bottom = new DataTable(true)
                    _dt_true_new_branch_bottom.addBranch()
                    _dt_true_new_branch_bottom.addBranch()
                    _dt_true_new_branch_bottom.branches[1].onTopLine = false
                    _dt_true_new_branch_bottom.activeBranch = 2
                    return _dt_true_new_branch_bottom

                dt_true_new_branch_closed = new DataTable(true)
                dt_true_new_branch_closed.addBranch()
                dt_true_new_branch_closed.addBranch()
                dt_true_new_branch_closed.branches[1].onTopLine = false
                dt_true_new_branch_closed.branches[1].open = false
                dt_true_new_branch_closed.activeBranch = 1

                dt_true_two_branches_closed = ->
                    _dt_true_two_branches_closed = new DataTable(true)
                    _dt_true_two_branches_closed.addBranch()
                    _dt_true_two_branches_closed.addBranch()
                    _dt_true_two_branches_closed.branches[1].onTopLine = false
                    _dt_true_two_branches_closed.branches[1].open = false
                    _dt_true_two_branches_closed.branches[0].onTopLine = false
                    _dt_true_two_branches_closed.branches[0].open = false
                    _dt_true_two_branches_closed.activeBranch = 0
                    return _dt_true_two_branches_closed

                dt_in_between = ->
                    output = new DataTable true
                    output.addBranch()
                    output.addBranch()
                    output.branches[1].onTopLine = false
                    output.branches[1].open = false
                    output.branches[0].onTopLine = false
                    output.activeBranch = 1
                    return output

                describe "BST", ->

                    it "Creates dataTable 'branches' key if it doesn't exist", ->
                        expect(RSLParser.execute "BST,1", dt_true_no_branch).toEqual dt_true_branch_top
                        expect(RSLParser.execute "BST,1", dt_false_no_branch).toEqual dt_false_branch_top

                    it "Pushes new branch", ->
                        expect(RSLParser.execute "BST,2", dt_true_branch_top).toEqual dt_true_new_branch

                    it "Sets active branch equal to branch number", ->
                        expect(RSLParser.execute("BST,1", dt_true_no_branch).activeBranch).toBe 1
                        expect(RSLParser.execute("BST,2", dt_true_branch_top).activeBranch).toBe 2

                describe "NXB", ->

                    it "Switches active branch from top to bottom", ->
                        expect(RSLParser.execute "NXB,2", dt_true_new_branch).toEqual dt_true_new_branch_bottom()

                describe "BND", ->

                    it "Closes the current branch", ->
                        expect(RSLParser.execute "BND,2", dt_true_new_branch_bottom()).toEqual dt_true_new_branch_closed
                        expect(RSLParser.execute "BND,1", dt_in_between()).toEqual dt_true_two_branches_closed()

                    it "Decrements active branch number", ->
                        expect(RSLParser.execute("BND,2", dt_true_new_branch_bottom()).activeBranch).toBe 1
                        expect(RSLParser.execute("BND,1", dt_in_between()).activeBranch).toBe 0


        describe "RunRung method", ->

            it "exists", ->
                expect(typeof RSLParser.runRung).toEqual "function"
            
            describe "simple rung", ->

                rungText = "SOR,0 XIC,I:1/0 OTE,O:2/0 EOR,0"

                dt_true = ->
                    dt = new DataTable true
                    dt.rungs = []
                    return dt

                dt_false = ->
                    dt = new DataTable false
                    dt.rungs = []
                    return dt

                dt_true_after_rung = -> 
                    dt = new DataTable true
                    dt.addOutput 2,0
                    dt.rungOpen = false
                    return dt

                dt_false_after_rung = ->
                    dt = new DataTable false
                    dt.rungOpen = false
                    return dt

                it "returns dataTable with output on when input is on", ->
                    expect(RSLParser.runRung rungText, dt_true()).toEqual dt_true_after_rung()

                it "returns dataTable when input is off", ->
                    expect(RSLParser.runRung rungText, dt_false()).toEqual dt_false_after_rung()

            describe "series rung", ->

                dt_true_false = ->
                    dt = new DataTable true
                    dt.I[1][1] = false
                    dt.rungs = []
                    return dt

                dt_true_true = ->
                    dt = new DataTable true
                    dt.I[1][1] = true
                    dt.rungs = []
                    return dt

                dt_false_true = ->
                    dt = new DataTable false
                    dt.I[1][1] = true
                    dt.rungs = []
                    return dt

                dt_false_false = ->
                    dt = new DataTable false
                    dt.I[1][1] = false
                    dt.rungs = []
                    return dt

                dt_true_true_after_rung = ->
                    dt = dt_true_true()
                    dt.rungs.push 0
                    dt.addOutput 2,0
                    dt.rungOpen = false
                    return dt                    

                dt_any_false_after_rung = (dt_maker)->
                    dt = dt_maker()
                    dt.rungs.push 0
                    dt.rungOpen = false
                    return dt

                rungText = "SOR,0 XIC,I:1/0 XIC,I:1/1 OTE,O:2/0 EOR,0"

                it "sets output on when both inputs true", ->
                    expect(RSLParser.runRung rungText, dt_true_true()).toEqual dt_true_true_after_rung()

                it "returns closed dataTable when either input false", ->
                    for dt_maker in [dt_true_false, dt_false_true, dt_false_false]
                        expect(RSLParser.runRung rungText, dt_maker()).toEqual dt_any_false_after_rung(dt_maker)

).call this