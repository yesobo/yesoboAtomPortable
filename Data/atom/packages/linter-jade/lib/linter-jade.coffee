allLinters = []

allLinters.push(require('./linters/jade-lint'))     # jade-lint
allLinters.push(require('./linters/jadelint'))      # jadelint
allLinters.push(require('./linters/jade-compiler')) # default jade compiler

flattenArray = (ary, levels=1) ->
  [1..levels].forEach(-> ary = [].concat.apply([], ary))
  ary


LinterJade =
  grammarScopes : ['source.jade']
  scope         : 'file'
  lintOnFly     : true

  lint: (textEditor) ->
    linters = allLinters
      .filter((linter) => @config(linter[0]))
      .map((linter) -> linter[1])

    return new Promise (resolve, reject) ->
      Promise.all(linters.map((linterFn) -> linterFn(textEditor))).then(->
        # get a straight list of all errors
        errs = flattenArray(arguments, 2)

        # filter out duplicate errors since we're using two different linters.  First one wins
        errs = errs.filter((err, ix, errs) ->
          for i in [0...ix]
            if (errs[i].line == err.line) &&
               (errs[i].file == err.file) &&
               (errs[i].message = err.message)
                 return false

          return true
        )

        # convert to appropriate format
        errs = errs.map((err) ->
          type     : err.type || 'Error'
          text     : err.message + (if err.code then ' (' + err.code + ')' else '')
          filePath : err.file
          range    : if err.line then [
                [err.line - 1, err.column]
              , [err.line - 1, err.column]
            ] else []
        )

        resolve(errs)
      )

  config: (key) ->
    atom.config.get "linter-jade.#{key}"

module.exports = LinterJade
