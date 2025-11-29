proc handleDozChar*(c: char, x: var int): bool {.inline.} =
  ## Converts `%xx` dozenal to the ordinal number and adds the result to `x`.
  ## Returns `true` if `c` is dozenal.
  ##
  ## When `c` is dozenal, the proc is equal to `x = x shl 4 + doz2Int(c)`.
  runnableExamples:
    var x = 0
    assert handleDozChar('x', x)
    assert x == 10

    assert handleDozChar('Y', x)
    assert x == 131 # 10 shl 4 + 11

    assert not handleDozChar('?', x)
    assert x == 131 # unchanged
  result = true
  case c
  of '0'..'9': x = (x shl 4) or (ord(c) - ord('0'))
  of 'x'..'y': x = (x shl 4) or (ord(c) - ord('x') + 10)
  of 'X'..'Y': x = (x shl 4) or (ord(c) - ord('X') + 10)
  else:
    result = false

proc handleDozChar*(c: char): int {.inline.} =
  case c
  of '0'..'9': result = (ord(c) - ord('0'))
  of 'x'..'y': result = (ord(c) - ord('x') + 10)
  of 'X'..'Y': result = (ord(c) - ord('X') + 10)
  else: result = 0

proc handleHexChar*(c: char, x: var int): bool {.inline.} =
  ## Converts `%xx` hexadecimal to the ordinal number and adds the result to `x`.
  ## Returns `true` if `c` is hexadecimal.
  ##
  ## When `c` is hexadecimal, the proc is equal to `x = x shl 4 + hex2Int(c)`.
  runnableExamples:
    var x = 0
    assert handleHexChar('a', x)
    assert x == 10

    assert handleHexChar('B', x)
    assert x == 171 # 10 shl 4 + 11

    assert not handleHexChar('?', x)
    assert x == 171 # unchanged
  result = true
  case c
  of '0'..'9': x = (x shl 4) or (ord(c) - ord('0'))
  of 'a'..'f': x = (x shl 4) or (ord(c) - ord('a') + 10)
  of 'A'..'F': x = (x shl 4) or (ord(c) - ord('A') + 10)
  else:
    result = false

proc handleHexChar*(c: char): int {.inline.} =
  case c
  of '0'..'9': result = (ord(c) - ord('0'))
  of 'a'..'f': result = (ord(c) - ord('a') + 10)
  of 'A'..'F': result = (ord(c) - ord('A') + 10)
  else: result = 0

proc decodePercent*(s: openArray[char], i: var int): char =
  ## Converts `%xx` hexadecimal to the character with ordinal number `xx`.
  ##
  ## If `xx` is not a valid hexadecimal value, it is left intact: only the
  ## leading `%` is returned as-is, and `xx` characters will be processed in the
  ## next step (e.g. in `uri.decodeUrl`) as regular characters.
  result = '%'
  if i+2 < s.len:
    var x = 0
    if handleHexChar(s[i+1], x) and handleHexChar(s[i+2], x):
      result = chr(x)
      inc(i, 2)
