hooks
createFigure
	| class |
	class := DCRTClass new.
	class stereotype: self model stereotype.
	self model stereotypeHolder whenChangedDo: [ :newValue | class stereotype: newValue ].
	class name: self model name.
	self model whenChanged: [ class name: self model name ].
	class attributes: self model attributes.
	self model attributesHolder whenChangedDo: [ :newCollection | class attributes: newCollection ].
	class methods: self model methods.
	self model methodsHolder whenChangedDo: [ :newCollection | class methods: newCollection ].
	class renderIn: self parent view.
	class element @ DCRTFocusable.
	^ class element