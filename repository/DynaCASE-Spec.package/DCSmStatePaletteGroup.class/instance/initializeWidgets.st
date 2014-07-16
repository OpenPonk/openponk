initialization
initializeWidgets
	super initializeWidgets.
	(stateButton := self newButton) label: 'State'.
	(finalStateButton := self newButton) label: 'Final state'