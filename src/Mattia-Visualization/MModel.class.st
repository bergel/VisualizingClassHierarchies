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
	| cls m |
	cls := MClass new
					name: (json at: #name);
					superclassName: (json at: #extends).
	
	(json at: #Methods) do: [ :mJson | 
		m := MMethod new.
		m signature: (mJson at: #signature).
		m documentation: (mJson at: #documentation).
		(mJson includesKey: #code) ifTrue: 
			[m sourceCode: (mJson at: #code)].
		cls addMethod: m ].
	
	cls incomingClassnames: (json at: #uses).
	cls outgoingClassnames: (json at: #usedBy).
	
	cls documentation: (json at: #documentation).
	cls metrics at: #anyj put: (json at: #anyj).
	cls metrics at: #dir put: (json at: #dir).
	cls metrics at: #anyc put: (json at: #anyc).
	cls metrics at: #wjpd put: (json at: #wjpd).
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

{ #category : #inspector }
MModel >> inspectorMetrics [
	<inspectorPresentationOrder: 90 title: 'Metrics'>
	^ SpRoassal3InspectorPresenter new
        canvas: self visualizationMetrics;
        yourself
]

{ #category : #inspector }
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

{ #category : #visualization }
MModel >> visualization [

	| legend c es visualEntities lb layoutBuilder |
	c := RSCanvas new.
	es := entities reverseSortedAs: #numberOfMethods.
	visualEntities := es collect: #asShape as: RSGroup.
	c addAll: visualEntities.
		
	lb := RSLineBuilder orthoVertical.
	lb canvas: c.
	lb withVerticalAttachPoint.
	lb shapes: visualEntities.
	lb connectFrom: #superclass.
	
	layoutBuilder := RSLayoutBuilder new.
	layoutBuilder
		ifConnected: (RSClusteringLayout new 
					    clustersLayout: RSFlowLayout new;
					    forEachLayout: RSTreeLayout new) 
		ifNotConnected: RSFlowLayout new.
	layoutBuilder on: visualEntities.
	
	visualEntities @ RSPopup new makeLocateAboveMouseCursor.
	c @ RSCanvasController.
	
	
	legend := RSLegend new.
	legend container: c.
	legend text: 'Node = class'.
	legend text: 'Edge = Inheritance (superclass above subclasses)'.
	legend text: 'Each class has three parts (Fan-in cls, number of methods, Fan-out cls)'.
	legend text: 'No comment (class and methods)' withBoxColor: Color red.
	legend text: 'Class or at least one method have comment' withBoxColor: Color orange.
	legend text: 'Class has comment and at least one method has comment' withBoxColor: Color green.
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
	
	^ c
	
	
"	m := RSMondrian new.
	m shape box size: #numberOfMethods.

	m shape box
		labeled: [ :e | e ratioOfDocumentedMethodsAsString ].
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
	^ m canvas"
]

{ #category : #visualization }
MModel >> visualizationMetrics [

	| c es visualEntities lb layoutBuilder |
	c := RSCanvas new.
	es := entities reverseSortedAs: #numberOfMethods.
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
		normalize: [ :cls | cls metrics at: #anyc ].		
"
	RSNormalizer color
		shapes: visualEntities;
		normalize: [ :cls | cls metrics at: #wjpd ].	
"	
	
	lb := RSLineBuilder orthoVertical.
	lb canvas: c.
	lb withVerticalAttachPoint.
	lb shapes: visualEntities.
	lb connectFrom: #superclass.
	

	layoutBuilder := RSLayoutBuilder new.
	layoutBuilder
		ifConnected: (RSClusteringLayout new 
					    clustersLayout: RSFlowLayout new;
					    forEachLayout: RSTreeLayout new) 
		ifNotConnected: RSFlowLayout new.
	layoutBuilder on: visualEntities.
	
	visualEntities @ RSPopup new makeLocateAboveMouseCursor.
	c @ RSCanvasController.
	
	
"	legend := RSLegend new.
	legend container: c.
	legend text: 'Node = class'.
	legend text: 'Edge = Inheritance (superclass above subclasses)'.
	legend text: 'Each class has three parts (Fan-in cls, number of methods, Fan-out cls)'.
	legend text: 'No comment (class and methods)' withBoxColor: Color red.
	legend text: 'Class or at least one method have comment' withBoxColor: Color orange.
	legend text: 'Class has comment and at least one method has comment' withBoxColor: Color green.
	legend onDemand: 'Legend'.
	legend legendDo: [ :s | 
		s
			draggable;
			border:(RSBorder new
				color: Color gray darker;
				dashArray: #(4));
			scaleBy: 0.75;
			padding: 15 ].
	legend build."
	
	^ c
	
	
]
