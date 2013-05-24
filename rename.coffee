( ->
    "use strict"
    prompt = require "prompt"
    rename = require("./scripts.coffee").rename

    prompt.start

    prompt.get ["path", "re", "replacement"], (err,result)->
        if err
            onErr err

        rename result.path, new RegExp(result.re), result.replacement

    onErr = (err)->
        console.log err
        1

).call this