Class {
	#name : #OPDiagramFigureDevCommand,
	#superclass : #OPDiagramFigureCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #activation }
OPDiagramFigureDevCommand class >> canBeExecutedInContext: aToolContext [
	^ OPWorkbench isDevelopmentMode
]

{ #category : #activation }
OPDiagramFigureDevCommand class >> contextMenuActivation [
	<classAnnotation>
	^ CmdContextMenuActivation byItemOf: OPDiagramFigureDevMenuGroup for: OPCanvasPresenter
]

{ #category : #testing }
OPDiagramFigureDevCommand class >> isAbstract [
	^ self = OPDiagramFigureDevCommand
]
