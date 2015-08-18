private
connectWithView: aView
	(aView hasAttribute: self className)
		ifFalse: [ self setupView: aView ].

	aView
		when: TRMouseLeftClick
		do: [ :event | 
			event shape = element trachelShape & visible
				ifFalse: [ element shape removeHandlesFor: element ] ]