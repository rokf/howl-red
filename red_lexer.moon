howl.util.lpeg_lexer ->
  c = capture

  -- words = word {
  --   "zero?","yes","xor~","xor","write","words-of","word?","word!","within?","while","what-dir","what","wait","view","vector?","vector!","values-of","value?","url?","url!","uppercase","unview","until","unset?","unset!","unset","unless","unique","union","typeset?","typeset!","type?","tuple?","tuple!","try","true","trim","to-time","to-tag","to-red-file","to-local-file","to-image","to-hex","to-email","to","time?","time!","throw","third","tangent","tan","take","tail?","tail","tag?","tag!","switch","swap","suffix?","subtract","string?","string!","strict-equal?","stats","square-root","split-path","split","spec-of","space","source","sort","skip","sine","sin","shift-right","shift-logical","shift-left","shift","set-word?","set-word!","set-quiet","set-path?","set-path!","set-env","set-current-dir","set","series?","series!","select","second","save","same?","routine?","routine!","routine","round","reverse","return","request-font","request-file","request-dir","replace","repend","repeat","remove-each","remove","remainder","reflect","refinement?","refinement!","reduce","red-complete-path","red-complete-file","read","react?","random","quote","quit-return","quit","q","pwd","put","probe","print","prin","power","positive?","poke","point!","point","pick","pi","percent?","percent!","path?","path!","parse-trace","parse","paren?","paren!","pair?","pair!","pad","or~","or","op?","op!","on","off","odd?","object?","object!","object","number!","now","not-equal?","not","normalize-dir","none?","none!","none","no","next","new-line?","new-line","negative?","negate","native?","native!","NaN?","NaN","multiply","move","mold","modulo","modify","min","max","math","map?","map!","make-dir","make","ls","lowercase","loop","logic?","logic!","log-e","log-2","log-10","load","ll","lit-word?","lit-word!","lit-path?","lit-path!","list-env","list-dir","lesser?","lesser-or-equal?","length?","layout","last-lf?","last","keys-of","issue?","issue!","is","intersect","integer?","integer!","insert","input","index?","in","image?","image!","if","help","head?","head","hash?","hash!","has","halt","greater?","greater-or-equal?","get-word?","get-word!","get-path?","get-path!","get-env","get-current-dir","get","function?","function!","function","func","fourth","form","forever","foreach","forall","float?","float!","flip-exe-flag","first","find","file?","file!","fifth","false","extract-boot-args","extract","extend","exp","exit","exists?","exclude","event!","even?","eval-set-path","error?","error!","equal?","enbase","empty?","email?","email!","either","dump-reactions","does","do-safe","do-file","do-events","do-actor","do","divide","dirize","dir?","dir","difference","dehex","default-input-completer","debase","datatype?","datatype!","create-dir","cosine","cos","copy","continue","context?","context","construct","compose","complement?","complement","comment","collect","clear-reactions","clear","clean-path","checksum","charset","char?","char!","change-dir","change","cd","cause-error","catch","case","call","browse","break","body-of","block?","block!","bitset?","bitset!","bind","binary?","binary!","back","attempt","atan2","atan","at","ask","asin","as-rgba","as-pair","as-ipv4","as-color","arctangent2","arctangent","arcsine","arccosine","append","any-word?","any-word","any-string?","any-string!","any-path?","any-path!","any-object?","any-object!","any-list?","any-list!","any-function?","any-block?","any","and~","and","alter","also","all","add","action?","action!","acos","absolute","about","a-an",
  -- }


  word_special = S"?!.'+-*&|=_"

  ident = (alpha + word_special) * (alpha + digit + word_special)^0
  -- keyword = c 'keyword', words - #(words * ident)
  identifier = c 'identifier', ident

  str_span = (start_pat, end_pat) ->
    start_pat * ((V'nestedb' + P 1) - end_pat)^0 * (end_pat + P(-1))

  comment = c 'comment', P';' * scan_until(eol)
  todo_comment = c 'warning', P';' * P' '^0 * P'TODO' * scan_until(eol)

  string = c 'string', any {
    span('"', '"', any { P('^') })
    P { 'nestedb', nestedb: str_span('{','}') }
  }

  operator = c 'operator', any {
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

  number = c 'number', word {
    hexadecimal_number,
    (float + integer) * (S'eE' * P('-')^-1 * digit^1)^-1
  }

  -- protocols = word {
  --   "http", "ftp", "nntp", "mailto", "file", "finger", "whois", "daytime", "pop", "tcp", "dns"
  -- }

  special = c 'special', any {
    integer * P('x') * integer -- pair
    P('#') * ident
    P('#') * span('"', '"') -- character
    P('/') * (ident + digit^1) -- refinement
    digit^1 * ":" * digit^1 * (":" * digit^1 * ("." * digit^1)^-1)^-1 -- time
    P(':') * ident
    digit^1 * P('.') * digit^1 * P('.') * (digit^1 * P('.')^-1)^0 -- tuple
    P('<') * alpha * (P(1) - '>')^0 * P('>') -- tag
    P('%') * (span('"','"') + (P(1) - S(' '))^1) -- file
    -- P("'") * ident -- "quoted word"
    -- protocols * P(':') * (P(1) - S(' \n'))^1 -- URL
  }

  -- ws = c 'whitespace', blank^0

  vdef = c 'variable', ident * P(':')

  any {
    special
    number
    string
    todo_comment
    comment
    vdef
    -- keyword
    identifier
    operator
  }
