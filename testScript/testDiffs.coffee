fs = require "fs"
diffs = require("../scripts.coffee").diffs
patrizi = fs.readFileSync("./submissions/ch6/Patrizi/labs.txt").toString()
example = fs.readFileSync("./submissions/ch6/Examples/labs.txt").toString()

fs.writeFileSync "./submissions/ch6/Patrizi/diffs.txt", diffs(patrizi, example)