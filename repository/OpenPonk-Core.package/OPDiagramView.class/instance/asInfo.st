converting
asInfo
	^ OPDiagramViewInfo new
		modelType: self modelType;
		modelName: self modelName;
		modelVersion: self modelVersion;
		viewName: self name;
		isOpen: self isOpen;
		isSelected: self isSelected;
		order: self order;
		yourself