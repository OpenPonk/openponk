actions
attachToMouseOn: position
	target = mouseBox
		ifTrue: [ 
			mouseBox
				translateTo: position - (diagramController view canvas extent / 2) + diagramController view canvas camera position.
			diagramController updateView ]
		ifFalse: [ 
			self running
				ifTrue: [ self cancel ].
			target := mouseBox.
			diagramController view add: mouseBox.
			diagramController view
				when: TRMouseMove
				do: [ :evt | 
					mouseBox
						translateTo:
							evt position - (diagramController view canvas extent / 2) + diagramController view canvas camera position.
					diagramController updateView ].
			diagramController controllers
				do: [ :ctrl | ctrl view when: TRMouseMove do: [ :evt | ctrl attachInteractiveLine: self byEvent: evt ] ].
			line := lineType edgeFrom: (diagramController findControllerByView: source) view to: mouseBox.
			line shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
			diagramController view add: line.
			diagramController updateView.
			running := true ]