(->

    "use strict"

    class RSLInput
        constructor: ->
    
        @bitwiseInput: (bitwiseFunction)->
            (matchValues, dataTable)->
                [matchText, file, rankString, bitString] = matchValues
                rank = parseInt rankString, 10
                
                if isNaN bitString
                    bit = bitString.toLowerCase()
                else
                    bit = parseInt bitString, 10

                dataTable[file] = dataTable[file] || {}
                dataTable[file][rank] = dataTable[file][rank] || {}
                dataTable[file][rank][bit] = dataTable[file][rank][bit] || false
                if bitwiseFunction(dataTable[file][rank][bit])
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
        
        @XIC: @bitwiseInput (bit)->
            return bit == true or bit == 1
        
        @XIO: @bitwiseInput (bit)->
            return bit == false or bit == 0

    module.exports = RSLInput
).call this