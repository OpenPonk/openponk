Class {
	#name : #OPCircle,
	#superclass : #Object,
	#instVars : [
		'radius',
		'center'
	],
	#category : 'OpenPonk-Trachel-Primitives'
}

{ #category : #'instance creation' }
OPCircle class >> centersFor: p1 and: p2 radius: r [
	| d mid sq x y |
	d := p1 dist: p2.
	d > r
		ifTrue: [ self error: 'Points are two far apart.' ].
	mid := (p1 + p2) / 2.
	sq := (r squared - (d / 2) squared) sqrt.
	x := sq * (p2 y - p1 y) / d.
	y := sq * (p2 x - p1 x) / d.

	^ {((mid x + x) @ (mid y - y)).
	((mid x - x) @ (mid y + y))}
]

{ #category : #'instance creation' }
OPCircle class >> circlesFor: p1 and: p2 radius: r [
	^ (self centersFor: p1 and: p2 radius: r) sorted collect: [ :each | self radius: r center: each ]
]

{ #category : #'instance creation' }
OPCircle class >> radius: aNumber [
	^ self radius: aNumber center: 0 @ 0
]

{ #category : #'instance creation' }
OPCircle class >> radius: aNumber center: aPoint [
	^ self new setRadius: aNumber center: aPoint
]

{ #category : #accessing }
OPCircle >> bottom [
	^ 0 @ radius + center
]

{ #category : #accessing }
OPCircle >> center [
	^ center
]

{ #category : #testing }
OPCircle >> containsPoint: aPoint [
	^ (center dist: aPoint) <= radius
]

{ #category : #accessing }
OPCircle >> left [
	^ radius negated @ 0 + center
]

{ #category : #printing }
OPCircle >> printOn: aStream [
	center printOn: aStream.
	aStream nextPutAll: ' radius: '.
	aStream nextPutAll: '(' , radius asString , ')'
]

{ #category : #accessing }
OPCircle >> radius [
	^ radius
]

{ #category : #accessing }
OPCircle >> right [
	^ radius @ 0 + center
]

{ #category : #initialization }
OPCircle >> setRadius: aNumber center: aPoint [
	radius := aNumber.
	center := aPoint
]

{ #category : #accessing }
OPCircle >> tangentAt: aPoint [
	^ aPoint + ((aPoint y - center y) @ (center x - aPoint x))
]

{ #category : #accessing }
OPCircle >> top [
	^ 0 @ radius negated + center
]
