instance creation
from: aSource to: aTarget named: aString
	^ self new
		source: aSource;
		target: aTarget;
		name: aString;
		yourself