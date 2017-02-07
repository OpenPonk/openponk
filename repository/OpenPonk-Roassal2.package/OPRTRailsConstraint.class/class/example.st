example
example
	| v shape a b c conn |
	v := RTView new.

	(shape := RTBox new)
		size: 10;
		color: Color black.

	a := shape elementOn: 'a'.
	b := shape elementOn: 'b'.
	c := shape elementOn: 'drag me'.

	v
		addAll:
			{a.
			b.
			c}.

	v elements @ (RTLabeled new color: Color black).

	conn := OPRTConnection new
		color: Color black;
		edgeFrom: a to: b.
	conn @ OPRTConnectionHandles.
	b translateBy: 0 @ 100.
	c translateBy: 50 @ 30.

	v add: conn.

	OPRTRailsConstraint element: c connection: conn.

	a @ RTDraggable.
	b @ RTDraggable.
	c @ RTDraggable.

	v open