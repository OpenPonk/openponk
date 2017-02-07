private - layout
updateParameters
	| segmentsWithDistances closestSegment sum |
	segmentsWithDistances := self segments
		withIndexCollect:
			[ :each :i | 
			Array
				with: i
				with: each first
				with: each second
				with: (element position nearestPointOnLineFrom: each first to: each second) ].
	closestSegment := segmentsWithDistances
		detectMin: [ :each | element position dist: each fourth ].
	sum := (self segments first: closestSegment first - 1)
		inject: 0
		into: [ :s :next | s + (next first dist: next second) ].
	sum := sum + (closestSegment second dist: closestSegment fourth).
	gripElement trachelShape
		doWithoutCallbacks:
			[ 
			position := sum / self connectionLength.
			distance := element position dist: closestSegment fourth.
			(self
				windingOrder: element position
				segment:
					{closestSegment second.
					closestSegment third}) < 0
				ifTrue: [ distance := distance negated ].
			gripElement translateTo: closestSegment fourth ]