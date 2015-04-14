class initialization
initialize
	super initialize.
	ModelToControllerMapping
		at: DCFsmInitialState put: DCFsmInitialStateController;
		at: DCFsmState put: DCFsmStateController;
		at: DCFsmFinalState put: DCFsmFinalStateController;
		at: DCFsmTransition put: DCFsmTransitionController.
	AcceptsAsTarget := {DCFsmInitialStateController.
	DCFsmStateController.
	DCFsmFinalStateController}