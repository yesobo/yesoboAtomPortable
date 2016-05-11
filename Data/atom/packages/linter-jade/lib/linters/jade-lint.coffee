{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'

path       = require('path')

lintConfig = null
linter     = null
linterInit = false

module.exports = ['useJadeDashLint', (textEditor) ->
  if !linterInit
    linter     = new (require('jade-lint'))
    linterInit = true

  filePath   = textEditor.getPath()
  lintConfig = require('jade-lint/lib/config-file') # Don't like this, but there isn't a good
                                                    # interface at the moment
  linter.configure(lintConfig.load(undefined, path.dirname(filePath)))

  return new Promise (resolve, reject) ->
    resolve (allowUnsafeEval -> allowUnsafeNewFunction ->
      linter.checkString(textEditor.getText(), filePath)).map(
        (err) ->
          {
            file     : err.filename
            code     : err.code
            line     : err.line
            column   : err.column || 0
            message  : err.msg
            sameFile : true
          }
    )
]
