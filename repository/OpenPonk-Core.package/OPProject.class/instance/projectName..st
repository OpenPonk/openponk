accessing
projectName: aString
	self
		deprecated: 'Use name: instead'
		on: '22 July 2017'
		in: 'Pharo-6.0-60508-'
		transformWith: '`@receiver projectName: `@arg' -> '`@receiver name: `@arg'.
	^ self name: aString