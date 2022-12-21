Class {
	#name : #OPDiagramFigureColorCommand,
	#superclass : #OPDiagramFigureCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPDiagramFigureColorCommand class >> canBeExecutedInContext: aToolContext [

	^ (super canBeExecutedInContext: aToolContext) and: [ 
		  aToolContext controllers anySatisfy: [ :any | 
			  any diagramElement supportsColorChange ] ]
]

{ #category : #'as yet unclassified' }
OPDiagramFigureColorCommand class >> contextMenuActivation [
	<classAnnotation>
	^ CmdContextMenuActivation byItemOf: OPFigureColorMenuGroup for: OPCanvasPresenter
]

{ #category : #testing }
OPDiagramFigureColorCommand class >> isAbstract [

	^ self = OPDiagramFigureColorCommand
]
