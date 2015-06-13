accessing
modelToControllerMapping
	^ Dictionary new
		at: DCFsmInitialState put: DCFsmInitialStateController;
		at: DCFsmState put: DCFsmStateController;
		at: DCFsmFinalState put: DCFsmFinalStateController;
		at: DCFsmTransition put: DCFsmTransitionController;
		yourself