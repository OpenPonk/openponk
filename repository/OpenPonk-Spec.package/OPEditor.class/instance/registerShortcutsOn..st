shortcuts
registerShortcutsOn: aPresenter
	shortcuts := self collectShortcuts.
	shortcuts do: [ :each | aPresenter bindKeyCombination: each key toAction: each value ]