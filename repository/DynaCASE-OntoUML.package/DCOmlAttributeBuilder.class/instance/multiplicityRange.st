grammar
multiplicityRange
	^ super multiplicityRange
		==> [ :nodes | 
			nodes first isNil | (nodes first = nodes second) | (nodes first = 0 & (nodes second = $*))
				ifTrue: [ nodes second asString ]
				ifFalse: [ nodes first asString , '..' , nodes second asString ] ]