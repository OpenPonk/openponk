hooks
connectWithView: aView
	(aView hasAttribute: self className)
		ifFalse: [ self setupView: aView ].

	aView
		when: TRMouseLeftClick
		do: [ :event | 
			event shape = edge trachelShape
				ifFalse: [ self removeHandles ] ]