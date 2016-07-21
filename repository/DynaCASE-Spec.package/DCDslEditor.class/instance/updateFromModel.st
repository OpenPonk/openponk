event handling
updateFromModel
	| text |
	model ifNil: [ ^ self ].
	text := (self exporter export: model) asText.
	self highlight: text.
	editor text: text