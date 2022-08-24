Class {
	#name : #MMVisualization,
	#superclass : #SpPresenter,
	#instVars : [
		'roassalCanvas',
		'project',
		'treeSource'
	],
	#category : #'Mattia-Visualization'
}

{ #category : #layout }
MMVisualization class >> defaultLayout [
	^ SpPanedLayout newLeftToRight
		add: #treeSource;
		add: #roassalCanvas;
		positionOfSlider: 0.3;
		yourself
]

{ #category : #initialization }
MMVisualization >> initializePresenter [
	super initializePresenter.
	treeSource := self newTreeTable.
	self initializeTree.
	roassalCanvas := self instantiate: SpRoassal3InspectorPresenter.
	roassalCanvas canvas: self visualization.
	treeSource outputActivationPort transmitTo: roassalCanvas defaultInputPort
]

{ #category : #initialization }
MMVisualization >> initializeTree [

	treeSource
		addColumn: (SpCompositeTableColumn new
			title: 'Classes';
			addColumn: ((SpImageTableColumn evaluated: #systemIcon)
				width: 20;
				yourself);
			addColumn: (SpStringTableColumn evaluated: #name);
			yourself);
		expandAll;
		children: [ :node | node children ];
		roots:  {project}.
]

{ #category : #initialization }
MMVisualization >> renderLegendOn: canvas [
	| legend |
	legend := RSLegend new.
	legend container: canvas.
	legend text: 'Node = class'.
	legend text: 'Edge = Inheritance (superclass above subclasses)'.
	legend polymetricWidth: 'ANY_J metric' height: 'DIR metric' box: 'ANY_C metric'.
	legend onDemand: 'Legend'.
	legend legendDo: [ :s | 
		s
			draggable;
			border:(RSBorder new
				color: Color gray darker;
				dashArray: #(4));
			scaleBy: 0.75;
			color: (Color white alpha: 0.95);
			padding: 15 ].
	legend build.
]

{ #category : #initialization }
MMVisualization >> renderLinesOn: aCanvas [
	| marker size |
	size := 10.
	marker := RSShapeFactory arrow.
	marker size: size.
	RSLineBuilder orthoVertical
		attachPoint: (RSVerticalAttachPoint new
			startOffset: size / 2;
			yourself);
		shapes: aCanvas nodes;
		markerStart: marker;
		color: Color black;
		connectFrom: #superclass.
]

{ #category : #initialization }
MMVisualization >> setModelBeforeInitialization: anObject [
	project := anObject
]

{ #category : #initialization }
MMVisualization >> visualization [
	| c es visualEntities layoutBuilder |
	c := RSCanvas new.
	es := project entities reverseSortedAs: #numberOfMethods.
	visualEntities := RSBox models: es.
	c addAll: visualEntities.
		
	RSNormalizer width
		shapes: visualEntities;
		normalize: [ :cls | cls metrics at: #anyj ].
	RSNormalizer height
		shapes: visualEntities;
		normalize: [ :cls | cls metrics at: #dir ].		
	RSNormalizer color
		shapes: visualEntities;
		from: Color red; to: Color green;
		normalize: [ :cls | cls metrics at: #anyc ].
	
	self renderLinesOn: c.
	
	layoutBuilder := RSLayoutBuilder new.
	layoutBuilder
		ifConnected: (RSClusteringLayout new 
					    clustersLayout: RSFlowLayout new;
					    forEachLayout: RSTreeLayout new) 
		ifNotConnected: RSFlowLayout new.
	layoutBuilder on: visualEntities.
	
	visualEntities @ RSPopup new makeLocateAboveMouseCursor.
	c @ RSCanvasController simple.

	self renderLegendOn: c.
	
	^ c
	
	
]
