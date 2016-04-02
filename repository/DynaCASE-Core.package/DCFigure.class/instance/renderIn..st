rendering
renderIn: aView
	view := aView.
	self figures do: [ :each | each renderIn: view ].
	background model: self.
	self update.
	self figures do: [ :each | each pushFront ]