as yet unclassified
initialPositionsFor: aLabel
	| marks w h extent |
	extent := aLabel extent.
	marks := self edgeMarksFor: (self edgeForLabel: aLabel).
	w := aLabel encompassingRectangle width / 2.
	h := aLabel encompassingRectangle height / 2.
	"all positions are moved by a 1@1 point to simplify overlap computing"
	^ (marks
		flatCollect:
			[ :each | 
			{(each + (w @ h) + (1 @ 1)).
			(each - (w @ h) - (1 @ 1)).
			(each + (w @ h negated) + (1 @ 1 negated)).
			(each + (w negated @ h) + (1 negated @ 1))} ])
		collect: [ :each | (each corner: each) expandBy: extent / 2 ]