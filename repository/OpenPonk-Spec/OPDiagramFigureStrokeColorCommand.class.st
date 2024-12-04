Class {
	#name : 'OPDiagramFigureStrokeColorCommand',
	#superclass : 'OPRoassalShapeColorCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'accessing' }
OPDiagramFigureStrokeColorCommand class >> colorAttribute [

	^ #strokeColor
]

{ #category : 'activation' }
OPDiagramFigureStrokeColorCommand class >> contextMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation
		  byItemOf: OPRoassalShapeStrokeColorMenuGroup
		  for: OPCanvasPresenter
]

{ #category : 'as yet unclassified' }
OPDiagramFigureStrokeColorCommand class >> defaultColorOf: aDiagramElement [

	^ aDiagramElement defaultStrokeColor
]
