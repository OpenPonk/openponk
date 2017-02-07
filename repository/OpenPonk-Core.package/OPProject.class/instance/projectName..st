accessing
projectName: aString
	aString ifEmpty: [ ^ self error: 'Project name cannot be empty' ].
	projectName value: aString