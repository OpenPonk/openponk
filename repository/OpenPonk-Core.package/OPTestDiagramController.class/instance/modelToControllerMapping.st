accessing
modelToControllerMapping
	^ OPControllerFactory new
		register: OPTestEntityController forModel: OPTestEntityModel;
		register: OPTestRelationController forModel: OPTestRelationModel