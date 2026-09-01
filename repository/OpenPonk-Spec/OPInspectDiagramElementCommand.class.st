"
Developer-oriented context menu command that opens a Pharo inspector directly on the diagram element mapped to the selected Roassal shape.
"
Class {
	#name : 'OPInspectDiagramElementCommand',
	#superclass : 'OPInspectDevCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPInspectDiagramElementCommand >> itemType [

	^ 'diagram element'
]

{ #category : 'accessing' }
OPInspectDiagramElementCommand >> items [

	^ diagramElements
]
