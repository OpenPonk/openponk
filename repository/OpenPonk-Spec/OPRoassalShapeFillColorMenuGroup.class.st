Class {
	#name : 'OPRoassalShapeFillColorMenuGroup',
	#superclass : 'OPRoassalShapeColorMenuGroup',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
OPRoassalShapeFillColorMenuGroup class >> styleAttribute [

	^ #fillColor
]

{ #category : 'accessing' }
OPRoassalShapeFillColorMenuGroup >> name [

	^ 'Fill color'
]
