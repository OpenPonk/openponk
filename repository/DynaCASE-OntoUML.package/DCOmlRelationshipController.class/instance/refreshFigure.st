hooks
refreshFigure
	self
		figureLabel: #name text: (self convertName: self model name);
		figureLabel: #sourceMultiplicity text: self model startMultiplicity;
		figureLabel: #targetMultiplicity text: self model endMultiplicity.
	super refreshFigure