tests
testModelReferencesFile
	| result models |
	models := DCPluginRegistry default plugins collect: [ :each | each modelClass new ].
	result := String
		streamContents: [ :stream | persistence writeModelReferences: models on: stream ].
	self
		deny:
			result
				=
					'<?xml version="1.0"?>
<models />'