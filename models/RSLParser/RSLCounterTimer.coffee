(->
    class RSLCounterTimer
        constructor: ->
    
        @CounterTimer: class CounterTimer
            constructor: (@number, @preset)->
                @acc = 0
                @dn = @done()
                @en = false
            
            tickUp: ->
                @acc++
                @dn = @done()
            
            tickDown: ->
                @acc--
                @dn = @done()
            
            done: ->
                @acc >= @preset

            reset: ->
                @acc = 0
                @dn = @done()

        
        @Counter: class Counter extends @CounterTimer
            CU: ->
                @tickUp()
                @cu = true
        
            CD: ->
                @tickDown()
                @cd = true
        
        @Timer: class Timer extends @CounterTimer
            tick: ->
                unless @done()
                    @tickUp()
                    @tt = true
                else
                    @tt = false

        @counterTimerInstruction: (file, onAction, offAction)->
            (matchValues, dataTable)=>
                    [matchText, numberString, presetString] = matchValues
                    number = parseInt numberString, 10
                    preset = parseInt presetString, 10

                    dataTable[file] = dataTable[file] || {}
                    unless dataTable[file][number]? and (dataTable[file][number].constructor == Timer or dataTable[file][number].constructor == Counter)
                        if file == "T4"
                            dataTable["T4"][number] = new @Timer(number, preset)
                        else
                            dataTable["C5"][number] = new @Counter(number, preset)

                    activeBranch = dataTable.branches[dataTable.activeBranch - 1] if dataTable.activeBranch
                    if dataTable.rungOpen and ((not dataTable.activeBranch) or (activeBranch.onTopLine and activeBranch.topLine) or (not activeBranch.onTopLine and activeBranch.bottomLine))
                        onAction dataTable[file][number]
                    else
                        offAction dataTable[file][number]
                    return dataTable        

            
        @timerInstruction: (onTimerAction, offTimerAction)->
            @counterTimerInstruction "T4", onTimerAction, offTimerAction
            
        @TON: @timerInstruction (timer)=>
            timer.tick()
            timer.en = true
        , (timer)=>    
            timer.reset()
            timer.en = false

        @TOF: @timerInstruction (timer)=>
            timer.reset()
            timer.dn = true
            timer.en = true
            timer.tt = false
        , (timer)=>
            timer.tick()
            timer.dn = timer.dn and timer.acc < timer.preset
            timer.en = false
            timer.tt = not timer.dn

        @RTO: @timerInstruction (timer)=>
            timer.tick()
            timer.en = true
        , (timer)=>
            timer.en = false
            timer.tt = false

        @RES: (matchValues, dataTable)->
            activeBranch = dataTable.branches[dataTable.activeBranch - 1] if dataTable.activeBranch
            if dataTable.rungOpen and ((not dataTable.activeBranch) or (activeBranch.onTopLine and activeBranch.topLine) or (not activeBranch.onTopLine and activeBranch.bottomLine))
                [matchText, file, rankString] = matchValues
                rank = parseInt rankString, 10
                dataTable[file][rank].reset()
            return dataTable

        @counterInstruction: (onCounterAction, offCounterAction)->
            @counterTimerInstruction "C5", onCounterAction, offCounterAction
            
        @CTU: @counterInstruction (counter)=>
            counter.CU()
        , (counter)=>
            counter.cu = false

        @CTD: @counterInstruction (counter)=>
            counter.CD()
        , (counter)=>
            counter.cd = false

    module.exports = RSLCounterTimer
).call this        