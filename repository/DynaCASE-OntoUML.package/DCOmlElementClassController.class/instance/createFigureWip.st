hooks
createFigureWip
	^ DCRTCallbackBuilder
		block: [ :view | 
			| fig |
			fig := DCOmlClassFigure new.
			fig stereotype: self modelClass asString asLowercase.
			fig name: self model name.
			fig attributes: self model attributes asStringWithCr.
			fig operations: self model methods asStringWithCr.
			fig renderIn: view.
			fig background ]