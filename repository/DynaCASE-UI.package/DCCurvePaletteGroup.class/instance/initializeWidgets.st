initialization
initializeWidgets
	super initializeWidgets.
	(lineButton := self newButton) label: 'Line'.
	(polyLineButton := self newButton) label: 'PolyLine'