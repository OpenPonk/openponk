comparing
intersection: other
	"point of intersection with other line segment or nil if it does not exists"

	| intersection |
	intersection := self intersectLines: other.
	intersection ifNil: [ ^ nil ].
	(intersection onLineFrom: self from to: self to) & (intersection onLineFrom: other from to: other to)
		ifFalse: [ ^ nil ].
	^ intersection