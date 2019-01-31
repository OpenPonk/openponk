Class {
	#name : #OPTRArcShape,
	#superclass : #TRAbstractLineShape,
	#instVars : [
		'from',
		'to',
		'radius'
	],
	#category : #'OpenPonk-Trachel-Shapes'
}

{ #category : #accessing }
OPTRArcShape >> arc [
	^ OPCircleArc from: from to: to radius: radius
]

{ #category : #hooks }
OPTRArcShape >> computePath [
	| arc |
	arc := self arc.

	path := self athensCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: arc from;
				cwArcTo: arc to angle: arc biggerAngle ]
]

{ #category : #drawing }
OPTRArcShape >> drawOn: athensCanvas [
	athensCanvas pathTransform
		restoreAfter: [ 
			athensCanvas setShape: self path.
			(athensCanvas setStrokePaint: color) width: 1.
			athensCanvas draw ]
]

{ #category : #accessing }
OPTRArcShape >> encompassingRectangle [
	^ Rectangle encompassing: (Array with: from with: to)
]

{ #category : #accessing }
OPTRArcShape >> from [
	^ from
]

{ #category : #accessing }
OPTRArcShape >> from: aPoint [
	from := aPoint
]

{ #category : #'instance creation' }
OPTRArcShape >> from: aPoint to: anotherPoint [
	from := aPoint.
	to := anotherPoint
]

{ #category : #'as yet unclassified' }
OPTRArcShape >> includesPoint: aPoint [
	^ self arc circle containsPoint: aPoint
]

{ #category : #accessing }
OPTRArcShape >> radius [
	^ radius
]

{ #category : #accessing }
OPTRArcShape >> radius: aNumber [
	radius := aNumber
]

{ #category : #accessing }
OPTRArcShape >> to [
	^ to
]

{ #category : #accessing }
OPTRArcShape >> to: aPoint [
	to := aPoint
]

{ #category : #actions }
OPTRArcShape >> translateBy: aPoint [
	from := from + aPoint.
	to := to + aPoint.
	self resetPath.
]
