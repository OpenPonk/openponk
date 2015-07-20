removing
removeMethod: aNameString
	methods := methods reject: [ :each | each name = aNameString ]