visiting
visitBooleanDescription: aBooleanDescription
	(form addCheckbox: aBooleanDescription label)
		state: (aBooleanDescription accessor read: controller);
		whenChangedDo: [ :newValue | aBooleanDescription accessor write: newValue to: controller ]