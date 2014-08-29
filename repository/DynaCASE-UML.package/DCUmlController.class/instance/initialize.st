initialization
initialize
	super initialize.
	modelToControllerMapping
		at: DCUmlClass put: DCUmlClassController;
		at: DCUmlAssociation put: DCUmlAssociationController