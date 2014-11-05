as yet unclassified
createFigure
	| class |
	^ DCRTCallbackBuilder
		block: [ :view | 
			class := DCRTClass new.
			class stereotype: self modelClass asString asLowercase.
			class name: self model name.
			self model nameHolder whenChangedDo: [ :newValue | class name: newValue ].
			class renderIn: view.
			class element @ DCRTFocusable.
			class element ]