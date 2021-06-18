#include 'protheus.ch'
#include 'parmtype.ch'


User Function SPDFIS001
Local aTipo := ParamIXB[1]


AADD(aTipo, {"II|IN|MP","01"})
AADD(aTipo, {"BN|EM","02"})
AADD(aTipo, {"PP","03"})
AADD(aTipo, {"PA|PF","04"})
AADD(aTipo, {"SP","05"})
AADD(aTipo, {"PI","06"})
AADD(aTipo, {"MC","07"})
AADD(aTipo, {"AI|PV","08"})
AADD(aTipo, {"GE|MO|SV","09"})
AADD(aTipo, {"OI","10"})
AADD(aTipo, {"BU|FI|GG|GN|IA|IM|KT|ME|MM|SL|SM|SU","99"})

Return aTipo	


