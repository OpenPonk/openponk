selection handling
viewContextClicked: anEvent
	(OPPragmaPluginMenuBuilder pragmaKeyword: #opCanvasContextMenu: model: self) menuSpec
		asMenuMorph popUpInWorld