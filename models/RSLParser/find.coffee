(->

    "use strict"

    class Find
        constructor: ->
    
        @match: (testObject, findObject)->
            isMatch = true
            for property of testObject
                if typeof testObject[property] == "object"
                    isMatch = typeof findObject[property] == "object" and @match testObject[property], findObject[property]
                else
                    unless testObject[property] == findObject[property]
                        isMatch = false
                        break
            return isMatch

        @find: (array, findObject)->
            for element, index in array
                if @match element, findObject
                    return index
            return -1
    
    module.exports = Find
).call this