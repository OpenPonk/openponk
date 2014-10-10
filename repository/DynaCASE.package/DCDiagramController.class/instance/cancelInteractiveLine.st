interaction
cancelInteractiveLine
	self view announcer unsubscribe: self.
	self controllers do: [ :ctrl | ctrl cancelInteractiveLine ]