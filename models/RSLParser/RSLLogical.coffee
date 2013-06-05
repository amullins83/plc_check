(->
    "use strict"

    class RSLLogical
        constructor: ->
    
        @Logical: (bitwiseFunction)->
            (matchValues, dataTable)->
                [matchText, sourceAfile, sourceArank, sourceBfile, sourceBrank, destFile, destRank] = matchValues
                dataTable[destFile] = dataTable[destFile] || {}
                dataTable[destFile][destRank] = dataTable[destFile][destRank] || {}
                for i in [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
                    dataTable[sourceAfile][sourceArank][i] = dataTable[sourceAfile][sourceArank][i] || 0
                    dataTable[sourceBfile][sourceBrank][i] = dataTable[sourceBfile][sourceBrank][i] || 0
                    dataTable[destFile][destRank][i] = bitwiseFunction dataTable[sourceAfile][sourceArank][i], dataTable[sourceBfile][sourceBrank][i]
                return dataTable
        
        @AND: @Logical (a,b)->
            a and b
        
        @OR: @Logical (a,b)->
            a or b
        
        @XOR: @Logical (a,b)->
            a ^ b
        
        @NOT: @Logical (a,b)->
            not a

    module.exports = RSLLogical
    
).call this