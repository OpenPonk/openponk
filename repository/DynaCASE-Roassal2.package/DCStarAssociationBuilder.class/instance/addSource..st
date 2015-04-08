adding
addSource: aRTElement
	(self elements includes: aRTElement)
		ifTrue: [ ^ self ].
	aRTElement view add: (sourcesBuilder value: aRTElement value: center).
	sources add: aRTElement.
	self added: aRTElement