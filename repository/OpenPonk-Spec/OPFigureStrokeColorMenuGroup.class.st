Class {
	#name : #OPFigureStrokeColorMenuGroup,
	#superclass : #OPFigureColorMenuGroup,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPFigureStrokeColorMenuGroup class >> colors [

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

{ #category : #'as yet unclassified' }
OPFigureStrokeColorMenuGroup class >> styleAttribute [

	^ #strokeColor
]

{ #category : #accessing }
OPFigureStrokeColorMenuGroup >> name [

	^ 'Stroke color'
]
