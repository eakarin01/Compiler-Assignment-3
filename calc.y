1+(2*(3+-4)) \ 2h

PUSH $acc
PUSH $acc
SHOW $top

SHOW $size

POP $rA
POP $rB
$rA^$rB+$acc

LOAD $acc $rZ
SHOW $rZ

POP $rY

SHOW $rY

LOAD $rB $size

LOAD $top $rX




