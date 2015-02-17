rendering
updateFor: edge trachelShape: trachelShape
	line updateFor: edge trachelShape: edge trachelShape shapes first.
	head ifNotNil: [ head updateFor: edge trachelShape: edge trachelShape shapes second ].
	tail ifNotNil: [ tail updateFor: edge trachelShape: edge trachelShape shapes third ]