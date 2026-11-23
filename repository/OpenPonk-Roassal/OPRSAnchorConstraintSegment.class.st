"
Represents a discrete line segment within a segmented path, providing geometric intersection and distance calculation utilities for anchoring constraints.
"
Class {
	#name : 'OPRSAnchorConstraintSegment',
	#superclass : 'RSObject',
	#instVars : [
		'from',
		'to'
	],
	#category : 'OpenPonk-Roassal-AnchorConstraint',
	#package : 'OpenPonk-Roassal',
	#tag : 'AnchorConstraint'
}

{ #category : 'instance creation' }
OPRSAnchorConstraintSegment class >> from: fromPoint to: toPoint [

	^ self new
		  from: fromPoint to: toPoint;
		  yourself
]

{ #category : 'comparing' }
OPRSAnchorConstraintSegment >> = anotherSegment [

	"Answer true if the receiver's species, from and to matches anotherSegment."

	^ self species = anotherSegment species and: [ 
		  from = anotherSegment from and: [ to = anotherSegment to ] ]
]

{ #category : 'accessing' }
OPRSAnchorConstraintSegment >> bottom [
	^ from y < to y
		ifTrue: [ from ]
		ifFalse: [ to ]
]

{ #category : 'geometry' }
OPRSAnchorConstraintSegment >> cotan [
	| vector |
	vector := self vector.
	vector y isZero
		ifTrue: [ ^ nil ].
	^ vector x / vector y
]

{ #category : 'accessing' }
OPRSAnchorConstraintSegment >> from [
	^ from
]

{ #category : 'accessing' }
OPRSAnchorConstraintSegment >> from: fromPoint to: toPoint [
	from := fromPoint.
	to := toPoint
]

{ #category : 'comparing' }
OPRSAnchorConstraintSegment >> hash [
	"Hash is reimplemented because = is implemented."

	^ from hash bitXor: to hash
]

{ #category : 'initialization' }
OPRSAnchorConstraintSegment >> initialize [
	super initialize.
	from := 0 @ 0.
	to := 0 @ 0
]

{ #category : 'private' }
OPRSAnchorConstraintSegment >> intersectHorizontal: other [
	"Intersection with other line segment. Self must be horizontal (optimization purposes)"

	| pt |
	(pt := self intersectHorizontalLine: other) ifNil: [ ^ nil ].
	pt x < self left x | (pt x > self right x) | (pt y < other bottom y) | (pt y > other top y)
		ifTrue: [ ^ nil ].
	^ pt
]

{ #category : 'private' }
OPRSAnchorConstraintSegment >> intersectHorizontalLine: other [
	"point of intersection of line on which line segment lies with line of other line segment or nil if parallel. Self must be horizontal (optimization purposes)"

	| x y vector |
	vector := other vector.
	vector y isZero
		ifTrue: [ ^ nil ].
	y := self from y.
	x := (self from y - other from y) * other cotan + other from x.
	^ x @ y
]

{ #category : 'comparing' }
OPRSAnchorConstraintSegment >> intersectRectangle: aRectangle [
	"collection of points of intersection with not rotated rectangle"

	| pts bottomLeft bottomRight topLeft topRight |
	bottomLeft := aRectangle bottomLeft.
	bottomRight := aRectangle bottomRight.
	topLeft := aRectangle topLeft.
	topRight := aRectangle topRight.
	pts := Set new.
	pts add: ((self class from: topLeft to: topRight) intersectHorizontal: self).
	pts add: ((self class from: bottomLeft to: bottomRight) intersectHorizontal: self).
	pts add: ((self class from: topLeft to: bottomLeft) intersectVertical: self).
	pts add: ((self class from: topRight to: bottomRight) intersectVertical: self).
	pts remove: nil ifAbsent: [  ].
	^ pts
]

{ #category : 'private' }
OPRSAnchorConstraintSegment >> intersectVertical: other [
	"Intersection with other line segment. Self must be vertical (optimization purposes)"

	| pt |
	pt := self transposed intersectHorizontal: other transposed.
	pt ifNil: [ ^ nil ].
	^ pt transposed
]

{ #category : 'accessing' }
OPRSAnchorConstraintSegment >> left [
	^ from x < to x
		ifTrue: [ from ]
		ifFalse: [ to ]
]

{ #category : 'geometry' }
OPRSAnchorConstraintSegment >> length [
	^ self vector r
]

{ #category : 'geometry' }
OPRSAnchorConstraintSegment >> nearestPointTo: aPoint [

	^ aPoint nearestPointOnLineFrom: self from to: self to
]

{ #category : 'geometry' }
OPRSAnchorConstraintSegment >> pointAtLength: aNumber [

	| lengthFromStart |
	lengthFromStart := (aNumber min: self length) max: 0.
	self length <= 0 ifTrue: [ ^ from ].
	^ from + (self vector / self length * lengthFromStart)
]

{ #category : 'accessing' }
OPRSAnchorConstraintSegment >> right [
	^ from x > to x
		ifTrue: [ from ]
		ifFalse: [ to ]
]

{ #category : 'geometry' }
OPRSAnchorConstraintSegment >> sideOfPoint: aPoint [
	"Compute on which side of the segment a point is.
	For line going from left A=(a_x, a_y) to right B=(b_x, b_y) the value is
	d = (y - a_y)(b_x - a_x) - (x - a_x)(b_y - a_y)
	-1 - above the line
	 0 - on the line
    1 - below the line
	"

	^ (aPoint y - from y * (to x - from x)
	   - (aPoint x - from x * (to y - from y))) sign
]

{ #category : 'accessing' }
OPRSAnchorConstraintSegment >> to [
	^ to
]

{ #category : 'accessing' }
OPRSAnchorConstraintSegment >> top [
	^ from y > to y
		ifTrue: [ from ]
		ifFalse: [ to ]
]

{ #category : 'geometry' }
OPRSAnchorConstraintSegment >> transposed [
	^ self class from: from transposed to: to transposed
]

{ #category : 'geometry' }
OPRSAnchorConstraintSegment >> vector [
	^ to - from
]
