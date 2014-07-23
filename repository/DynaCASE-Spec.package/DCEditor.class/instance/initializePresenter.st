initialization
initializePresenter
	roassalModel
		script: [ :view :canvas | 
			onAddElement := [ :element | 
			element @ RTDraggable.
			view add: element.
			view signalUpdate ] ]