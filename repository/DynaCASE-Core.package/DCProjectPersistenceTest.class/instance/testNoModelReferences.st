tests
testNoModelReferences
	| result |
	result := String
		streamContents: [ :stream | persistence writeModelReferences: #() on: stream ].
	self
		assert: result
		equals:
			'<?xml version="1.0"?>
<models />'