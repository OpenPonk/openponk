rendering
showTextMorphFor: anElement
	super showTextMorphFor: anElement.
	rawEvents do: [ :pair | fieldArea announcer subscribe: pair key send: #value: to: pair value ]