"
I create a grid on the view.
"
Class {
	#name : #OPRTGridView,
	#superclass : #RTInteraction,
	#category : 'OpenPonk-Roassal2-Interactivity'
}

{ #category : #hooks }
OPRTGridView >> initializeElement: aView [
	aView canvas addShape: OPTRGridShape new.
	aView canvas
		addShape:
			(TRSVGPath new
				strokePaint: Color black;
				borderWidth: 1;
				path: 'M -5 0 H 5 M 0 -5 V 5')
]
