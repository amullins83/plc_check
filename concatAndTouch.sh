#!/bin/bash
coffeescript-concat -I models/RSLParser -o models/RSLParserComplete.coffee coffee/RSLParser.coffee
touch test/testModels/RSLParserSpec.coffee