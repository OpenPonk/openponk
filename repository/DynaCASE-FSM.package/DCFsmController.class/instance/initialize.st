as yet unclassified
initialize
	super initialize.
	modelToControllerMapping := Dictionary new.
	modelToControllerMapping
		at: DCFsmInitialState put: DCFsmInitialStateController;
		at: DCFsmState put: DCFsmStateController;
		at: DCFsmFinalState put: DCFsmFinalStateController;
		at: DCFsmTransition put: DCFsmTransitionController