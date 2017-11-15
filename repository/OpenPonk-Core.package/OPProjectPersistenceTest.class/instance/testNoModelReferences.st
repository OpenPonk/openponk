tests
testNoModelReferences
	| result |
	result := String
		streamContents: [ :stream | stream << (persistence modelReferencesToJson: #()) ].
	self assert: (STON fromString: result) equals: #()