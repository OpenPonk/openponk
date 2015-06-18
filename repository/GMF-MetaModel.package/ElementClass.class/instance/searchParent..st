search
searchParent: aNameString 
	^ self generalizations detect: [ :each | each parent name = aNameString ].