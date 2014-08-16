as yet unclassified
reloadView
	diagramController view: roassalView.
	diagramController rebuild	"
	diagramController controllers do: [ :each | roassalView add: each createView ].
	selectedItem
		ifNotNil: [ 
			element := selectedItem createElement.
			selectedItem button state: false.
			selectedItem := nil.
			element translateTo: anEvent position.
			element @ RTDraggable.
			element
				on: TRMouseLeftClick
				do: [ :event | self elementClicked: event ].
			roassalView add: element.
			roassalView signalUpdate ]"