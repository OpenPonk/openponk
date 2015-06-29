private
retrieveMenuMapping
	^ menuMapping ifNil: [ menuMapping := self menuMapping asDictionary ]