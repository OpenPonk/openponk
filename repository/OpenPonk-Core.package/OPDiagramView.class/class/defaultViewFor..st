instance creation
defaultViewFor: aModel
	^ self new
		name: 'default';
		model: aModel;
		isOpen: false;
		isSelected: false