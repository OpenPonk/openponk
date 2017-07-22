accessing
projectName
	self 
		deprecated: 'Use name instead'
		on: 	'22 July 2017' 
		in: 'Pharo-6.0-60508-'
		transformWith: '`@receiver projectName' 
						-> '`@receiver name'.
	^ self name