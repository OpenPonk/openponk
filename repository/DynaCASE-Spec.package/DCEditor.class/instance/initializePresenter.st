initialization
initializePresenter
	roassalModel
		script: [ :view :canvas | 
			roassalView := view.
			view
				on: TRMouseLeftClick
				do: [ :event | self viewClicked: event ].	"TODO: why is when:send:to: not working?"
			onAddElement := [ :element | 
			element @ RTDraggable.
			view add: element.
			view signalUpdate ] ]