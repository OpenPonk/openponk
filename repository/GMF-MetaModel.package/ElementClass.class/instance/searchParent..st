search
searchParent: xName 
	^ parents detect: [ :each | each parentClass name = xName ].