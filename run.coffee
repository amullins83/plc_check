( ->
    "use strict"

    prompt = require "prompt"
    scripts = require "./scripts.coffee"

    prompt.start

    prompt.get ["folder", "re"], (err, result)->
        if err
            onErr err

        scripts.summarize result.folder, new RegExp(result.re, "g")
        scripts.compare result.folder
        console.log "Deposited Diffs"

    onErr = (error)->
        console.log  error
        1
    
).call this