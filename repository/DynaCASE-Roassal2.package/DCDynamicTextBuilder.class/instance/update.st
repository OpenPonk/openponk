as yet unclassified
update
	| corner encompassingRectangle off origin box |
	corner := background trachelShape encompassingRectangle origin.
	elements
		do: [ :e | 
			translator translateTopLeftOf: e to: corner.
			corner := corner + (0 @ e height) ].
	elements size > 0
		ifTrue: [ encompassingRectangle := elements anyOne encompassingRectangle ]
		ifFalse: [ encompassingRectangle := background encompassingRectangle ].
	origin := encompassingRectangle origin.
	box := origin corner: (origin x + self minWidth) @ origin y.
	encompassingRectangle := encompassingRectangle merge: box.
	elements do: [ :e | encompassingRectangle := encompassingRectangle merge: e trachelShape encompassingRectangle ].
	background trachelShape extent: encompassingRectangle width @ encompassingRectangle height.
	off := background trachelShape encompassingRectangle center - encompassingRectangle center.
	off := off asIntegerPoint.
	elements
		do: [ :e | 
			e translateBy: off.
			e update ].
	view signalUpdate