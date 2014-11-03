search
searchAttribute: xName 
	^ attributes detect: [ :each | each name = xName ].