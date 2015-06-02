removing
removeParent: aNameString
	generalizationSets do: [ :each |
		each remove: aNameString child: self name
		 ] 