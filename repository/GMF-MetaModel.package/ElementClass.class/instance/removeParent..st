removing
removeParent: aNameString
	| removed |
	removed := OrderedCollection new.
	generalizationSets do: [ :each | removed add: (each remove: aNameString child: self name) ].
	^ removed