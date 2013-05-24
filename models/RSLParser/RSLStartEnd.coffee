class RSLStartEnd
    constructor: ->

    @SOR: (matchValues, dataTable)->
        [matchText, rungNumber] = matchValues
        dataTable.rungs = dataTable.rungs || []
        dataTable.rungs.push rungNumber
        dataTable.activeRung = rungNumber
        dataTable.rungOpen = true
        dataTable.programOpen = true
        return dataTable
    
    @ending: (lastAction, errorMessage = "EOR does not match SOR")->
        (matchValues, dataTable)->
            [matchText, rungNumber] = matchValues
            if rungNumber == dataTable.activeRung
                dataTable.rungOpen = false
                if typeof lastAction  == "Function"
                    lastAction
                return dataTable
            else
                throw "EOR does not match SOR"
    
    @EOR: @ending
    
    @END: @ending ->
        dataTable.programOpen = false
    , "END does not match SOR"
