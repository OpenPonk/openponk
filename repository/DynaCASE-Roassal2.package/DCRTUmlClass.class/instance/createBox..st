private
createBox: extent
	| box |
	box := TRBoxShape new.
	box extent: extent.
	box color: Color white.
	box strokePaint: Color black.

	^ box