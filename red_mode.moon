class RedMode
  new: =>
    @lexer = bundle_load 'red_lexer'
    @completers = { 'in_buffer' }

  comment_syntax: ';'

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

  code_blocks:
    multiline: {
    }
