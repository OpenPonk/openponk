accessing
modelToControllerMapping
	^ Dictionary new
		at: DCFsmInitialState put: DCFsmInitialStateController;
		at: DCFsmState put: DCFsmStateController;
		at: DCFsmTransition put: DCFsmTransitionController;
		yourself