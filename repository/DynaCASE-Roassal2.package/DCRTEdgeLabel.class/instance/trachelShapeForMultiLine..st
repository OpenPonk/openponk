trachel shape production
trachelShapeForMultiLine: anElement
	| lines s lbl n txt aColor fontSize |
	aColor := self colorFor: anElement.
	fontSize := self heightFor: anElement.
	txt := self textFor: anElement.
	txt := txt copyReplaceAll: String tab with: '    '.
	lines := txt lines.
	s := TRCompositeShape new.
	lines reverse
		do: [ :l | 
			lbl := TRLabelShape new text: l.
			lbl color: aColor.
			lbl fontSize: fontSize.
			s shape1: lbl offset: (lbl width / 2) @ 0.
			n := TRCompositeShape new.
			n shape2: s offset: 0 @ 20.
			s := n ].	"s offset2: s encompassingRectangle extent negated / 2."
	^ s