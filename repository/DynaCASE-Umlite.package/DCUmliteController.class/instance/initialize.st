as yet unclassified
initialize
	super initialize.
	modelToControllerMapping
		at: DCUmliteClass put: DCUmliteClassController;
		at: DCUmliteAssociation put: DCUmliteAssociationController