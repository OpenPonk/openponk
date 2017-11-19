shortcuts
unregisterShortcutsOn: aPresenter
	shortcuts
		ifNotNil: [ shortcuts do: [ :pair | aPresenter removeKeyCombination: pair key ] ]