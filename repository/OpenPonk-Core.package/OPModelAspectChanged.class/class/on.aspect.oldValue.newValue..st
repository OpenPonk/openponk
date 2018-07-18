instance creation
on: aModel aspect: anAspect oldValue: anOldValue newValue: aNewValue
	^ self new
		model: aModel;
		aspect: anAspect;
		oldValue: anOldValue;
		newValue: aNewValue;
		yourself