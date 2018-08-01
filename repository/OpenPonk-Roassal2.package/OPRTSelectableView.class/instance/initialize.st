initialization
initialize
	super initialize.
	self when: RTSelectionChange do: [ :e | view attributeAt: self class put: e group ].
	self when: RTSelectionEnd do: [ :e | view attributeAt: self class put: e group ]