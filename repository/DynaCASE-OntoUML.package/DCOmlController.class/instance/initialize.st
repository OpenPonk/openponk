initialization
initialize
	super initialize.
	modelToControllerMapping at: Kind put: DCOmlKindController.
	acceptsAsTarget := #(#DCOmlKindController)