as yet unclassified
testStereotype2
	figure renderIn: view.

	self deny: figure hasStereotype.
	figure stereotype: 'stereo'.
	self assert: figure hasStereotype.
	self assert: self stereotype view isNotNil.
	figure stereotype: ''.
	self deny: figure hasStereotype.

	self testEmpty