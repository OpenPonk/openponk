"
Commander menu group that organizes context menu commands specifically for modifying the stroke (border or line) color of selected Roassal shapes.
"
Class {
	#name : 'OPRoassalShapeStrokeColorMenuGroup',
	#superclass : 'OPRoassalShapeColorMenuGroup',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'hooks' }
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

{ #category : 'hooks' }
OPRoassalShapeStrokeColorMenuGroup class >> styleAttribute [

	^ #strokeColor
]

{ #category : 'accessing' }
OPRoassalShapeStrokeColorMenuGroup >> name [

	^ 'Stroke color'
]
