DCStarAssociationBuilder is handler for visualisation of association between multiple elements, connected with 'star topology'.

Elements are either targets or sources. Lines are pointing from sources to center and from center to targets.

Position of center is static or dynamic (based on targets and/or sources). Static = #center:, dynamic is turned on by #dynamicCentering, computing position based on block set by #dynamicCenteringBlock: or #defaultCenteringBlock.

When element is added, there is is created line between it and center using sourcesEdgeBuilder and tragetsEdgeBuilder blocks.

See example on class side to get idea how such blocks could look