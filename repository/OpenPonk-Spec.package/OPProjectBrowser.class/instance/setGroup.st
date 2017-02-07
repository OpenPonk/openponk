initialization
setGroup
	| group |
	group := RadioButtonGroup new.
	diagramOptions valuesDo: [ :each | group addRadioButton: each second ]