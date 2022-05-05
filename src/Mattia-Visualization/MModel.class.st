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
		entity superclass: (d at: entity superclassName ifAbsent: [nil])] 
]

{ #category : #'as yet unclassified' }
MModel >> createClassFromJSON: json [
	| cls |
	cls := MClass new
					name: (json at: #name);
					superclassName: (json at: #extends).
	
	(json at: #Methods) do: [ :m | cls addMethod: MMethod new ].
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
	| json allEntities e |
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

{ #category : #initialization }
MModel >> numberOfClasses [
	^ entities size
]
