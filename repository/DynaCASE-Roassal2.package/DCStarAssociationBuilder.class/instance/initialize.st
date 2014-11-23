initialization
initialize
	| block |
	targets := Set new.
	sources := Set new.
	center := RTBox new
		size: 0;
		color: Color transparent;
		element.
	centerDragBox := RTBox new
		size: 10;
		color: Color transparent;
		element.
	TRConstraint stick: center onTheCenterOf: centerDragBox.
	centerDragBox
		@ RTDraggable;
		when: TRMouseDragEnd do: [ selfCentering := false ].
	block := [ :shape :step | self update ].
	transCallback := TRTranslationCallback block: block.
	extentCallback := TRExtentCallback block: block.
	self
		defaultCenteringBlock;
		selfCentering