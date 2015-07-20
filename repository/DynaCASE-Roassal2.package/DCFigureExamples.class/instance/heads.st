accessing
heads
	| heads |
	heads := (RTStyledMultiLine methods collect: [ :m | m selector ]) select: [ :m | m endsWith: 'Head' ].
	offset := 0.
	heads
		do: [ :name | 
			self head: name offset: offset.
			offset := offset + 50 ]