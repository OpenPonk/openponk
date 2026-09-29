"
Commander menu group that organizes context menu commands specifically for modifying the font color of text within selected Roassal shapes.
"
Class {
	#name : 'OPRoassalShapeFontColorMenuGroup',
	#superclass : 'OPRoassalShapeColorMenuGroup',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'hooks' }
OPRoassalShapeFontColorMenuGroup class >> colors [

	^ OPRoassalShapeStrokeColorMenuGroup colors
]

{ #category : 'hooks' }
OPRoassalShapeFontColorMenuGroup class >> styleAttribute [

	^ #fontColor
]

{ #category : 'accessing' }
OPRoassalShapeFontColorMenuGroup >> name [

	^ 'Font color'
]
