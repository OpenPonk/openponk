execute
execute
	| result |
	result := UIManager default request: 'Name' initialAnswer: object name.
	result ifNotNil: [ object name: result ]