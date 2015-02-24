private
added: aRTElement
	aRTElement
		addCallback: transCallback;
		addCallback: extentCallback.
	self view ifNil: [ self addToView: aRTElement view ].
	self update