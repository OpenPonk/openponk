retrieving
contextMenu: aMenuMorph for: aView
	aMenuMorph
		add: 'Clone view ...'
		target: self
		selector: #copyView:
		argument: aView.
	^ aMenuMorph