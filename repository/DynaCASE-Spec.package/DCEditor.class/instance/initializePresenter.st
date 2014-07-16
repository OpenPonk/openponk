initialization
initializePresenter
	roassalModel
		script: [ :view :canvas | 
			paletteModel
				onAction: [ :element | 
					element @ RTDraggable.
					view add: element.
					view signalUpdate ] ]