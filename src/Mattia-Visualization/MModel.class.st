Class {
	#name : #MModel,
	#superclass : #MObject,
	#instVars : [
		'entities'
	],
	#category : #'Mattia-Visualization'
}

{ #category : #initialization }
MModel >> addClass: aClass [
	entities add: aClass
]

{ #category : #'as yet unclassified' }
MModel >> buildRelation [
	| d |
	d := Dictionary new.
	entities do: [ :entity |
		d at: entity name put: entity ].
	
	entities do: [ :entity |
		entity superclass: (d at: entity superclassName ifAbsent: [ nil ]).
		entity incomingClassnames do: [ :cn |
			(d includesKey: cn) ifTrue: [ entity incomingClasses add: (d at: cn) ] ]. 
		entity outgoingClassnames do: [ :cn |
			(d includesKey: cn) ifTrue: [ entity outgoingClasses add: (d at: cn) ] ]. 
	].
	
	 
]

{ #category : #'as yet unclassified' }
MModel >> createClassFromJSON: json [
	| cls |
	cls := MClass new
					name: (json at: #name);
					superclassName: (json at: #extends).
	
	(json at: #Methods) do: [ :m | cls addMethod: MMethod new ].
	
	cls incomingClassnames: (json at: #uses).
	cls outgoingClassnames: (json at: #usedBy).
	
	^ cls

]

{ #category : #'as yet unclassified' }
MModel >> createEntityFromJSON: json [
	| type |
	type := json at: #type.
	(type = 'class') ifTrue: [ ^ self createClassFromJSON: json ].
	^ nil
]

{ #category : #'as yet unclassified' }
MModel >> importFromFilename: aFilename [
	"The provided filename should point to a json file"
	| json allEntities e |
	
	self assert: [ aFilename asFileReference exists ] description: 'Incorrect file name'.
	self assert: [ aFilename asFileReference extension = 'json' ] description: 'Incorrect file name'.
	
	json := STONJSON fromString: aFilename asFileReference contents.
	allEntities := json at: #entities.
	allEntities do: [ :entityAsJSON |
		e := self createEntityFromJSON: entityAsJSON.
		e ifNotNil: [ entities add: e ].
		 ].
	
	self buildRelation
	
]

{ #category : #initialization }
MModel >> initialize [
	super initialize.
	entities := OrderedCollection new
]

{ #category : #'as yet unclassified' }
MModel >> inspectorVisualization [
	<inspectorPresentationOrder: 90 title: 'Visualization'>
	^ SpRoassal3InspectorPresenter new
        canvas: self visualization;
        yourself
]

{ #category : #initialization }
MModel >> numberOfClasses [
	^ entities size
]

{ #category : #'as yet unclassified' }
MModel >> visualization [

	| m legend |
	m := RSMondrian new.
	m shape box size: #numberOfMethods.

	m nodes: (entities reverseSortedAs: #numberOfMethods).
	m normalizeColor: #numberOfMethods.

	m orthoVerticalLine connectFrom: #superclass.
	m layout ifConnected: (RSClusteringLayout new 
					    clustersLayout: RSFlowLayout new;
					    forEachLayout: RSTreeLayout new) ifNotConnected: RSFlowLayout new.

	m build.
	
	legend := RSLegend new.
	legend container: m canvas.
	legend text: 'Node = class'.
	legend text: 'Edge = Inheritance (superclass above subclasses)'.
	legend text: 'Size = number of methods'.
	legend text: 'Number of methods' withFadingRamp: { 0->'green'. 1->'red'}.
	legend onDemand: 'Legend'.
	legend legendDo: [ :s | 
		s
			draggable;
			border:(RSBorder new
				color: Color gray darker;
				dashArray: #(4));
			scaleBy: 0.75;
			padding: 15 ].
		
	legend build.
	^ m canvas
]
