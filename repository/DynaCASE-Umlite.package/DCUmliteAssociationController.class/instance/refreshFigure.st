hooks
refreshFigure
	self
		figureLabel: #name text: (self convertName: self model name);
		figureLabel: #sourceMultiplicity text: self model sourceName;
		figureLabel: #targetMultiplicity text: self model targetName.
	super refreshFigure