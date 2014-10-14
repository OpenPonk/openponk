as yet unclassified
createView
	| class activation |
	class := DCRTClass new.
	class stereotype: self model stereotype.
	self model stereotypeHolder whenChangedDo: [ :newValue | class stereotype: newValue ].
	class name: self model name.
	self model nameHolder whenChangedDo: [ :newValue | class name: newValue ].
	class attributes: self model attributes.
	self model attributesHolder whenChangedDo: [ :newCollection | class attributes: newCollection ].
	class methods: self model methods.
	self model methodsHolder whenChangedDo: [ :newCollection | class methods: newCollection ].
	class renderIn: self parent view.
	class element @ (activation := DCRTActivableWithBoundingBox new).
	activation
		activateWhen: TRMouseEnter
			deactivateWhen: TRMouseLeave
			priority: 10
			value: Color gray;
		activateWhen: DCTRSelectedEvent
			deactivateWhen: DCTRUnselectedEvent
			priority: 20
			value: Color blue.
	^ class element