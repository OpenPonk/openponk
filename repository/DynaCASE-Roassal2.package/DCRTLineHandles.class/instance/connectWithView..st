private
connectWithView: aView
	(aView hasAttribute: self className)
		ifFalse: [ self setupView: aView ].
	aView canvas eventOverseer
		when: TRMouseLeftClick
		do:
			[ :event | 
			(event element = edge) not & visible
				ifTrue: [ self removeHandles ] ]