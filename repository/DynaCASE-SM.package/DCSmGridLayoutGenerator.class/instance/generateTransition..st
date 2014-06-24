as yet unclassified
generateTransition: aTransition
	| source target trio transitionLayout |
	source := self layout detect: [ :el | el model = aTransition source ].
	target := self layout detect: [ :el | el model = aTransition target ].
	transitionLayout := DCSmLayoutTransition new.
	transitionLayout points
		add: source layout center;
		add: target layout center.
	trio := DCTriad new
		model: aTransition;
		layout: transitionLayout.
	^ trio