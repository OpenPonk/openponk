initialization
initialize
	super initialize.
	modelToControllerMapping
		at: Kind put: DCOmlKindController;
		at: SubKind put: DCOmlSubKindController;
		at: BasicAssociation put: DCOmlBasicAssociationController;
		at: ParentClass put: DCOmlGeneralizationController.
	acceptsAsTarget := #(#DCOmlKindController)