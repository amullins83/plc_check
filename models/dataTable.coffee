(->
    "use strict"

    RSLBranch = require "./RSLParser/RSLBranch.coffee"
    RSLStartEnd = require "./RSLParser/RSLStartEnd.coffee"

    class DataTable
        constructor: (inputTrue)->
            @I = 
                "1":
                    "0":false
            @I[1][0] = true if inputTrue
            @rungs = []
            @activeRung = 0
            @rungOpen = true
            @programOpen = true
            @activeBranch = 0

        addBranch: ->
            @branches = @branches || []
            @activeBranch = @branches.length + 1
            @branches.push new RSLBranch.Branch @activeBranch 


        addLatch: (file, rank, bit)->
            @latch = @latch || []
            @latch.push {file:file, rank:rank, bit:bit}

        addOutput: (rank, bit, value)->
            @O = @O || {}
            @O[rank] = @O[rank] || {}
            if typeof value is "undefined" or value
                @O[rank][bit] = true
            else
                @O[rank][bit] = false

    module.exports = DataTable
).call this