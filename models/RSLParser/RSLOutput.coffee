class RSLOutput
    constructor: ->

    @bitwiseOutput: (set, latchAction)->
        (matchValues, dataTable)->
            [matchText, file, rank, bit] = matchValues
            dataTable[file] = dataTable[file] || {}
            dataTable[file][rank] = dataTable[file][rank] || {}
            dataTable[file][rank][bit] = set
            if typeof latchAction != "undefined"
                return dataTable = latchAction file, rank, bit, dataTable
            else
                return dataTable
    
    @OTE:  @bitwiseOutput true
    
    @OTL:  @bitwiseOutput true, (file, rank, bit, dataTable)->
        dataTable["latch"] = dataTable["latch"] || []
        if Find.find(dataTable["latch"], {file: file, rank: rank, bit: bit}) == -1
            dataTable["latch"].push {file: file, rank: rank, bit: bit}
        return dataTable
    
    @OTU: @bitwiseOutput false, (file, rank, bit, dataTable)->
        if dataTable["latch"]?
            removeIndex = Find.find dataTable["latch"], {file:file, rank:rank, bit:bit}

        unless removeIndex == -1
            dataTable["latch"].splice removeIndex, 1
        return dataTable