class Find
    constructor: ->

    @find: (array, findObject)->
        isMatch = false
        for element, index in array
            isMatch = true
            for property of element
                unless element[property] == findObject[property]
                    isMatch = false
                    break
            if isMatch
                return index
        return -1

module.exports = Find