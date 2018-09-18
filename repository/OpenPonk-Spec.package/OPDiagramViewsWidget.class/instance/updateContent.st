actions
updateContent
	| views |
	views := self viewsIn: project.
	list items: views.
	views detect: #isSelected ifFound: [ :view | list setSelectedItem: view ]