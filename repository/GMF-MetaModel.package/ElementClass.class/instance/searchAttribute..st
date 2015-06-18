search
searchAttribute: aNameString 
	^ attributes detect: [ :each | each name = aNameString ].