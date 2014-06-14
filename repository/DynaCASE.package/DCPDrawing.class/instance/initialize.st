as yet unclassified
initialize

	super initialize.
	content := LinkedList new.
	self hResizing: #spaceFill; vResizing: #spaceFill.
	surface := AthensCairoSurface extent: 1000@800.
	surface drawDuring: [:canvas | surface clear: Color white. ].