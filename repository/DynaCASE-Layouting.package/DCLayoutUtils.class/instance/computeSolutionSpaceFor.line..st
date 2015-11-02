as yet unclassified
computeSolutionSpaceFor: aBox line: aLine
	| vertA vertB space direction |
	space := OrderedCollection new.
	vertA := RTLineSegment from: aLine from to: aLine from + (0 @ aBox height).
	vertB := RTLineSegment from: aLine to to: aLine to + (0 @ aBox height).
	direction := aLine from x < aLine to x
		ifTrue: [ 1 ]
		ifFalse: [ -1 ].
	(vertA vector angleWith: aLine vector) >= Float halfPi
		ifTrue:
			[ space add: vertA from.
			space add: aLine from + (direction * (aBox width negated @ 0)).
			space add: aLine from + (direction * (aBox width negated @ aBox height)).
			space add: aLine to + (direction * (aBox width @ aBox height)).
			space add: aLine to + (direction * (aBox width @ 0)) ]
		ifFalse: [  ].	"space add: vertB from.
			space add: vertB to.
			space add: vertB from + (direction negated * (aBox width @ aBox height)).
			space add: aLine from + (direction negated * (0 @ aBox height))"
	space add: aLine to.
	^ space