Class {
	#name : 'OPFigureFillColorMenuGroup',
	#superclass : 'OPFigureColorMenuGroup',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'as yet unclassified' }
OPFigureFillColorMenuGroup class >> colors [

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
OPFigureFillColorMenuGroup class >> styleAttribute [

	^ #fillColor
]

{ #category : 'accessing' }
OPFigureFillColorMenuGroup >> name [

	^ 'Fill color'
]
