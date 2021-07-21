"
I am a styled multiline that will loop if the source and target is the same element.
"
Class {
	#name : #OPRTStyledMultiLine,
	#superclass : #RTStyledMultiLine,
	#category : #'OpenPonk-Roassal2-Shapes'
}

{ #category : #testing }
OPRTStyledMultiLine class >> isDeprecated [
	^ true
]

{ #category : #private }
OPRTStyledMultiLine >> checkLineToSelfFor: anEdge [
	anEdge from = anEdge to
		ifTrue: [ self createLineToSelf ]
]

{ #category : #private }
OPRTStyledMultiLine >> createLineToSelf [
	"changes path to display itself from one element to the same one"

	self attachPoint: OPRTOrthogonalSelfAttachPoint new.
	(blockProducingPath value: 0 @ 0 value: 0 @ 0) size = 2
		ifTrue: [ self
				block: [ :fromPoint :toPoint | 
					| rectangle |
					rectangle := Rectangle
						origin: (fromPoint min: toPoint)
						extent: 2 * ((fromPoint max: toPoint) - (fromPoint min: toPoint)) + (12 @ 12).
					Array
						with: fromPoint
						with: rectangle topRight
						with: rectangle bottomRight
						with: rectangle bottomLeft
						with: toPoint ] ]
]

{ #category : #accessing }
OPRTStyledMultiLine >> pathFor: anEdge [
	| fromPoint toPoint |
	self checkLineToSelfFor: anEdge.
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	^ blockProducingPath value: fromPoint value: toPoint
]
