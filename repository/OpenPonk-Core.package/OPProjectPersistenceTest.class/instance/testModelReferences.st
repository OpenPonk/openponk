tests
testModelReferences
	| result models |
	models := OPPluginRegistry default plugins collect: [ :each | each modelClass new ].
	result := STON fromString: (String streamContents: [ :stream | stream << (persistence modelReferencesToJson: models) ]).
	self assert: result size equals: models size.
	self assert: (result collect: [ :each | each at: #plugin ]) asSet equals: (OPPluginRegistry default plugins collect: #className) asSet