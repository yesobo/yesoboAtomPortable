{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'

jade       = null
linterInit = false

module.exports = ['useJadeCompiler', (textEditor) ->
  if !linterInit
    jade       = allowUnsafeNewFunction -> require('jade')
    linterInit = true

  thisFile = textEditor.getPath()

  return new Promise (resolve, reject) ->
    try
      allowUnsafeEval -> allowUnsafeNewFunction -> jade.compile(textEditor.getText(), {
        filename : thisFile,
        doctype  : 'html'
      })
      resolve([])
    catch err
      errText  = err.message.trim()
      errLines = errText.split('\n') || []

      # file.jade:3
      fileLine = /(\S*\.jade):(\d+)/.exec(errLines[0]) || []
      fileName = fileLine[1]
      lineNum  = fileLine[2]
      message  = errLines[errLines.length - 1]

      # err on line 3
      if !fileLine.length
        fileLine = /(.*?) on line (\d+)$/.exec(errLines[0]) || []
        fileName = thisFile
        lineNum  = fileLine[2]
        message  = fileLine[1]

      # ErrMessage (line:col)
      # js-compiler errors with non-relevant line/column info
      if !fileLine.length
        fileLine = /(.*?) \(\d+:\d+\)/.exec(errLines[0]) || []
        lineNum  = 0
        message  = fileLine[1]

      sameFile = thisFile == fileName

      resolve([{
        file     : fileName
        line     : +lineNum
        column   : 0
        message  : message
        sameFile : sameFile
      }])
]
