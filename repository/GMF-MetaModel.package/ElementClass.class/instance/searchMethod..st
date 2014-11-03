search
searchMethod: xName 
	^ methods detect: [ :each | each name = xName ].