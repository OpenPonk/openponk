as yet unclassified
initialPositionsFor: aLabel
	| marks size w h extent |
	extent := aLabel extent.
	marks := self edgeMarksFor: (self edgeForLabel: aLabel).
	size := marks size.
	w := aLabel encompassingRectangle width / 2.
	h := aLabel encompassingRectangle height / 2.
	"all positions are moved by a 1@1 point to simplify overlap computing"
	^ (marks
		withIndexCollect:
			[ :each :i | 
			{(DCRTLPosition new
				orientation: #topRight;
				feature: aLabel;
				ranking: i of: size;
				mark: each;
				position: each + (w @ h negated) + (1 @ 1 negated)).
			(DCRTLPosition new
				ranking: i of: size;
				feature: aLabel;
				orientation: #bottomRight;
				mark: each;
				position: each + (w @ h) + (1 @ 1)).
			(DCRTLPosition new
				orientation: #bottomLeft;
				feature: aLabel;
				ranking: i of: size;
				mark: each;
				position: each + (w negated @ h) + (1 negated @ 1)).
			(DCRTLPosition new
				orientation: #topLeft;
				ranking: i of: size;
				feature: aLabel;
				mark: each;
				position: each - (w @ h) - (1 @ 1))} ]) flatten
		collect: [ :each | each bounds: ((each position corner: each position) expandBy: extent / 2) ]