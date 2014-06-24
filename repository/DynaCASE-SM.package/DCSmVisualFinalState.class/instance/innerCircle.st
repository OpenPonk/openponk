as yet unclassified
innerCircle
innerCircle ifNil: [ innerCircle := (DCVisualCircle new) radius: ((self borderCircle radius)*0.8); fillColor: (Color black) .].
^innerCircle 