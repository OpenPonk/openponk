Class {
	#name : 'OPDiagramInspectModelFigureCommand',
	#superclass : 'OPDiagramFigureCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'testing' }
OPDiagramInspectModelFigureCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: $i meta for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPDiagramInspectModelFigureCommand >> defaultMenuIconName [

	^  #glamorousInspect
]

{ #category : 'accessing' }
OPDiagramInspectModelFigureCommand >> defaultMenuItemName [

	| basicName |
	basicName := 'Inspect model'.
	models ifNil: [ ^ basicName ].
	models size = 1 ifTrue: [ ^ basicName ].
	^ GRInflector pluralize: basicName
]

{ #category : 'execution' }
OPDiagramInspectModelFigureCommand >> execute [

	models size = 1 ifTrue: [ ^ models anyOne inspect ].
	^ models inspect
]
