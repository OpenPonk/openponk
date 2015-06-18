tests
testStereotype
	figure renderIn: view.
	figure stereotype: 'string over 80 pixels wide'.

	self assert: figure figures size equals: 4.
	self assert: figure background height equals: self stereotype height + self name height.
	self assert: figure background width equals: self stereotype width.
	self assert: self stereotype model equals: 'string over 80 pixels wide'