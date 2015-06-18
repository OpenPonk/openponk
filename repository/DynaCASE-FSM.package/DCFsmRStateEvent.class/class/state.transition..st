instance creation
state: aState transition: aTransition
	^ self new
		state: aState;
		transition: aTransition;
		yourself