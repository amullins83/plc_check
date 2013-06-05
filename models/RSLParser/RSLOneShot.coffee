(->
    "use strict"

    class RSLOneShot
        constructor: ->
    
        @OSR: (matchValues, dataTable)->
            [matchText, file, rank, bit] = matchValues
            if dataTable[file][rank][bit]
                return false
            else
                dataTable[file][rank][bit] = true
                dataTable["oneShots"] = dataTable["oneShots"] || []
                findObject = {file:file, rank:rank, bit:bit}
                foundOneShots = dataTable["oneShots"].find findObject
                if foundOneShots.length == 0
                    dataTable["oneShots"].push {file: file, rank: rank, bit: bit, active: true}
                else
                    dataTable["oneShots"].update findObject, {file: file, rank: rank, bit: bit, active:true}
                return dataTable

    module.exports = RSLOneShot
).call this