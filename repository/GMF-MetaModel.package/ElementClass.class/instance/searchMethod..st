search
searchMethod: aNameString 
	^ methods detect: [ :each | each name = aNameString ].