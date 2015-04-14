adding
addSource: aRTElement
	(self elements includes: aRTElement)
		ifFalse: [ 
			aRTElement view add: (sourcesBuilder value: aRTElement value: center).
			sources add: aRTElement.
			self added: aRTElement ]