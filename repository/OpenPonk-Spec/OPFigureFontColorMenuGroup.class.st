Class {
	#name : #OPFigureFontColorMenuGroup,
	#superclass : #OPFigureColorMenuGroup,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPFigureFontColorMenuGroup class >> colors [

	^ OPFigureStrokeColorMenuGroup colors
]

{ #category : #'as yet unclassified' }
OPFigureFontColorMenuGroup class >> styleAttribute [

	^ #fontColor
]

{ #category : #accessing }
OPFigureFontColorMenuGroup >> name [

	^ 'Font color'
]
