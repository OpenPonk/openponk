private
addItem
	| item |
	item := self newButton.
	items add: item.
	^ item