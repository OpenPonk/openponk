accessing
caption
	caption ifNil:[caption := (DCVisualText new)text: 'Caption'.
		].
	^caption 