execute
execute
	| result |
	result := UIManager default request: 'Name' initialAnswer: model name.
	result ifNil: [ ^ self ].
	model name: result.
	model announcer announce: OPElementRenamed new