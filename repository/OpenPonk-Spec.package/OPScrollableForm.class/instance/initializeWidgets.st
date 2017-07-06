initialization
initializeWidgets
	form := self instantiate: OPDynamicForm.
	scrollPane := (self newScrollPaneFor: form) asSpecAdapter