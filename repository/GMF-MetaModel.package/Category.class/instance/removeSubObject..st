removing
removeSubObject: aName
	| objectToRemove |
	
	objectToRemove := subObjects detect: [ :each | each name = aName ].
	objectToRemove removeParent: self name.
	subObjects remove: objectToRemove ifAbsent: [].