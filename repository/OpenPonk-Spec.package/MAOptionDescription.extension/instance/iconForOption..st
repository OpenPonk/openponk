*OpenPonk-Spec
iconForOption: anObject
	self
		propertyAt: #icons
		ifPresent: [ :icons | icons at: anObject ifPresent: [ :value | ^ value ] ].
	^ nil