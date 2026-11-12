Extension { #name : 'OPDiagramControllerTest' }

{ #category : '*OpenPonk-Spec-Tests' }
OPDiagramControllerTest >> testInitializePalette [

	| palette |
	palette := OPPalette new.
	self assert: palette items size equals: 2.
	controller initializePalette: palette.
	self assert: palette items size equals: 3
]
