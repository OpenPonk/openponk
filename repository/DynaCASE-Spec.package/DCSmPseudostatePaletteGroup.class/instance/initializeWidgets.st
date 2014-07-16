initialization
initializeWidgets
	super initializeWidgets.
	(initialButton := self newButton) label: 'Initial'.
	(forkButton := self newButton) label: 'Fork'