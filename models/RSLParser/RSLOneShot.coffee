(->
    "use strict"

    class RSLOneShot
        constructor: ->
    
        @OSR: (matchValues, dataTable)->
            [matchText, file, rankString, bitString] = matchValues
            rank = parseInt(rankString, 10)
            bit = parseInt(bitString, 10)

            dataTable[file] = dataTable[file] || {}
            dataTable[file][rank] = dataTable[file][rank] || {}
            dataTable[file][rank][bit] = dataTable[file][rank][bit] || false

            if dataTable.rungOpen and (dataTable.activeBranch == 0 or (dataTable.branches[dataTable.activeBranch - 1].onTopLine and dataTable.branches[dataTable.activeBranch - 1].topLine) or (not dataTable.branches[dataTable.activeBranch - 1].onTopLine and dataTable.branches[dataTable.activeBranch - 1].bottomLine))
                if dataTable[file][rank][bit] == true
                    if dataTable.activeBranch != 0
                        branch = dataTable.branches[dataTable.activeBranch - 1]
                        if branch.onTopLine?
                            branch.topLine = false
                        else
                            branch.bottomLine = false
                    else
                        dataTable.rungOpen = false
                else
                    dataTable[file][rank][bit] = true
            else
                dataTable[file][rank][bit] = false

            return dataTable

    module.exports = RSLOneShot
).call this