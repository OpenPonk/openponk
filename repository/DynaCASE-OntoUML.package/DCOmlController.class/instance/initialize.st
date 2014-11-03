initialization
initialize
	super initialize.
	modelToControllerMapping
		at: Kind put: DCOmlKindController;
		at: BasicAssociation put: DCOmlBasicAssociationController.
	acceptsAsTarget := #(#DCOmlKindController)