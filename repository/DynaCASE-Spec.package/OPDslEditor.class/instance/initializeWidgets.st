initialization
initializeWidgets
	toolbar := self instantiate: MenuModel.
	self buildToolbar: toolbar.
	toolbar applyTo: self.
	(editor := self newText)
		isCodeCompletionAllowed: true;
		whenBuiltDo: [ :w | w widget withLineNumbers ].
	(autoUpdate := self newButton)
		label: 'Refresh from Model';
		action: [ self updateFromModel ].
	self focusOrder
		add: editor;
		add: autoUpdate