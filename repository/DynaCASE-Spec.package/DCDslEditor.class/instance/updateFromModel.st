event handling
updateFromModel
	| text |
	model ifNil: [ ^ self ].
	text := (self exporter export: model) asText.
	editor text: text