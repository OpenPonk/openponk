menus for project
projectMenu
	| menu builder |
	menu := self instantiate: MenuModel.
	builder := self workbench
		ifNil: [ PragmaMenuBuilder cachedPragmaKeyword: #opProjectSubmenu model: self ]
		ifNotNil: [ OPPragmaPluginMenuBuilder cachedPragmaKeyword: #opProjectSubmenu model: self ].
	menu fromSpec: builder menuSpec.
	^ menu