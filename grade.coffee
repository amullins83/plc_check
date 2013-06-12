( ->
    "use strict"
    scripts = require("./scripts.coffee")
    scripts.autoRenameAll()
    scripts.gradeAll()
).call this