public
trachelShapeFor: anEdge
	| multiShape path |
	path := self pathFor: anEdge.
	multiShape := TRMultiCompositeShape new.
	2 to: path size do: [ :i | 
		multiShape
			addShape:
				(DCTRStyledLineShape new
					dashes: dashes;
					width: width;
					from: (path at: i - 1) to: (path at: i);
					color: (self colorFor: anEdge)) ].
	head ifNotNil: [ multiShape addShape: (head trachelShapeFor: anEdge from: path allButLast last) ].
	tail ifNotNil: [ multiShape addShape: (tail trachelShapeFor: anEdge from: path second) ].
	^ multiShape