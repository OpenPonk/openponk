selection handling
viewContextClicked: anEvent
	(OPPragmaPluginMenuBuilder cachedPragmaKeyword: #opCanvasContextMenu: model: self) menuSpec
		asMenuMorph popUpInWorld