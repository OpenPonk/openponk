accessing
filterOfType: aFilterClass
	^ self filters
		detect: [ :each | each name = aFilterClass filterName ]
		ifNone: [ self filters add: aFilterClass new ]