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
            @rungs = [0]
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

        addOutput: (rank, bit)->
            @O = @O || {}
            @O[rank] = @O[rank] || {}
            @O[rank][bit] = true

    module.exports = DataTable
).call this