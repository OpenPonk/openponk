Class {
	#name : #OPLayoutDiagramCommand,
	#superclass : #OPDiagramToolbarCommand,
	#instVars : [
		'selector',
		'label',
		'layouter'
	],
	#category : #'OpenPonk-Spec-Layouting'
}

{ #category : #testing }
OPLayoutDiagramCommand class >> canBeExecutedInContext: aToolContext [
	^ aToolContext owner plugin layouterClass supports: self
]

{ #category : #activation }
OPLayoutDiagramCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation byItemOf: OPLayoutDiagramMenuGroup for: OPCanvasPresenter
]

{ #category : #accessing }
OPLayoutDiagramCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	layouter := diagramPresenter diagramController layouter
]
