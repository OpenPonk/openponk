Class {
	#name : #OPDiagramInspectModelFigureCommand,
	#superclass : #OPDiagramFigureCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPDiagramInspectModelFigureCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: $i meta for: OPCanvasPresenter
]

{ #category : #execution }
OPDiagramInspectModelFigureCommand >> defaultMenuItemName [
	^ 'Inspect model'
]

{ #category : #execution }
OPDiagramInspectModelFigureCommand >> execute [
	models ifEmpty: [ ^ self ].
	models size = 1
		ifTrue: [ models anyOne inspect ]
		ifFalse: [ models inspect ]
]
