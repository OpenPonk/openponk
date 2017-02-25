menus for project
projectMenu
	| menu builder |
	menu := self instantiate: MenuModel.
	builder := self workbench
		ifNil: [ PragmaMenuBuilder pragmaKeyword: #opProjectSubmenu model: self ]
		ifNotNil:
			[ OPPragmaPluginMenuBuilder pragmaMultiKeyword: #opProjectSubmenu model: self ].
	menu fromSpec: builder menuSpec.
	^ menu