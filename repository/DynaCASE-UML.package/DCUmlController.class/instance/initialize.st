initialization
initialize
	super initialize.
	modelToControllerMapping := Dictionary new.
	modelToControllerMapping
		at: DCUmlClass put: DCUmlClassController;
		at: DCUmlAssociation put: DCUmlAssociationController