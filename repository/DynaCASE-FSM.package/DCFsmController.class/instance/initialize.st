initialization
initialize
	super initialize.
	modelToControllerMapping
		at: DCFsmInitialState put: DCFsmInitialStateController;
		at: DCFsmState put: DCFsmStateController;
		at: DCFsmFinalState put: DCFsmFinalStateController;
		at: DCFsmTransition put: DCFsmTransitionController.
	acceptsAsTarget := #(#DCFsmInitialStateController #DCFsmStateController #DCFsmFinalStateController)