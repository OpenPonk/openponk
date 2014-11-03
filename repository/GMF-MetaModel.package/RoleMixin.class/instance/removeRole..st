removing
removeRole: aName
	| roleToRemove |
	
	roleToRemove := roles detect: [ :each | each name = aName ].
	roleToRemove removeParent: self name.
	roles remove: roleToRemove ifAbsent: [].