initialization
initializeWidgets
	inputLabel := self newLabel.
	input := self newTextInput.

	startButton := self newButton.
	stopButton := self newButton.
	resetButton := self newButton.

	letterPanel := DCFsmLetterPanel new asSpecAdapter.

	backButton := self newButton.
	nextButton := self newButton