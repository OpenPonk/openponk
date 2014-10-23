tree
renameCommand: modelObject
	| result |
	result := UIManager default request: 'Name' initialAnswer: modelObject name.
	result
		ifNotNil: [ 
			modelObject name: result.
			self setDirty ]