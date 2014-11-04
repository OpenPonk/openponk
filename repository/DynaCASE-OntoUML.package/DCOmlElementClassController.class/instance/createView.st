as yet unclassified
createView
	| class |
	class := DCRTClass new.
	class stereotype: self modelClass asString asLowercase.
	class name: self model name.
	self model nameHolder whenChangedDo: [ :newValue | class name: newValue ].
	class renderIn: self parent view.
	class element @ DCRTFocusable.
	^ class element