Class {
	#name : 'OPRoassalShapeFontColorMenuGroup',
	#superclass : 'OPRoassalShapeColorMenuGroup',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'as yet unclassified' }
OPRoassalShapeFontColorMenuGroup class >> colors [

	^ OPRoassalShapeStrokeColorMenuGroup colors
]

{ #category : 'as yet unclassified' }
OPRoassalShapeFontColorMenuGroup class >> styleAttribute [

	^ #fontColor
]

{ #category : 'accessing' }
OPRoassalShapeFontColorMenuGroup >> name [

	^ 'Font color'
]
