tests - ui interaction
testInitializePalette
	| palette |
	palette := OPPalette new.
	self assert: palette entries size = 2.
	diagramController initializePalette: palette.
	self assert: palette entries size = 3