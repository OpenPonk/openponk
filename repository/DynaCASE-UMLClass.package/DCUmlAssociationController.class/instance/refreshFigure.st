figures
refreshFigure
	self
		figureLabel: #name text: self model name;
		figureLabel: #sourceName text: self model sourceName;
		figureLabel: #sourceMultiplicity text: self model sourceMultiplicity;
		figureLabel: #targetName text: self model targetName;
		figureLabel: #targetMultiplicity text: self model targetMultiplicity.
	super refreshFigure