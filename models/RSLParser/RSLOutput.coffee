class RSLOutput
    constructor: ->

    @bitwiseOutput: (set, latchAction = -> )->
        (matchValues, dataTable)->
            [matchText, file, rank, bit] = matchValues
            dataTable[file] = dataTable[file] || {}
            dataTable[file][rank] = dataTable[file][rank] || {}
            dataTable[file][rank][bit] = set
            dataTable = latchAction dataTable
    
    @OTE:  @bitwiseOutput true
    
    @OTL:  @bitwiseOutput true, (dataTable)->
        dataTable["latch"] = dataTable["latch"] || []
        if dataTable["latch"].indexOf {file: file, rank: rank, bit: bit} == -1
            dataTable["latch"].push {file: file, rank: rank, bit: bit}
        return dataTable
    
    @OTU: @bitwiseOutput false, (dataTable)->
        if dataTable["latch"]?
            removeIndex = dataTable["latch"].indexOf {file: file, rank: rank, bit: bit}
        unless removeIndex == -1
            dataTable.splice removeIndex, 1
        return dataTable