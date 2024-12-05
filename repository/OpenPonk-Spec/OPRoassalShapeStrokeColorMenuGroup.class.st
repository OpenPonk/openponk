Class {
	#name : 'OPRoassalShapeStrokeColorMenuGroup',
	#superclass : 'OPRoassalShapeColorMenuGroup',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'as yet unclassified' }
OPRoassalShapeStrokeColorMenuGroup class >> colors [

	^ {
		  Color black.
		  Color lightGray.
		  Color white.
		  Color yellow.
		  Color blue.
		  Color red.
		  Color orange.
		  Color green.
		  Color magenta }
]

{ #category : 'as yet unclassified' }
OPRoassalShapeStrokeColorMenuGroup class >> styleAttribute [

	^ #strokeColor
]

{ #category : 'accessing' }
OPRoassalShapeStrokeColorMenuGroup >> name [

	^ 'Stroke color'
]
