accessing
lines
	| lines |
	lines := (DCRTMultiLine methods collect: [ :m | m selector ]) select: [ :m | m endsWith: 'Line' ].
	offset := 0.
	lines
		do: [ :name | 
			self line: name offset: offset.
			offset := offset + 50 ]