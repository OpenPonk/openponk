accessing
stereotype: aString
	aString ifEmpty: [ self removeStereotype ] ifNotEmpty: [ self changeStereotype: aString ].