###
Requires https://github.com/google/yapf
###

"use strict"
Beautifier = require('./beautifier')

module.exports = class Yapf extends Beautifier

  name: "yapf"

  options: {
    Python: false
  }

  beautify: (text, language, options) ->
    @run("yapf", [
      "-i"
      ["--style=pep8"]
      tempFile = @tempFile("input", text)
      ], help: {
        link: "https://github.com/google/yapf"
      }, ignoreReturnCode: true)
      .then(=>
        if options.sort_imports
          @run("isort",
            [tempFile],
            help: {
              link: "https://github.com/timothycrosley/isort"
          })
          .then(=>
            @readFile(tempFile)
          )
        else
          @readFile(tempFile)
      )
