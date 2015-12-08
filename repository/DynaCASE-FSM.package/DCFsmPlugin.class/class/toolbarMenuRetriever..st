toolbar
toolbarMenuRetriever: aBuilder
	<dcEditorToolbarMenu>
	aBuilder model plugin class = self
		ifFalse: [ ^ self ].
	self toolbarMenu: aBuilder