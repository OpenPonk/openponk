hook
addNodesTo: gv for: els
	els
		withIndexDo:
			[ :each :i | 
			gv
				add: i asString
				with:
					{(#id -> (#N , i asString)).
					(#width -> (self pixelToInch: each width)).
					(#height -> (self pixelToInch: each height))} ]