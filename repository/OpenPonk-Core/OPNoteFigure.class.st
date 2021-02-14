Class {
	#name : #OPNoteFigure,
	#superclass : #OPResizableFigureWithText,
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #rendering }
OPNoteFigure >> addInteractions [
	super addInteractions.
	self @ RTDraggableSnapToGrid
]

{ #category : #accessing }
OPNoteFigure >> baseShape [
	^ RTBox new
		color: Color paleYellow;
		borderColor: Color darkGray;
		width: 150;
		height: 100;
		yourself
]

{ #category : #hooks }
OPNoteFigure >> modelTextSelector [
	^ #text
]
