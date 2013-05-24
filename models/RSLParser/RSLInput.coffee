class RSLInput
    constructor: ->

    @bitwiseInput: (bitwiseFunction)->
        (matchValues, dataTable)->
            [matchText, file, rank, bit] = matchValues
            if bitwiseFunction(dataTable[file][rank][bit])
                return dataTable
            else
                return false
    
    @XIC: @bitwiseInput (bit)->
        return bit == true or bit == 1
    
    @XIO: @bitwiseInput (bit)->
        return bit == false or bit == 0