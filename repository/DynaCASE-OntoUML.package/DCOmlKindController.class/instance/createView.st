hooks
createView
	| class |
	class := DCRTClass new.
	class stereotype: 'kind'.
	class name: self model name.
	self model nameHolder whenChangedDo: [ :newValue | class name: newValue ].
	class renderIn: self parent view.
	class element @ DCRTFocusable.
	^ class element