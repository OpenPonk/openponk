opening
closeEditorOfModel: aModel
	editors
		at: aModel
		ifPresent: [ :pair | 
			tabManager removeTab: pair second.
			self announce: (OPEditorClosed on: pair first) ]