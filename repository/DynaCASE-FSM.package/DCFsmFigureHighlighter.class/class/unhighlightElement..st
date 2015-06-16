api
unhighlightElement: anElement
	(anElement hasAttribute: self name)
		ifFalse: [ ^ self ].
	anElement shape borderColor: (anElement attributeAt: self name).
	anElement removeAttributeAt: self name.
	anElement update.
	anElement signalUpdate