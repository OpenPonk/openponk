hooks
createFigure
	| class |
	^ DCRTCallbackBuilder
		block: [ :view | 
			class := DCRTClass new.
			class stereotype: self modelClass asString asLowercase.
			class renderIn: view.
			class element @ DCRTFocusable.
			class element ]