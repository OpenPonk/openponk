initialization
initializePresenter
	super initializePresenter.
	editor whenTextIsAccepted: [ self textUpdated: editor text ]