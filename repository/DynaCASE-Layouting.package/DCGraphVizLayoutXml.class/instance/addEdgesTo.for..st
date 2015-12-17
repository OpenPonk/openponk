hook
addEdgesTo: gv for: els
	directed
		withIndexDo:
			[ :each :i | 
			gv
				add: (els indexOf: each from) -> (els indexOf: each to)
				with:
					{(#dir -> #forward).
					(#id -> (#E , i asString))} ].
	undirected
		withIndexDo:
			[ :each :i | 
			gv
				add: (els indexOf: each from) -> (els indexOf: each to)
				with:
					{(#dir -> #none).
					(#id -> (#E , (directed size + i) asString))} ]