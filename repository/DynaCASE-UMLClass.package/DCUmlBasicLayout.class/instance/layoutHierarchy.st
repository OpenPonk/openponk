private - layout
layoutHierarchy
	| els edges |
	els := self collectClassFigures.
	edges := self collectGeneralizationFigures.
	RTSugiyamaLayout new
		verticalGap: 100;
		horizontalGap: 100;
		on: els edges: edges.
	self updateView