as yet unclassified
update
	| corner encompassingRectangle off elements maxWidth |
	maxWidth := groups anyOne width.
	groups do: [ :g | maxWidth := maxWidth max: g width ].
	groups
		do: [ :g | 
			g width: maxWidth.
			g update ].
	elements := groups collect: [ :g | g background ].
	corner := background trachelShape encompassingRectangle origin.
	elements
		do: [ :e | 
			translator translateTopLeftOf: e to: corner.
			corner := corner + (0 @ e height) ].
	encompassingRectangle := elements anyOne encompassingRectangle.
	elements do: [ :e | encompassingRectangle := encompassingRectangle merge: e trachelShape encompassingRectangle ].
	groups do: [ :g | g width: encompassingRectangle width ].
	background trachelShape extent: encompassingRectangle width @ encompassingRectangle height.
	off := background trachelShape encompassingRectangle center - encompassingRectangle center.
	off := off asIntegerPoint.
	elements
		do: [ :e | 
			e translateBy: off.
			e update ].
	groups do: [ :g | g update ].
	view signalUpdate