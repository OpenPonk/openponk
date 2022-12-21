Class {
	#name : #OPDiagramRemoveFigureCommand,
	#superclass : #OPDiagramFigureCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPDiagramRemoveFigureCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: Character delete meta for: OPCanvasPresenter
]

{ #category : #accessing }
OPDiagramRemoveFigureCommand >> defaultMenuIcon [

	^ self iconNamed: #glamorousTrash
]

{ #category : #accessing }
OPDiagramRemoveFigureCommand >> defaultMenuItemName [

	^ (models isNil or: [ models size = 1 ])
		  ifTrue: [ 'Remove from model' ]
		  ifFalse: [ 'Remove all ' , models size asString , ' from model' ]
]

{ #category : #execution }
OPDiagramRemoveFigureCommand >> execute [

	diagramController deselectAll.
	figures do: [ :each | 
		(diagramController hasControllerForFigure: each) ifTrue: [ 
			diagramController removeFromCanvas: each ] ].
	canvas signalUpdate
]
