initialization
initializePresenter
	roassalModel
		script: [ :view :canvas | 
			roassalView := view.
			view
				on: TRMouseLeftClick
				do: [ :event | self viewClicked: event ] ]