opening
closeEditorOf: aModel
	editors at: aModel ifPresent: [ :pair | tabManager removeTab: pair second ]