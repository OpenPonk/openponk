as yet unclassified
initializePresenter
	| element |
	initialButton
	action: [ element := DCSmVisualInitial new.
		self onAction value: element ].
	forkButton 
	action: [ element := DCSmVisualFork new.
		self onAction value: element ].