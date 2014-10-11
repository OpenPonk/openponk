as yet unclassified
createView
	| class |
	class := DCRTClass new.
	class name: self model name.
	self model nameHolder whenChangedDo: [ :newValue | class name: newValue ].
	class attributes: self model attributes.
	self model attributesHolder whenChangedDo: [ :newCollection | class attributes: newCollection ].
	class renderIn: self parent view.
	^ class element