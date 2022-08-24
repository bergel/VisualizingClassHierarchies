Class {
	#name : #MProject,
	#superclass : #MEntity,
	#instVars : [
		'entities',
		'packages'
	],
	#category : #'Mattia-Visualization'
}

{ #category : #initialization }
MProject >> addClass: aClass [
	entities add: aClass
]

{ #category : #'as yet unclassified' }
MProject >> buildRelation [
	| d aDictionary |
	d := Dictionary new.
	entities do: [ :entity |
		d at: entity name put: entity ].
	aDictionary := Dictionary new.
	entities do: [ :entity |
		entity superclass: (d at: entity superclassName ifAbsent: [ nil ]).
		entity incomingClassnames do: [ :cn |
			(d includesKey: cn) ifTrue: [ entity incomingClasses add: (d at: cn) ] ]. 
		entity outgoingClassnames do: [ :cn |
			(d includesKey: cn) ifTrue: [ entity outgoingClasses add: (d at: cn) ] ]. 
		aDictionary at: entity packageName
			ifPresent: [ :pkg | pkg addClass: entity ]
			ifAbsentPut: [ self newPackage: entity ]. 
	].
	
	self packages: aDictionary values.
	
	 
]

{ #category : #accessing }
MProject >> children [
	^ self packages
]

{ #category : #'as yet unclassified' }
MProject >> createClassFromJSON: json [
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
MProject >> createEntityFromJSON: json [
	| type |
	type := json at: #type.
	(type = 'class') ifTrue: [ ^ self createClassFromJSON: json ].
	^ nil
]

{ #category : #accessing }
MProject >> entities [
	^ entities
]

{ #category : #'importing-code' }
MProject >> importFromFilename: aFilename [
	"The provided filename should point to a json file"
	| json allEntities e reference |
	
	self assert: [ aFilename asFileReference exists ] description: 'Incorrect file name'.
	self assert: [ aFilename asFileReference extension = 'json' ] description: 'Incorrect file name'.
	reference := aFilename asFileReference.
	json := STONJSON fromString: reference contents.
	self name: reference basename.
	allEntities := json at: #entities.
	allEntities do: [ :entityAsJSON |
		e := self createEntityFromJSON: entityAsJSON.
		e ifNotNil: [ entities add: e ].
		 ].
	
	self buildRelation
	
]

{ #category : #initialization }
MProject >> initialize [
	super initialize.
	entities := OrderedCollection new
]

{ #category : #inspector }
MProject >> inspectorMetrics [
	<inspectorPresentationOrder: 90 title: 'Metrics'>
	^ (MMVisualization on: self) asPresenter.
]

{ #category : #inspector }
MProject >> inspectorMetricsContext: aContext [
	aContext withoutEvaluator
]

{ #category : #inspector }
MProject >> inspectorVisualization [
	<inspectorPresentationOrder: 90 title: 'Visualization'>
	^ SpRoassal3InspectorPresenter new
        canvas: self visualization;
        yourself
]

{ #category : #inspector }
MProject >> inspectorVisualizationContext: aContext [
	aContext withoutEvaluator
]

{ #category : #building }
MProject >> newPackage: aMClass [ 
	
	| packageName |
	packageName := aMClass packageName.
	^ packageName 
		ifNil: [ nil ]
		ifNotNil:  [ 
			MPackage new
				name: packageName;
				addClass: aMClass;
				yourself ].
]

{ #category : #initialization }
MProject >> numberOfClasses [
	^ entities size
]

{ #category : #accessing }
MProject >> packages [
	^ packages
]

{ #category : #accessing }
MProject >> packages: aCollection [ 
	packages := aCollection
]

{ #category : #visualization }
MProject >> visualization [

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
MProject >> visualizationMetrics [

	| c es visualEntities lb layoutBuilder legend |
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
		from: Color red; to: Color green;
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
	
	
	legend := RSLegend new.
	legend container: c.
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
			padding: 15 ].
	legend build.
	
	^ c
	
	
]
