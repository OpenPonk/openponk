materializing
materializeProjectBasic: aMaterializedProject
	| p |
	p := DCProject new.
	p projectName: (aMaterializedProject at: #projectName).
	^ p