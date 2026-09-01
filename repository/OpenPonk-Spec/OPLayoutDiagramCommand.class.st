"
Diagram toolbar command that triggers a specific graph layout algorithm (such as tree, grid, or circle layout) to automatically arrange elements on the current canvas.
"
Class {
	#name : 'OPLayoutDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#instVars : [
		'layouter'
	],
	#category : 'OpenPonk-Spec-Layouting',
	#package : 'OpenPonk-Spec',
	#tag : 'Layouting'
}

{ #category : 'testing' }
OPLayoutDiagramCommand class >> canBeExecutedInContext: aToolContext [
	^ aToolContext owner plugin layouterClass supports: self
]

{ #category : 'activation' }
OPLayoutDiagramCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation byItemOf: OPLayoutDiagramMenuGroup for: OPCanvasPresenter
]

{ #category : 'execution' }
OPLayoutDiagramCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	layouter := diagramPresenter diagramController layouter
]
