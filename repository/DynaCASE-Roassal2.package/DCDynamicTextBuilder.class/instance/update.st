as yet unclassified
update
	| corner encompassingRectangle off |
	corner := background trachelShape encompassingRectangle origin.
	elements
		do: [ :e | 
			translator translateTopLeftOf: e to: corner.
			corner := corner + (0 @ e height) ].
	encompassingRectangle := elements anyOne encompassingRectangle.
	backgroundWidth
		ifNotNil: [ 
			| origin box |
			origin := encompassingRectangle origin.
			box := origin corner: (origin x + backgroundWidth) @ origin y.
			encompassingRectangle := encompassingRectangle merge: box ].
	elements do: [ :e | encompassingRectangle := encompassingRectangle merge: e trachelShape encompassingRectangle ].
	background trachelShape extent: encompassingRectangle width @ encompassingRectangle height.
	off := background trachelShape encompassingRectangle center - encompassingRectangle center.
	off := off asIntegerPoint.
	elements
		do: [ :e | 
			e translateBy: off.
			e update ].
	view signalUpdate