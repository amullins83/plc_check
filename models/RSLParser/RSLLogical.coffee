(->
    "use strict"

    class RSLLogical
        constructor: ->
    
        @Logical: (bitwiseFunction)->
            (matchValues, dataTable)->
                if dataTable.activeBranch > 0
                    activeBranch = dataTable.branches[dataTable.activeBranch - 1]
                    
                if dataTable.rungOpen and ((not dataTable.activeBranch) or (activeBranch.onTopLine and activeBranch.topLine) or (not activeBranch.onTopLine and activeBranch.bottomLine))    

                    if matchValues.length == 7
                        [matchText, sourceAfile, sourceArankString, sourceBfile, sourceBrankString, destFile, destRankString] = matchValues
                    else
                        [matchText, sourceAfile, sourceArankString, destFile, destRankString] = matchValues

                    sourceArank = parseInt sourceArankString, 10
                    if sourceBrankString?
                        sourceBrank = parseInt sourceBrankString, 10
                    destRank    = parseInt destRankString,    10

                    dataTable[destFile] = dataTable[destFile] || {}
                    dataTable[destFile][destRank] = dataTable[destFile][destRank] || {}

                    for i in [0...16]
                        dataTable[sourceAfile][sourceArank][i] = dataTable[sourceAfile][sourceArank][i] || false
                        if sourceBfile?
                            dataTable[sourceBfile][sourceBrank][i] = dataTable[sourceBfile][sourceBrank][i] || false
                            dataTable[destFile][destRank][i] = bitwiseFunction dataTable[sourceAfile][sourceArank][i], dataTable[sourceBfile][sourceBrank][i]
                        else
                            dataTable[destFile][destRank][i] = bitwiseFunction dataTable[sourceAfile][sourceArank][i]

                return dataTable
        
        @AND: @Logical (a,b)->
            a and b
        
        @OR: @Logical (a,b)->
            a or b
        
        @XOR: @Logical (a,b)->
            (a and not b) or (b and not a)
        
        @NOT: @Logical (a,b)->
            not a

    module.exports = RSLLogical
    
).call this