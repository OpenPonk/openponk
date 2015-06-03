building widgets
alignButtons
	"align content of all buttons to left"

	items do: [ :each | each widget ifNotNil: [ each widget widgetDo: [ :w | w wrapCentering: #topLeft ] ] ]