private
retrieveChildrenMapping
	^ childrenMapping ifNil: [ childrenMapping := self childrenMapping asDictionary ]