(->
    "use strict"
    
    process.env.test = true
    
    describe "RSLParser", ->
        
        RSLParser = require "../../models/RSLParser.coffee"
        Find = require "../../models/find.coffee"
        DataTable = require "../../models/dataTable.coffee"
        fs = require "fs"
        RSLCounterTimer = require "../../models/RSLParser/RSLCounterTimer.coffee"

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
                dt_true = ->
                    new DataTable true

                dt_true_output_on = ->
                    dt = new DataTable true
                    dt.addOutput 2,0
                    return dt

                dt_true_output_off = ->
                    dt = new DataTable true
                    dt.addOutput 2,0,false
                    return dt

                dt_false_output_off = ->
                    dt = new DataTable false
                    dt.addOutput 2,0,false
                    return dt

                dt_true_output_on_rung_closed = ->
                    dt = dt_true_output_on()
                    dt.rungOpen = false
                    return dt

                dt_true_output_off_rung_closed = ->
                    dt = dt_true_output_off()
                    dt.rungOpen = false
                    return dt

                dt_false_output_on_rung_closed = ->
                    dt = dt_false_output_on()
                    dt.rungOpen = false
                    return dt

                dt_false_output_off_rung_closed = ->
                    dt = dt_false_output_off()
                    dt.rungOpen = false
                    return dt

                dt_false = ->
                    new DataTable false

                dt_false_output_on = ->
                    dt = new DataTable false
                    dt.addOutput 2,0
                    return dt

                dt_true_output_on_latched = ->
                    dt = new DataTable true
                    dt.addOutput 2,0
                    dt.addLatch "O", 2, 0
                    return dt

                dt_true_output_off_unlatched = ->
                    dt = new DataTable true
                    dt.addOutput 2,0,false
                    dt.latch = []
                    return dt

                dt_true_output_on_topLine_false = ->
                    dt = dt_true_output_on()
                    dt.addBranch()
                    dt.branches[0].topLine = false
                    return dt

                dt_true_output_off_topLine_false = ->
                    dt = dt_true_output_off()
                    dt.addBranch()
                    dt.branches[0].topLine = false
                    return dt

                dt_true_output_on_bottomLine_false = ->
                    dt = dt_true_output_on()
                    dt.addBranch()
                    dt.branches[0].bottomLine = false
                    dt.branches[0].onTopLine = false
                    return dt

                dt_true_output_off_bottomLine_false = ->
                    dt = dt_true_output_off()
                    dt.addBranch()
                    dt.branches[0].bottomLine = false
                    dt.branches[0].onTopLine = false
                    return dt

                dt_true_output_on_topLine_true_rung_closed = ->
                    dt = dt_true_output_on_rung_closed()
                    dt.addBranch()
                    return dt

                dt_true_output_off_topLine_true_rung_closed = ->
                    dt = dt_true_output_off_rung_closed()
                    dt.addBranch()
                    return dt

                dt_true_output_on_bottomLine_true_rung_closed = ->
                    dt = dt_true_output_on_rung_closed()
                    dt.addBranch()
                    dt.branches[0].onTopLine = false
                    return dt

                dt_true_output_off_bottomLine_true_rung_closed = ->
                    dt = dt_true_output_off_rung_closed()
                    dt.addBranch()
                    dt.branches[0].onTopLine = false
                    return dt

                dt_true_output_on_latched_rungClosed = ->
                    dt = dt_true_output_on_latched()
                    dt.rungOpen = false
                    return dt
                
                dt_true_output_on_latched_topLine_false = ->
                    dt = dt_true_output_on_latched()
                    dt.addBranch()
                    dt.branches[0].topLine = false
                    return dt
                
                dt_true_output_on_latched_topLine_true_rungClosed = ->
                    dt = dt_true_output_on_latched()
                    dt.addBranch()
                    dt.rungOpen = false
                    return dt

                describe "OTE", ->
                    it "returns the dataTable with chosen address turned on if rung open and not on a branch", ->
                        expect(RSLParser.execute "OTE,O:2/0", dt_true()).toEqual dt_true_output_on()               
                        expect(RSLParser.execute "OTE,O:2/0", dt_false()).toEqual dt_false_output_on()

                    it "returns the dataTable with chosen address turned OFF if rung closed", ->
                        expect(RSLParser.execute "OTE,O:2/0", dt_true_output_on_rung_closed()).toEqual dt_true_output_off_rung_closed()               
                        expect(RSLParser.execute "OTE,O:2/0", dt_false_output_on_rung_closed()).toEqual dt_false_output_off_rung_closed()

                    it "returns the dataTable with chosen address turned OFF if branch false and rung open", ->
                        expect(RSLParser.execute "OTE,O:2/0", dt_true_output_on_topLine_false()).toEqual dt_true_output_off_topLine_false()
                        expect(RSLParser.execute "OTE,O:2/0", dt_true_output_on_bottomLine_false()).toEqual dt_true_output_off_bottomLine_false()


                    it "returns the dataTable with chosen address turned OFF if branch true and rung closed", ->
                        expect(RSLParser.execute "OTE,O:2/0", dt_true_output_on_topLine_true_rung_closed()).toEqual dt_true_output_off_topLine_true_rung_closed()
                        expect(RSLParser.execute "OTE,O:2/0", dt_true_output_on_bottomLine_true_rung_closed()).toEqual dt_true_output_off_bottomLine_true_rung_closed()

                describe "OTL", ->
                    it "returns the dataTable with chosen address turned on and added to latch list", ->
                        expect(RSLParser.execute "OTL,O:2/0", dt_true()).toEqual dt_true_output_on_latched()

                    it "does nothing if the rung is closed and not on a branch", ->
                        expect(RSLParser.execute "OTL,O:2/0", dt_true_output_off_rung_closed()).toEqual dt_true_output_off_rung_closed()

                    it "does nothing if the rung is open and on a false branch", ->
                        expect(RSLParser.execute "OTL,O:2/0", dt_true_output_off_topLine_false()).toEqual dt_true_output_off_topLine_false()

                    it "does nothing if the rung is closed and on a true branch", ->
                        expect(RSLParser.execute "OTL,O:2/0", dt_true_output_off_topLine_true_rung_closed()).toEqual dt_true_output_off_topLine_true_rung_closed()

                describe "OTU", ->
                    it "finds the latched output", ->
                        removeIndex = Find.find dt_true_output_on_latched()["latch"], {file: "O", rank: 2, bit: 0}
                        expect(removeIndex).toBe 0

                    it "returns the dataTable with chosen address turned off and removed from latch list", ->
                        expect(RSLParser.execute "OTU,O:2/0", dt_true_output_on_latched()).toEqual dt_true_output_off_unlatched()

                    it "does nothing if the rung is closed and not on a branch", ->
                        expect(RSLParser.execute "OTU,O:2/0", dt_true_output_on_latched_rungClosed()).toEqual dt_true_output_on_latched_rungClosed()

                    it "does nothing if the rung is open and on a false branch", ->
                        expect(RSLParser.execute "OTU,O:2/0", dt_true_output_on_latched_topLine_false()).toEqual dt_true_output_on_latched_topLine_false()

                    it "does nothing if the rung is closed and on a true branch", ->
                        expect(RSLParser.execute "OTU,O:2/0", dt_true_output_on_latched_topLine_true_rungClosed()).toEqual dt_true_output_on_latched_topLine_true_rungClosed()

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

            describe "logical function", ->

                tens   = [false,true,false,true,false,true,false,true,false,true,false,true,false,true,false,true]
                fives  = [true,false,true,false,true,false,true,false,true,false,true,false,true,false,true,false]
                effs   = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true]
                zeros  = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
                threes = [true,true,false,false,true,true,false,false,true,true,false,false,true,true,false,false]
                sees   = [false,false,true,true,false,false,true,true,false,false,true,true,false,false,true,true]

                bitwiseAND = (a,b)->
                    return a and b

                bitwiseOR = (a,b)->
                    return a or b

                bitwiseXOR = (a,b)->
                    return (a and not b) or (b and not a)

                bitwiseNOT = (a)->
                    return not a

                dt_logical_in = (source_bits_A, source_bits_B)->
                    dt = new DataTable
                    for value, bit in source_bits_A
                        dt.I[1][bit] = value

                    dt.I[3] = {}

                    for value, bit in source_bits_B
                        dt.I[3][bit] = value

                    return dt

                dt_logical_out = (source_bits_A, source_bits_B, bitwiseFunction)->
                    dt = dt_logical_in source_bits_A, source_bits_B
                        
                    dt.O = {2: {}}
                        
                    for bit,value of dt.I[1]
                        dt.O[2][bit] = bitwiseFunction dt.I[1][bit], dt.I[3][bit]
                        
                    return dt

                dt_logical_in_rung_closed = (source_bits_A, source_bits_B)->
                    dt = dt_logical_in source_bits_A, source_bits_B

                    dt.rungOpen = false

                    return dt

                dt_not_in = (source_bits_A)->
                    dt = new DataTable

                    for value, bit in source_bits_A
                        dt.I[1][bit] = value

                    return dt

                dt_not_out = (source_bits_A)->
                    dt = dt_not_in source_bits_A

                    dt.O = {2: {}}

                    for bit,value of dt.I[1]
                        dt.O[2][bit] = not dt.I[1][bit]

                    return dt

                dt_not_in_rung_closed = (source_bits_A)->
                    dt = dt_not_in source_bits_A

                    dt.rungOpen = false

                    return dt

                dt_logical_in_branch_false = (source_bits_A, source_bits_B)->
                    dt = dt_logical_in source_bits_A, source_bits_B

                    dt.addBranch()

                    dt.branches[0].topLine = false

                    return dt

                dt_not_in_branch_false = (source_bits_A)->
                    dt = dt_not_in source_bits_A

                    dt.addBranch()

                    dt.branches[0].topLine = false

                    return dt

                logicalInstructions =
                    "AND": bitwiseAND
                    "OR" : bitwiseOR
                    "XOR": bitwiseXOR

                for instruction, bitwiseFunction of logicalInstructions
                    describe instruction, ->

                        it "returns a dataTable with destination rank equal to the #{instruction} of the source ranks if rung is open", ->
                            for source_A in [zeros, effs, fives, tens, sees, threes]
                                for source_B in [zeros, effs, fives, tens, sees, threes]
                                    expect(RSLParser.execute "#{instruction},I:1,I:3,O:2", dt_logical_in(source_A, source_B) ).toEqual dt_logical_out source_A, source_B, bitwiseFunction

                        it "does nothing if rung is closed", ->
                            expect(RSLParser.execute "#{instruction},I:1,I:3,O:2", dt_logical_in_rung_closed(fives, effs)).toEqual dt_logical_in_rung_closed(fives,effs)

                        it "does nothing if branch is false", ->
                            expect(RSLParser.execute "#{instruction},I:1,I:3,O:2", dt_logical_in_branch_false(fives, effs)).toEqual dt_logical_in_branch_false(fives,effs)

                describe "NOT", ->

                    it "returns a dataTable with destination rank equal to the NOT of the source ranks if rung is open", ->
                        for source_A in [zeros, effs, fives, tens, sees, threes]
                            expect(RSLParser.execute "NOT,I:1,O:2", dt_not_in source_A ).toEqual dt_not_out source_A

                    it "does nothing if rung is closed", ->
                        expect(RSLParser.execute "NOT,I:1,O:2", dt_not_in_rung_closed fives).toEqual dt_not_in_rung_closed fives

                    it "does nothing if branch is false", ->
                        expect(RSLParser.execute "NOT,I:1,O:2", dt_not_in_branch_false(fives)).toEqual dt_not_in_branch_false(fives)

            describe "timer functions", ->



                dt_true = ->
                    new DataTable true

                dt_t4_0_ton_tick = (preset)->
                    dt = new DataTable true

                    dt.T4 = {0: new RSLCounterTimer.Timer 0, preset}

                    dt.T4[0].tick()
                    dt.T4[0].en = true

                    return dt

                testPreset = 3

                testTimer = ->
                    t = new RSLCounterTimer.Timer 0, testPreset
                    t.tick()
                    t.en = true
                    return t

                testTimerOff = ->
                    t = new RSLCounterTimer.Timer 0, testPreset
                    t.en = true
                    t.dn = true
                    t.tt = false
                    return t

                dt_t4_0_ton_tick_rung_closed = (preset)->
                    dt = dt_t4_0_ton_tick preset
                    dt.rungOpen = false
                    return dt

                dt_t4_0_ton_tick_branch_false = (preset)->
                    dt = dt_t4_0_ton_tick preset
                    dt.addBranch()
                    dt.branches[0].topLine = false
                    return dt

                dt_false = ->
                    dt = new DataTable false
                    dt.rungOpen = false
                    return dt

                dt_t4_0_tof_tick = (preset)->
                    dt = dt_false()
                    dt.T4 = {0: new RSLCounterTimer.Timer 0, preset}
                    dt.T4[0].tick()
                    dt.T4[0].en = false
                    dt.T4[0].dn = true
                    return dt

                dt_t4_0_tof_tick_rung_open = (preset)->
                    dt = dt_t4_0_tof_tick preset
                    dt.rungOpen = true
                    return dt

                dt_t4_0_tof_tick_branch_true = (preset)->
                    dt = dt_t4_0_tof_tick_rung_open preset
                    dt.addBranch()
                    return dt

                dt_t4_0_tof_tick_branch_false = (preset)->
                    dt = dt_t4_0_tof_tick_branch_true preset
                    dt.branches[0].topLine = false
                    return dt


                describe "TON", ->

                    it "creates a timer file if it doesn't exist", ->
                        expect(RSLParser.execute("TON,T4:0,10", dt_true()).T4[0]).toBeDefined()

                    it "creates a timer at the specified address", ->
                        expect(RSLParser.execute("TON,T4:0,#{testPreset}", dt_true()).T4[0]).toEqual testTimer()

                    it "increments accumulator", ->
                        expect(RSLParser.execute("TON,T4:0,#{testPreset}", dt_t4_0_ton_tick testPreset).T4[0].acc).toBe 2

                    it "becomes done when preset reached", ->
                        expect(RSLParser.execute("TON,T4:0,2", dt_t4_0_ton_tick 2).T4[0].dn).toBe true

                    it "resets when rung is false", ->
                        expect(RSLParser.execute("TON,T4:0,#{testPreset}", dt_t4_0_ton_tick_rung_closed testPreset).T4[0].acc).toBe 0

                    it "resets when branch is false", ->
                        expect(RSLParser.execute("TON,T4:0,#{testPreset}", dt_t4_0_ton_tick_branch_false testPreset).T4[0].acc).toBe 0

                describe "TOF", ->

                    it "creates a timer file if it doesn't exist", ->
                        expect(RSLParser.execute("TOF,T4:0,10", dt_true()).T4[0]).toBeDefined()

                    it "creates a timer at the specified address", ->
                        expect(RSLParser.execute("TOF,T4:0,#{testPreset}", dt_true()).T4[0]).toEqual testTimerOff()

                    it "increments accumulator", ->
                        expect(RSLParser.execute("TOF,T4:0,#{testPreset}", dt_t4_0_tof_tick testPreset).T4[0].acc).toBe 2

                    it "becomes done when enabled", ->
                        expect(RSLParser.execute("TOF,T4:0,#{testPreset}", dt_true testPreset).T4[0].dn).toBe true

                    it "done becomes false when preset reached", ->
                        expect(RSLParser.execute("TOF,T4:0,2", dt_t4_0_tof_tick 2).T4[0].dn).toBe false

                    it "resets when rung is true and not on a branch", ->
                        expect(RSLParser.execute("TOF,T4:0,#{testPreset}", dt_t4_0_tof_tick_rung_open testPreset).T4[0].acc).toBe 0

                    it "resets when rung is true and branch is true", ->
                        expect(RSLParser.execute("TOF,T4:0,#{testPreset}", dt_t4_0_tof_tick_branch_true testPreset).T4[0].acc).toBe 0

                describe "RTO", ->
                    it "creates a timer file if it doesn't exist", ->
                        expect(RSLParser.execute("RTO,T4:0,10", dt_true()).T4[0]).toBeDefined()

                    it "creates a timer at the specified address", ->
                        expect(RSLParser.execute("RTO,T4:0,#{testPreset}", dt_true()).T4[0]).toEqual testTimer()

                    it "increments accumulator", ->
                        expect(RSLParser.execute("RTO,T4:0,#{testPreset}", dt_t4_0_ton_tick testPreset).T4[0].acc).toBe 2

                    it "becomes done when preset reached", ->
                        expect(RSLParser.execute("RTO,T4:0,2", dt_t4_0_ton_tick 2).T4[0].dn).toBe true

                    it "does nothing when rung is false", ->
                        expect(RSLParser.execute("RTO,T4:0,#{testPreset}", dt_t4_0_ton_tick_rung_closed testPreset).T4[0].acc).toBe 1

                    it "does nothing when on a false branch", ->
                        expect(RSLParser.execute("RTO,T4:0,#{testPreset}", dt_t4_0_ton_tick_branch_false testPreset).T4[0].acc).toBe 1

                describe "RES", ->

                    it "resets an RTO timer", ->
                        expect(RSLParser.execute("RES,T4:0", dt_t4_0_ton_tick testPreset).T4[0].acc).toBe 0

                    it "resets a counter", ->
                        testCounter = (preset)->
                            c = new RSLCounterTimer.Counter 0, preset
                            c.tickUp()
                            return c

                        dt_test_counter = ->
                            dt = new DataTable

                            dt.C5 = {0: testCounter 5}

                            return dt

                        expect(RSLParser.execute("RES,C5:0", dt_test_counter()).C5[0].acc).toBe 0

            describe "counter functions", ->

                testCounterUp = (preset)->
                    c = new RSLCounterTimer.Counter 0, preset
                    c.CU()
                    return c

                dt_test_counter_up = (accValue)->
                    dt = new DataTable

                    dt.C5 = {0: testCounterUp 5}
                    dt.C5[0].acc = accValue

                    return dt

                testCounterDown = (preset)->
                    c = new RSLCounterTimer.Counter 0, preset
                    c.CD()
                    return c

                dt_test_counter_down = (accValue)->
                    dt = new DataTable

                    dt.C5 = {0: testCounterDown 5}
                    dt.C5[0].acc = accValue

                    return dt

                testAcc = 3

                describe "CTU", ->

                    it "creates a counter file if it doesn't exist", ->
                        expect(RSLParser.execute("CTU,C5:0,5", new DataTable).C5[0]).toBeDefined()

                    it "creates a new counter at the specified address", ->
                        expect(RSLParser.execute("CTU,C5:0,5", new DataTable).C5[0]).toEqual testCounterUp 5

                    it "increments the accumulator", ->
                        expect(RSLParser.execute("CTU,C5:0,5", dt_test_counter_up 3).C5[0].acc).toBe 4

                    it "does nothing if rung closed", ->
                        dt_test_counter_up_rung_closed = dt_test_counter_up testAcc
                        dt_test_counter_up_rung_closed.rungOpen = false
                        expect(RSLParser.execute("CTU,C5:0,5", dt_test_counter_up_rung_closed).C5[0].acc).toBe testAcc

                    it "does nothing if branch false", ->
                        dt_test_counter_up_branch_false = dt_test_counter_up testAcc
                        dt_test_counter_up_branch_false.addBranch()
                        dt_test_counter_up_branch_false.branches[0].topLine = false
                        expect(RSLParser.execute("CTU,C5:0,5", dt_test_counter_up_branch_false).C5[0].acc).toBe testAcc

                describe "CTD", ->

                    it "creates a counter file if it doesn't exist", ->
                        expect(RSLParser.execute("CTD,C5:0,5", new DataTable).C5[0]).toBeDefined()

                    it "creates a new counter at the specified address", ->
                        expect(RSLParser.execute("CTD,C5:0,5", new DataTable).C5[0]).toEqual testCounterDown 5

                    it "increments the accumulator", ->
                        expect(RSLParser.execute("CTD,C5:0,5", dt_test_counter_down 3).C5[0].acc).toBe 2

                    it "does nothing if rung closed", ->
                        dt_test_counter_down_rung_closed = dt_test_counter_down testAcc
                        dt_test_counter_down_rung_closed.rungOpen = false
                        expect(RSLParser.execute("CTD,C5:0,5", dt_test_counter_down_rung_closed).C5[0].acc).toBe testAcc

                    it "does nothing if branch false", ->
                        dt_test_counter_down_branch_false = dt_test_counter_down testAcc
                        dt_test_counter_down_branch_false.addBranch()
                        dt_test_counter_down_branch_false.branches[0].topLine = false
                        expect(RSLParser.execute("CTD,C5:0,5", dt_test_counter_down_branch_false).C5[0].acc).toBe testAcc


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
                    dt.addOutput 2,0, false
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

            dt_true_after_branch_rung = ->
                    dt = dt_true_after_rung()
                    dt.addOutput 2,1,false
                    return dt

            dt_false_after_rung = ->
                    dt = new DataTable false
                    dt.rungOpen = false
                    dt.rungs = [0]
                    dt.addOutput 2,0,false
                    return dt

            dt_false_after_branch_rung = ->
                    dt = dt_false_after_rung()
                    dt.addOutput 2,0,false
                    dt.addOutput 2,1
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
                dt.addOutput 2,0,false
                return dt

            dt_lab1_1_before = (truthArray)->
                dt = new DataTable
                for truth, bit in truthArray
                    dt.I[1][bit] = truth
                return dt

            dt_lab1_1_after = (truthArray)->
                dt = dt_lab1_1_before(truthArray)
                dt.addOutput 2,0, (truthArray[0] and truthArray[1]) or truthArray[2]
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

                rungText2 = "SOR,0 BST,1 XIC,I:1/0 OTE,O:2/0 NXB,1 XIO,I:1/0 OTE,O:2/1 BND,1 EOR,0"

                it "turns on outputs on true branches", ->
                    expect(RSLParser.runRung rungText2, dt_true()).toEqual dt_true_after_branch_rung()

                it "turns off outputs on false branches", ->
                    expect(RSLParser.runRung rungText2, dt_false()).toEqual dt_false_after_branch_rung()

            describe "series parallel rung", ->

                # This is Lab 1-01 in Petruzella
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
                    expect(RSLParser.runRung(rungText, dt_lab1_1_before([false, false, false])).O[2][0]).toBe false
                    expect(RSLParser.runRung(rungText, dt_lab1_1_before([false, true, false])).O[2][0]).toBe false
                    expect(RSLParser.runRung(rungText, dt_lab1_1_before([true, false, false])).O[2][0]).toBe false

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

            describe "lab 1-01a", ->

                lab1a = fs.readFileSync("./submissions/ch1_2/Examples/1-01a.rsl").toString()

                dt_lab1a_in = dt_in

                dt_lab1a_out = (truthArray)->
                    dt = dt_lab1a_in(truthArray)
                    dt.rungs = [0,1]
                    dt.activeRung = 1
                    dt.addOutput 2,0, (truthArray[0] and truthArray[1]) or truthArray[2]
                    dt.rungOpen = false
                    dt.programOpen = false
                    return dt

                it "runs correctly for all combinations of I:1/0, I:1/1, and I:1/2", ->
                    for i in [0...8]
                        truthArray = [(i >> 2 & 1) == 1, (i >> 1 & 1) == 1, (i & 1) == 1]
                        expect(RSLParser.runRoutine lab1a, dt_lab1a_in(truthArray)).toEqual dt_lab1a_out(truthArray)

            describe "lab 2-02", ->

                lab22 = fs.readFileSync("./submissions/ch1_2/Examples/2-02.rsl").toString()

                dt_lab22_in = dt_in

                dt_lab22_out = (truthArray)->
                    dt = dt_lab22_in truthArray
                    dt.rungs = [0...17]
                    dt.activeRung = 16
                    for no_contact in [0,2,3,5,6,7,10,11,14]
                        dt.addOutput 2,no_contact, truthArray[no_contact]
                    for nc_contact in [1,4,8,9,12,13,15]
                        dt.addOutput 2,nc_contact, not truthArray[nc_contact]
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