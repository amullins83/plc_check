(->
    "use strict"

    class RSLComparisons
        constructor: ->

        @compare: (compareFunction)->
            (matchValues, dataTable)->
                [matchText, fileA, rankStringA, fileB, rankStringB] = matchValues
                
                rankA = parseInt rankStringA, 10
                rankB = parseInt rankStringB, 10
                
                dataTable[fileA] = dataTable[fileA] || {}
                dataTable[fileA][rankA] = dataTable[fileA][rankA] || {}
                
                dataTable[fileB] = dataTable[fileB] || {}
                dataTable[fileB][rankB] = dataTable[fileB][rankB] || {}
                
                if compareFunction(dataTable[fileA][rankA], dataTable[fileB][rankB])
                    return dataTable
                else
                    if dataTable.activeBranch > 0
                        if dataTable.branches[dataTable.activeBranch - 1].onTopLine
                            dataTable.branches[dataTable.activeBranch - 1].topLine = false
                        else
                            dataTable.branches[dataTable.activeBranch - 1].bottomLine = false
                    else
                        dataTable.rungOpen = false
                    return dataTable

        @LES: @compare (a,b)->
            for bit in [15...-1]
                if a[bit] < b[bit]
                    return true
                if a[bit] > b[bit]
                    return false
            return false

        @GRT: @compare (a,b)->
            for bit in [15...-1]
                if a[bit] > b[bit]
                    return true
                if a[bit] < b[bit]
                    return false
            return false

        @EQU: @compare (a,b)->
            for bit in [15...-1]
                if a[bit] is not b[bit]
                    return false
            return true

        @NEQ: @compare (a,b)->
            for bit in [15...-1]
                if a[bit] is not b[bit]
                    return true
            return false

        @LEQ: @compare (a,b)->
            for bit in [15...-1]
                if a[bit] < b[bit]
                    return true
                if a[bit] > b[bit]
                    return false
            return true

        @GEQ: @compare (a,b)->
            for bit in [15...-1]
                if a[bit] > b[bit]
                    return true
                if a[bit] < b[bit]
                    return false
            return true

        @LIM: (matchValues, dataTable)->
                [matchText, fileA, rankStringA, fileB, rankStringB, fileC, rankStringC] = matchValues
                
                rankA = parseInt rankStringA, 10
                rankB = parseInt rankStringB, 10
                rankC = parseInt rankStringC, 10
                
                dataTable[fileA] = dataTable[fileA] || {}
                dataTable[fileA][rankA] = dataTable[fileA][rankA] || {}
                
                dataTable[fileB] = dataTable[fileB] || {}
                dataTable[fileB][rankB] = dataTable[fileB][rankB] || {}

                dataTable[fileC] = dataTable[fileC] || {}
                dataTable[fileC][rankC] = dataTable[fileC][rankC] || {}
                

                input = RSLComparisons.numericValue dataTable[fileB][rankB]

                low = RSLComparisons.numericValue dataTable[fileA][rankA]

                high = RSLComparisons.numericValue dataTable[fileC][rankC]

                if (low <= high and input <= high and input >= low) or (low > high and (input > low or input < high))
                    return dataTable
                else
                    if dataTable.activeBranch > 0
                        if dataTable.branches[dataTable.activeBranch - 1].onTopLine
                            dataTable.branches[dataTable.activeBranch - 1].topLine = false
                        else
                            dataTable.branches[dataTable.activeBranch - 1].bottomLine = false
                    else
                        dataTable.rungOpen = false
                    return dataTable

        @numericValue: (arrayObject)->
            output = 0
            for bit in [0...16]
                if arrayObject[bit]
                    output += Math.pow 2, bit
            return output

    module.exports = RSLComparisons
).call this