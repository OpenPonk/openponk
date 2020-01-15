Class {
	#name : #OPDiagramInspectModelFigureCommand,
	#superclass : #OPDiagramFigureCommand,
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPDiagramInspectModelFigureCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: $i meta for: OPCanvasModel
]

{ #category : #execution }
OPDiagramInspectModelFigureCommand >> defaultMenuItemName [
	^ 'Inspect model'
]

{ #category : #execution }
OPDiagramInspectModelFigureCommand >> execute [
	models ifEmpty: [ ^ self ].
	models size = 1
		ifTrue: [ models first inspect ]
		ifFalse: [ models inspect ]
]
