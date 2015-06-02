removing
removeAssociation: anAssociation
	
	anAssociation start removeAssociation: (anAssociation name).
	^ anAssociation