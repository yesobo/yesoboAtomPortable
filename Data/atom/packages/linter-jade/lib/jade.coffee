LinterJadeProvider = require './linter-jade'

module.exports =
  config:
    useJadeCompiler:
      type        : 'boolean'
      default     : true
      description : "Use the default Jade compiler as a linter"
      order       : 1
    useJadeDashLint:
      type        : 'boolean'
      default     : true
      description : "Use jade-lint linter (.jade-lintrc files)"
      order       : 2
    useJadeLint:
      type        : 'boolean'
      default     : true
      description : "Use jadelint linter (.jadelintrc files)"
      order       : 3

  provideLinter: -> LinterJadeProvider
