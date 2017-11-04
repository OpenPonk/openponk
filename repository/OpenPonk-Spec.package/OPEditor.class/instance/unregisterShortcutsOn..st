shortcuts
unregisterShortcutsOn: aPresenter
	shortcuts do: [ :pair | aPresenter removeKeyCombination: pair key ]