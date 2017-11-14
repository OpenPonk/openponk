accessing
initializeWidgets
	palette := self instantiate: OPPalette.
	scrollPane := (self newScrollPaneFor: palette) asSpecAdapter