(->
    class RSLCounterTimer
        constructor: ->
    
        @CounterTimer: class CounterTimer
            constructor: (@number, @preset)->
                @acc = 0
                @en = true
                @dn = @done()
            
            tickUp: ->
                @acc++
                @dn = @done()
            
            tickDown: ->
                @acc--
                @dn = @done()
            
            done: ->
                @acc >= @preset
        
        @Counter: class Counter extends @CounterTimer
            CU: ->
                @tickUp()
                @cu = true
        
            CD: ->
                @tickDown()
                @cu = true
        
            OV: ->
        
            UV: ->
            
        
        @Timer: class Timer extends @CounterTimer
            tick: ->
                unless @done()
                    @tickUp()
                    @tt = true
                else
                    @tt = false
            
        @counterTimerInstruction: (file, action)->
            (matchValues, dataTable)->
                [number, preset] = matchValues
                dataTable[file] = dataTable[file] || {}
                dataTable[file][number] = dataTable[file][number] || new @CounterTimer(number, preset)
                unit = dataTable[file][number]
                dataTable = action(unit)
            
        @timerInstruction: (timerAction)->
            @counterTimerInstruction "T4", timerAction
            
        @TON: @timerInstruction (timer)->
            
            
        @TOF: @timerInstruction (timer)->
            
        @RTO: @timerInstruction (timer)->
        
        @RES: (matchValues, dataTable)->
            [matchText, file, rank] = matchValues
            dataTable[file][rank].acc = 0
            
        @counterInstruction: (counterAction)->
            @counterTimerInstruction "C5", counterAction
            
        @CTU: @counterInstruction (counter)->
            
        @CTD: @counterInstruction (counter)->

    module.exports = RSLCounterTimer
).call this        