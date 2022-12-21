Class {
	#name : #OPRSDraggableCPController,
	#superclass : #RSAbstractCPController,
	#category : #'OpenPonk-Roassal3'
}

{ #category : #hooks }
OPRSDraggableCPController >> controlPointsFor: aLine [

	| ap innerCPs straightLineFrom straightLineTo |
	ap := aLine attachPoint.

	innerCPs := self innerControlPointsFor: aLine.

	straightLineFrom := ap startingPointOf: aLine.
	straightLineTo := ap endingPointOf: aLine.

	^ { straightLineFrom } , innerCPs , { straightLineTo }
]

{ #category : #hooks }
OPRSDraggableCPController >> defaultInnerSelfControlPointsFor: aLine [

	| delta encompassingRectangle from corner to |
	delta := 50.
	encompassingRectangle := aLine from encompassingRectangle.
	from := encompassingRectangle topCenter.
	corner := encompassingRectangle topRight.
	to := encompassingRectangle rightCenter.

	^ Array
		  with: from + (0 @ delta)
		  with: corner + (delta @ delta)
		  with: to + (delta @ 0)
]

{ #category : #hooks }
OPRSDraggableCPController >> innerControlPointsFor: aLine [

	| currentInnerCPs defaultInnerCPs diffs |
	currentInnerCPs := aLine controlPoints
		                   copyFrom: 2
		                   to: aLine controlPoints size - 1.
	aLine from = aLine to ifFalse: [ ^ currentInnerCPs ].

	"self-loop"
	defaultInnerCPs := self defaultInnerSelfControlPointsFor: aLine.
	currentInnerCPs ifEmpty: [ ^ defaultInnerCPs ].
	currentInnerCPs size = defaultInnerCPs size ifFalse: [ 
		^ currentInnerCPs ].
	diffs := (1 to: currentInnerCPs size) collect: [ :index | 
		         (currentInnerCPs at: index) - (defaultInnerCPs at: index) ].
	(diffs allSatisfy: [ :each | each = diffs first ]) ifTrue: [ 
		^ defaultInnerCPs ].
	^ currentInnerCPs
]
