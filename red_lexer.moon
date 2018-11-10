howl.util.lpeg_lexer ->
  word_special = S"?!.'+-*&|=_"

  ident = (alpha + word_special) * (alpha + digit + word_special)^0
  identifier = capture 'identifier', ident

  str_span = (start_pat, end_pat) ->
    start_pat * ((V'nestedb' + P 1) - end_pat)^0 * (end_pat + P(-1))

  comment = capture 'comment', P';' * scan_until(eol)
  todo_comment = capture 'warning', P';' * P' '^0 * P'TODO' * scan_until(eol)

  string = capture 'string', any {
    span('"', '"', P('^'))
    P { 'nestedb', nestedb: str_span('{','}') }
  }

  operator = capture 'operator', any {
    "%","*","**","+",
    "-","/","//","<",
    "<<","<=","<>","=",
    "==","=?",">",">=",
    ">>",">>>","?","??"
  }

  -- numbers
  hexadecimal_number = (R('AF') + R('09'))^2 * "h"
  float = P('-')^-1 * digit^1 * S'.,' * digit^0
  integer = P('0') + (P('-')^-1 * R('19') * R('09')^0)

  number = capture 'number', word {
    hexadecimal_number,
    (float + integer) * (S'eE' * P('-')^-1 * digit^1)^-1
  }

  -- protocols = word {
  --   "http", "ftp", "nntp", "mailto", "file", "finger", "whois", "daytime", "pop", "tcp", "dns"
  -- }

  special = capture 'special', any {
    integer * P('x') * integer -- pair
    P('#') * (span('"', '"') + ident)
    P('/') * (ident + digit^1) -- refinement
    digit^1 * ":" * digit^1 * (":" * digit^1 * ("." * digit^1)^-1)^-1 -- time
    P(':') * ident
    digit^1 * P('.') * digit^1 * P('.') * (digit^1 * P('.')^-1)^0 -- tuple
    P('<') * alpha * (P(1) - '>')^0 * P('>') -- tag
    P('%') * (span('"','"') + (P(1) - S(' \n'))^1) -- file
    -- protocols * P(':') * (P(1) - S(' \n'))^1 -- URL
  }

  any {
    special
    number
    string
    todo_comment
    comment
    capture 'variable', ident * P(':')
    identifier
    operator
  }
