adding
addTarget: aRTElement
	(self elements includes: aRTElement)
		ifFalse: [ 
			aRTElement view add: (targetsBuilder value: center value: aRTElement).
			targets add: aRTElement.
			self added: aRTElement ]