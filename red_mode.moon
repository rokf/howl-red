class RedMode
  new: =>
    @api = bundle_load 'api'
    @lexer = bundle_load 'red_lexer'
    @completers = { 'in_buffer', 'api' }

  comment_syntax: ';'
  word_pattern: '[%w%?%-%!_~%*+/<>=]+'

  auto_pairs: {
    '(': ')'
    '[': ']'
    '{': '}'
    '"': '"'
  }

  indentation: {
    more_after: {
      r'[({=\\[]\\s*(;.*|)$'
    }

    less_for: {
      '^%s*]'
      '^%s*}'
      '^%s*)'
    }
  }
