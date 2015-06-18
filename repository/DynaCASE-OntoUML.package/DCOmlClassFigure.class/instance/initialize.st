initialization
initialize
	super initialize.

	stereotype := nil.
	name := self newLabelFigure.
	attributes := self newCompartmentFigure.
	operations := self newCompartmentFigure.

	self
		add: name;
		add: attributes;
		add: operations.

	self background @ RTDraggable