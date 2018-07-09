menus for editor
editorMenu
	| menu |
	menu := self instantiate: MenuModel.
	menu
		fromSpec: (PragmaMenuBuilder cachedPragmaKeyword: #opEditorToolbarMenu model: activeEditor) menuSpec.
	menu
		fromSpec:
			(OPPragmaPluginMenuBuilder cachedPragmaKeyword: #opEditorToolbarMenu: model: activeEditor)
				menuSpec.
	"MenuModel is stupid and will crash when provided with an empty subMenu"
	menu menuGroups ifEmpty: [ ^nil ].
	^ menu