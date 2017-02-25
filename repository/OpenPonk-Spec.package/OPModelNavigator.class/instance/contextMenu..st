private
contextMenu: menu
	| builder |
	tree hasSelectedItem
		ifFalse: [ ^ self ].
	builder := OPPragmaPluginMenuBuilder
		pragmaMultiKeyword: #opModelNavigatorContextMenu
		model: self.
	menu fromSpec: builder menuSpec