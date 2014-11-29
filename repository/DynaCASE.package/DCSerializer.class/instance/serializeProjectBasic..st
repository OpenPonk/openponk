serializing
serializeProjectBasic: aProject
	| d |
	d := Dictionary new.
	d at: #projectName put: aProject projectName.
	^ d