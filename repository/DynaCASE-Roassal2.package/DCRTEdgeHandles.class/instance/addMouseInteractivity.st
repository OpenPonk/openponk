hooks
addMouseInteractivity
	edge when: TRMouseRightClick do: [ :event | self addBendPointAt: event position ]