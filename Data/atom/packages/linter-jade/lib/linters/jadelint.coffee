{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'

path       = require('path')

Linter     = null
linterInit = false

module.exports = ['useJadeLint', (textEditor) ->
  if !linterInit
    Linter     = require('jadelint/target/Linter')
    linterInit = true

  filePath = textEditor.getPath()
  src      = textEditor.getText()

  return new Promise (resolve, reject) ->
    resolve (allowUnsafeEval -> allowUnsafeNewFunction ->
      linter = new Linter(filePath, src)
      linter.lint().filter((err) -> err.level != 'ignore').map(
        (err) ->
          {
            file     : err.filename
            type     : {warning:'Warning', error:'Error'}[err.level] || err.level
            code     : err.code
            line     : err.line
            column   : err.column || 0
            message  : err.msg || err.name
            sameFile : true
          }
      )
    )
]
