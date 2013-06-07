(->
    "use strict"
    
    process.env.test = true
    
    describe "RSLParser", ->
        
        RSLParser = require "../../models/RSLParser.coffee"
        Find = require "../../models/RSLParser/find.coffee"
        DataTable = require "../../models/dataTable.coffee"
        fs = require "fs"

        it "should exist", ->
            expect(RSLParser).toBeDefined()

        

        describe "execute method", ->

            it "returns the dataTable on unrecognized instruction", ->
                expect(RSLParser.execute "what", {data: "table"}).toEqual {data: "table"}

            describe "start and end instructions", ->

                it "starts a rung with SOR", ->
                    expect(RSLParser.execute "SOR,0", {data: "table"}).toEqual
                        data : 'table'
                        rungs : [ 0 ]
                        activeRung : 0
                        activeBranch: 0
                        rungOpen : true
                        programOpen : true

                it "ends a rung with EOR", ->
                    expect(RSLParser.execute("EOR,0",
                        rungOpen    : true
                        programOpen : true
                        activeRung  : 0
                        activeBranch: 0
                        rungs       : [0]
                    ).rungOpen).toBe false

                it "destroys any branches with EOR", ->
                    expect(RSLParser.execute("EOR,0",
                        rungOpen : true
                        programOpen : true
                        activeRung : 0 
                        activeBranch: 0
                        rungs : [0]
                        branches : [
                            {
                                topLine: true
                                bottomLine: false
                                onTopLine: false
                                open: false
                            }
                        ]
                    ).branches).not.toBeDefined()

                it "ends a program with END", ->
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

                dt_true_no_branch = ->
                    return new DataTable(true)

                dt_false_no_branch = ->
                    return new DataTable(false)

                dt_true_branch_top = ->
                    _dt_true_branch_top = new DataTable(true)
                    _dt_true_branch_top.addBranch()
                    _dt_true_branch_top.activeBranch = 1
                    return _dt_true_branch_top

                dt_false_branch_top = ->
                    _dt_false_branch_top = new DataTable(false)
                    _dt_false_branch_top.addBranch()
                    _dt_false_branch_top.activeBranch = 1
                    return _dt_false_branch_top

                dt_true_new_branch = ->
                    _dt_true_new_branch = new DataTable(true)
                    _dt_true_new_branch.addBranch()
                    _dt_true_new_branch.addBranch()
                    _dt_true_new_branch.activeBranch = 2
                    return _dt_true_new_branch

                dt_true_new_branch_bottom = ->
                    _dt_true_new_branch_bottom = new DataTable(true)
                    _dt_true_new_branch_bottom.addBranch()
                    _dt_true_new_branch_bottom.addBranch()
                    _dt_true_new_branch_bottom.branches[1].onTopLine = false
                    _dt_true_new_branch_bottom.activeBranch = 2
                    return _dt_true_new_branch_bottom

                dt_true_new_branch_closed = ->
                    _dt_true_new_branch_closed = new DataTable(true)
                    _dt_true_new_branch_closed.addBranch()
                    _dt_true_new_branch_closed.addBranch()
                    _dt_true_new_branch_closed.branches[1].onTopLine = false
                    _dt_true_new_branch_closed.branches[1].open = false
                    _dt_true_new_branch_closed.activeBranch = 1
                    return _dt_true_new_branch_closed

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

                dt_false_branch_bottom = ->
                    dt = dt_false_branch_top()

                dt_false_false = ->
                    dt = new DataTable false
                    dt.I[1][1] = false
                    dt.addBranch()
                    dt.branches[0].topLine = false
                    dt.branches[0].bottomLine = false
                    dt.branches[0].onTopLine = false
                    return dt



                describe "BST", ->

                    it "creates dataTable 'branches' key if it doesn't exist", ->
                        expect(RSLParser.execute "BST,1", dt_true_no_branch()).toEqual dt_true_branch_top()
                        expect(RSLParser.execute "BST,1", dt_false_no_branch()).toEqual dt_false_branch_top()

                    it "pushes new branch", ->
                        expect(RSLParser.execute "BST,2", dt_true_branch_top()).toEqual dt_true_new_branch()

                    it "sets active branch equal to branch number", ->
                        expect(RSLParser.execute("BST,1", dt_true_no_branch()).activeBranch).toBe 1
                        expect(RSLParser.execute("BST,2", dt_true_branch_top()).activeBranch).toBe 2

                describe "NXB", ->

                    it "switches active branch from top to bottom", ->
                        expect(RSLParser.execute "NXB,2", dt_true_new_branch()).toEqual dt_true_new_branch_bottom()

                describe "BND", ->

                    it "closes the current branch", ->
                        expect(RSLParser.execute "BND,2", dt_true_new_branch_bottom()).toEqual dt_true_new_branch_closed()
                        expect(RSLParser.execute "BND,1", dt_in_between()).toEqual dt_true_two_branches_closed()

                    it "decrements active branch number", ->
                        expect(RSLParser.execute("BND,2", dt_true_new_branch_bottom()).activeBranch).toBe 1
                        expect(RSLParser.execute("BND,1", dt_in_between()).activeBranch).toBe 0

                    it "sets rungOpen to false if both branches false", ->
                        expect(RSLParser.execute("BND,1", dt_false_false()).rungOpen).toBe false

        describe "runRung method", ->

            it "exists", ->
                expect(typeof RSLParser.runRung).toEqual "function"


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
                    dt.rungs = [0]
                    return dt

            dt_false_after_rung = ->
                    dt = new DataTable false
                    dt.rungOpen = false
                    dt.rungs = [0]
                    return dt

            dt_any_true_after_rung = (dt_maker)->
                dt = dt_maker()
                dt.rungs = [0]
                dt.addOutput 2,0
                dt.addBranch()
                delete dt.branches
                dt.activeBranch = 0
                dt.rungOpen = false
                return dt

            dt_false_false_after_rung = ->
                dt = dt_false_false()
                dt.rungs = [0]
                dt.addBranch()
                delete dt.branches
                dt.activeBranch = 0
                dt.rungOpen = false
                return dt

            dt_lab1_1_before = (truthArray)->
                dt = new DataTable
                for truth, bit in truthArray
                    dt.I[1][bit] = truth
                return dt

            dt_lab1_1_after = (truthArray)->
                dt = dt_lab1_1_before(truthArray)
                if (truthArray[0] and truthArray[1]) or truthArray[2]
                   dt.addOutput 2,0
                dt.rungs = [0]
                dt.rungOpen = false
                dt.addBranch()
                delete dt.branches
                dt.activeBranch = 0
                return dt

            describe "simple rung", ->

                rungText = "SOR,0 XIC,I:1/0 OTE,O:2/0 EOR,0"


                it "returns dataTable with output on when input is on", ->
                    expect(RSLParser.runRung rungText, dt_true()).toEqual dt_true_after_rung()

                it "returns dataTable when input is off", ->
                    expect(RSLParser.runRung rungText, dt_false()).toEqual dt_false_after_rung()

            describe "series rung", ->

                rungText = "SOR,0 XIC,I:1/0 XIC,I:1/1 OTE,O:2/0 EOR,0"

                it "sets output on when both inputs true", ->
                    expect(RSLParser.runRung rungText, dt_true_true()).toEqual dt_true_true_after_rung()

                it "returns closed dataTable when either input false", ->
                    for dt_maker in [dt_true_false, dt_false_true, dt_false_false]
                        expect(RSLParser.runRung rungText, dt_maker()).toEqual dt_any_false_after_rung(dt_maker)

            describe "branching rung", ->

                rungText = "SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,I:1/1 BND,1 OTE,O:2/0 EOR,0"

                it "sets output on when either input is true", ->
                    for dt_maker in [dt_true_true, dt_true_false, dt_false_true]
                        expect(RSLParser.runRung rungText, dt_maker()).toEqual dt_any_true_after_rung(dt_maker)

                it "returns closed rung when both inputs false", ->
                    expect(RSLParser.runRung rungText, dt_false_false()).toEqual dt_false_false_after_rung()

            describe "series parallel rung", ->

                # This is Lab 1-1 in Petruzella
                rungText = "SOR,0 BST,1 XIC,I:1/0 XIC,I:1/1 NXB,1 XIC,I:1/2 BND,1 OTE,O:2/0 EOR,0"

                it "sets output on when both I:1/0 and I:1/1 are on", ->
                    expect(RSLParser.runRung(rungText, dt_lab1_1_before([true, true, false])).O[2][0]).toBe true
                    expect(RSLParser.runRung(rungText, dt_lab1_1_before([true, true, true])).O[2][0]).toBe true

                it "sets output on when I:1/2 is on", ->
                    expect(RSLParser.runRung(rungText, dt_lab1_1_before([false, false, true])).O[2][0]).toBe true
                    expect(RSLParser.runRung(rungText, dt_lab1_1_before([false, true, true])).O[2][0]).toBe true
                    expect(RSLParser.runRung(rungText, dt_lab1_1_before([true, false, true])).O[2][0]).toBe true
                    expect(RSLParser.runRung(rungText, dt_lab1_1_before([true, true, true])).O[2][0]).toBe true

                it "sets output off otherwise", ->
                    expect(RSLParser.runRung(rungText, dt_lab1_1_before([false, false, false])).O).not.toBeDefined()
                    expect(RSLParser.runRung(rungText, dt_lab1_1_before([false, true, false])).O).not.toBeDefined()
                    expect(RSLParser.runRung(rungText, dt_lab1_1_before([true, false, false])).O).not.toBeDefined()

                it "does precisely what I think it does", ->
                    for i in [0...8]
                        truthArray = [(i >> 2 & 1) == 1, (i >> 1 & 1) == 1, (i & 1) == 1]
                        dt_i = dt_lab1_1_before truthArray
                        dt_o = dt_lab1_1_after truthArray
                        expect(RSLParser.runRung rungText, dt_i).toEqual dt_o

            describe "latch-unlatch rungs", ->

                dt_latch_before = (truthArray)->
                    dt = new DataTable truthArray[0]
                    dt.I[1][1] = truthArray[1]
                    dt.rungs = []
                    return dt

                dt_latch_after = (truthArray)->
                    dt = dt_latch_before(truthArray)
                    dt.rungs = [0]
                    if truthArray[0]
                        dt.latch = [{file: "O", rank: 2, bit: 0}]
                        dt.addOutput 2,0
                    dt.rungOpen = false
                    return dt

                dt_unlatch_after = (truthArray)->
                    dt = dt_latch_after(truthArray)
                    dt.rungs = [0,1]
                    if truthArray[1]
                        if dt.latch?
                            dt.latch = []
                        dt.O =
                            2:
                                0: false
                    dt.activeRung = 1
                    return dt

                rungText0 = "SOR,0 XIC,I:1/0 OTL,O:2/0 EOR,0"
                rungText1 = "SOR,1 XIC,I:1/1 OTU,O:2/0 EOR,1"

                it "latches an output when the input is true", ->
                    for i in [0...4]
                        truthArray = [(i >> 1 & 1) == 1, (i & 1) == 1]
                        expect(RSLParser.runRung rungText0, dt_latch_before(truthArray)).toEqual dt_latch_after(truthArray)

                it "unlatches an output when the input is true", ->
                    for i in [0...4]
                        truthArray = [(i >> 1 & 1) == 1, (i & 1) == 1]
                        expect(RSLParser.runRung rungText1, dt_latch_after(truthArray)).toEqual dt_unlatch_after(truthArray)

        describe "runRoutine method", ->

            dt_in = (truthArray)->
                dt = new DataTable
                for value, bit in truthArray
                    dt.I[1][bit] = value
                dt.rungs = []
                return dt

            it "exists", ->
                expect(RSLParser.runRoutine).toBeDefined()

            describe "lab 1-1a", ->

                lab1a = fs.readFileSync("./submissions/ch1_2/Examples/1-1a.rsl").toString()

                dt_lab1a_in = dt_in

                dt_lab1a_out = (truthArray)->
                    dt = dt_lab1a_in(truthArray)
                    dt.rungs = [0,1]
                    dt.activeRung = 1
                    if (truthArray[0] and truthArray[1]) or truthArray[2]
                        dt.addOutput 2,0
                    dt.rungOpen = false
                    dt.programOpen = false
                    return dt

                it "runs correctly for all combinations of I:1/0, I:1/1, and I:1/2", ->
                    for i in [0...8]
                        truthArray = [(i >> 2 & 1) == 1, (i >> 1 & 1) == 1, (i & 1) == 1]
                        expect(RSLParser.runRoutine lab1a, dt_lab1a_in(truthArray)).toEqual dt_lab1a_out(truthArray)

            describe "lab 2-2", ->

                lab22 = fs.readFileSync("./submissions/ch1_2/Examples/2-2.rsl").toString()

                dt_lab22_in = dt_in

                dt_lab22_out = (truthArray)->
                    dt = dt_lab22_in truthArray
                    dt.rungs = [0...17]
                    dt.activeRung = 16
                    for no_contact in [0,2,3,5,6,7,10,11,14]
                        dt.addOutput 2,no_contact if truthArray[no_contact]
                    for nc_contact in [1,4,8,9,12,13,15]
                        dt.addOutput 2,nc_contact unless truthArray[nc_contact]
                    dt.rungOpen = false
                    dt.programOpen = false
                    return dt

                it "runs correctly for the test case of I:1", ->
                    truthArray = [true,false,true,true,true,false,false,false,true,true,false,false,true,true,false,true]
                    expect(RSLParser.runRoutine lab22, dt_lab22_in(truthArray)).toEqual dt_lab22_out(truthArray)

                it "runs correctly for the inverse case of I:1", ->
                    truthArray = [false,true,false,false,false,true,true,true,false,false,true,true,false,false,true,false]
                    expect(RSLParser.runRoutine lab22, dt_lab22_in(truthArray)).toEqual dt_lab22_out(truthArray)                    
).call this