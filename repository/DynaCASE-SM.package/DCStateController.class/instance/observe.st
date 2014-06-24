event handling
observe
	self view announcer when: DCVisualNodeChanged send: #viewChanged: to: self.
	self view announcer when: DCVisualNodeMoved send: #viewMoved: to: self.
	self model announcer when: DCModelChanged send: #modelChanged: to: self