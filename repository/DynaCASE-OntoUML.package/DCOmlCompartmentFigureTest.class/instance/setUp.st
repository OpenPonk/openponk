running
setUp
	super setUp.
	view := RTView new.
	figure := DCOmlCompartmentFigure new.
	figure layout gapSize: 0.
	figure padding: 0 @ 0