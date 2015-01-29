hooks
createFigure
	| class |
	^ DCRTCallbackBuilder
		block: [ :view | 
			class := DCRTClass new.
			class stereotype: self modelClass asString asLowercase.
			class attributes: self model attributes.
			class methods: self model methods.
			class renderIn: view.
			class element @ DCRTFocusable.
			class element ]