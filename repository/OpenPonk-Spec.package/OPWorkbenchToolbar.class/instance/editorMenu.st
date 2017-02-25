menus for editor
editorMenu
	| menu |
	menu := self instantiate: MenuModel.
	menu
		fromSpec: (PragmaMenuBuilder pragmaKeyword: #opEditorToolbarMenu model: activeEditor) menuSpec.
	menu
		fromSpec:
			(OPPragmaPluginMenuBuilder pragmaKeyword: #opEditorToolbarMenu: model: activeEditor)
				menuSpec.
	^ menu