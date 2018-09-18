retrieving
contextMenu: aMenuMorph for: aView
	aMenuMorph
		add: 'Open view'
		target: self
		selector: #openView:
		argument: aView.
	aMenuMorph
		add: 'Clone view ...'
		target: self
		selector: #copyView:
		argument: aView.
	aView isDefault
		ifFalse: [ aMenuMorph
				add: 'Remove view'
				target: self
				selector: #removeView:
				argument: aView ].
	^ aMenuMorph