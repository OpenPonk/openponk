comparing
intersection: other
	"point of intersection with other line segment or nil if it does not exists"

	| intersection |
	other from y = other to y
		ifTrue: [ ^ self intersectHorizontal: other ].
	other from x = other to x
		ifTrue: [ ^ self intersectVertical: other ].
	intersection := self intersectLines: other.
	intersection ifNil: [ ^ nil ].
	(intersection onLineFrom: self from to: self to) & (intersection onLineFrom: other from to: other to)
		ifFalse: [ ^ nil ].
	^ intersection