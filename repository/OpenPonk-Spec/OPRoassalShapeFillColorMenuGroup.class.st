"
Commander menu group that organizes context menu commands specifically for modifying the fill color of selected Roassal shapes.
"
Class {
	#name : 'OPRoassalShapeFillColorMenuGroup',
	#superclass : 'OPRoassalShapeColorMenuGroup',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'hooks' }
OPRoassalShapeFillColorMenuGroup class >> colors [

	^ {
		  Color transparent.
		  Color veryVeryLightGray.
		  Color white.
		  Color paleYellow.
		  Color paleBlue.
		  Color paleRed.
		  Color paleOrange.
		  Color paleGreen.
		  Color paleMagenta }
]

{ #category : 'hooks' }
OPRoassalShapeFillColorMenuGroup class >> styleAttribute [

	^ #fillColor
]

{ #category : 'accessing' }
OPRoassalShapeFillColorMenuGroup >> name [

	^ 'Fill color'
]
