accessing
view: aView
	view := aView.
	model := DCSmState new.
	model name: view name text.
	self observe