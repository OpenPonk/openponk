accessing - spec
doesNotUnderstand: aMessage
	^ (diagramOptions at: aMessage selector ifAbsent: [ super doesNotUnderstand: aMessage ])
		second