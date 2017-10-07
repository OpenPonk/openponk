adornments
hideAdornmentsOn: anElement
	(anElement hasAttribute: self className)
		ifFalse: [ ^ self ].
	(anElement attributeAt: self className) do: #remove.
	anElement removeAttributeAt: self className.
	anElement view signalUpdate