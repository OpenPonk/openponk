initialization
initialize
	super initialize.
	self
		layoutPolicy: StackLayout new;
		cellPositioning: #center;
		cellInset: 5