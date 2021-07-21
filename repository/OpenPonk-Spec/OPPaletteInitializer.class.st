Class {
	#name : #OPPaletteInitializer,
	#superclass : #Object,
	#instVars : [
		'palette',
		'diagramController'
	],
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #'instance creation' }
OPPaletteInitializer class >> addAllToPalette: aPalette forController: aDiagramController [
	^ self new
		palette: aPalette;
		diagramController: aDiagramController;
		addAll
]

{ #category : #actions }
OPPaletteInitializer >> addAll [
	diagramController initializePalette: palette.
	palette newSeparator.
	self filteredCommonItems do: #value
]

{ #category : #constants }
OPPaletteInitializer >> allCommonItemsByName [
	^ {(OPNoteController paletteItemName
		-> [ (palette newCreationEntry: [ OPNoteController new ])
				label: 'Note';
				icon: (self iconNamed: #announcement);
				whenCompleted: [ :ctrl | OPEditElementTextCommand executeOn: ctrl model ] ]).
	(OPBoundaryController paletteItemName
		-> [ (palette newCreationEntry: [ OPBoundaryController new ])
				label: 'Boundary';
				icon: (self iconNamed: #checkBoxOff);
				whenCompletedRename ])} asDictionary
]

{ #category : #accessing }
OPPaletteInitializer >> diagramController: aDiagramController [
	diagramController := aDiagramController
]

{ #category : #actions }
OPPaletteInitializer >> filteredCommonItems [
	| filteredItemsByName |
	filteredItemsByName := self allCommonItemsByName.
	diagramController incompatiblePaletteItemNames
		do: [ :each | 
			filteredItemsByName
				removeKey: each
				ifAbsent: [ self
						inform:
							diagramController asString , ' attempts to disable palette item "'
								, each , '" that does not exist' ] ].
	^ filteredItemsByName values
]

{ #category : #accessing }
OPPaletteInitializer >> palette: anOPPalette [ 
	palette := anOPPalette 
]
