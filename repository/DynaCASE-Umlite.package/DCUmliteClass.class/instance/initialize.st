initialization
initialize
	super initialize.
	self name: 'ClassName'.
	stereotype := NewValueHolder value: ''.
	attributesHolder := OrderedCollection new asValueHolder.
	methodsHolder := OrderedCollection new asValueHolder.