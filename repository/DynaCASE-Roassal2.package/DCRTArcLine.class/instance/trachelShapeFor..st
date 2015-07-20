rendering
trachelShapeFor: anEdge
	| arcShape from |
	arcShape := self arcShapeFor: anEdge.
	"5@0 should be actually something like head width ... to offset the fact that we want earlier tangent"
	from := 6 @ 0 + (arcShape arc circle tangentAt: (attachPoint endingPointOf: anEdge)).

	^ TRCompositeShape new
		addShape: arcShape;
		addShape: (head trachelShapeFor: anEdge from: from);
		addShape: (tail trachelShapeFor: anEdge);
		yourself