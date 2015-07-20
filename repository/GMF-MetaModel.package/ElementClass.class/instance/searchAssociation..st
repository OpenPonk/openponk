search
searchAssociation: aNameString 
	^ associations detect: [ :each | each name = aNameString ].