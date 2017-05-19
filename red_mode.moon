class RedMode
  new: =>
    @api = bundle_load 'api'
    @lexer = bundle_load 'red_lexer'
    @completers = { 'in_buffer', 'api' }

  -- resolve_type: (context) =>
  --   pfx = context.prefix
  --   parts = [p for p in pfx\gmatch '[%w%-%?%!]+']
  --   print(parts[#parts])
  --   nil, { parts[#parts] }

  comment_syntax: ';'

  default_config:
    word_pattern: '[%w%?%-%!]+'

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
