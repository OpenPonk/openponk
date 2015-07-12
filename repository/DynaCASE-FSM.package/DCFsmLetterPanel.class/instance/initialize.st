initialization
initialize
	super initialize.
	self
		layoutPolicy: RowLayout new;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		cellInset: 5