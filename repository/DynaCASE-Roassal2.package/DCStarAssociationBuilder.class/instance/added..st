as yet unclassified
added: aRTElement
	aRTElement
		addCallback: transCallback;
		addCallback: extentCallback.
	center view
		ifNil: [ 
			aRTElement view
				add: center;
				add: centerDragBox ].
	self update