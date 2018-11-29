"
Use custom OPTRCanvasGridShape
"
Class {
	#name : #OPRTGridView2,
	#superclass : #RTGridView,
	#category : #'OpenPonk-Roassal2-Interactivity'
}

{ #category : #adding }
OPRTGridView2 >> addGridShapeTo: aCanvas [
	gridShape := OPTRCanvasGridShape new.
	gridShape spacing: gridSize.
	gridShape dashes: self dashes.
	gridShape color: self color.
	aCanvas addShape: gridShape
]
