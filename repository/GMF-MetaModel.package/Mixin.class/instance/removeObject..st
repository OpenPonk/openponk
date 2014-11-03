removing
removeObject: aName
	| objectToRemove |
	
	objectToRemove := mixObjects detect: [ :each | each name = aName ].
	objectToRemove removeParent: self name.
	mixObjects remove: objectToRemove ifAbsent: [].