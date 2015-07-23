hooks
connectWithView: aView
	(aView hasAttribute: self className)
		ifFalse: [ 
			aView when: TRMouseLeftClick do: [ :evt | aView announce: DCRTResizeCanceled new ].
			aView attributeAt: self className put: true ].

	aView when: DCRTResizeCanceled do: [ self removeHandles ]