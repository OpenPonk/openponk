menus
editorMenu
	| menu |
	menu := self instantiate: MenuModel.
	menu
		fromSpec: (PragmaMenuBuilder pragmaKeyword: #dcEditorToolbarMenu model: activeEditor) menuSpec.
	menu
		fromSpec:
			(OPPragmaPluginMenuBuilder pragmaKeyword: #dcEditorToolbarMenu: model: activeEditor)
				menuSpec.
	^ menu