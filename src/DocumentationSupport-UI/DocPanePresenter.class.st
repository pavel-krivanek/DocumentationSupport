"
A presenter that allows to contain chapter or book presenters. Accepts `object:` from the Spec transmission.
"
Class {
	#name : #DocPanePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'child',
		'parent'
	],
	#category : #'DocumentationSupport-UI-Presenters'
}

{ #category : #layout }
DocPanePresenter class >> defaultLayout [

	^ SpBoxLayout newVertical 
		add: #child;
		yourself
]

{ #category : #transmission }
DocPanePresenter >> defaultInputPort [

	^ self inputModelPort
]

{ #category : #initialization }
DocPanePresenter >> initializePresenters [ 

	child := self newLabel 
]

{ #category : #transmission }
DocPanePresenter >> inputModelPort [

	^ DocObjectPort newPresenter: self
]

{ #category : #transmission }
DocPanePresenter >> object: anObject [ 

	| parentLayout |
	
	self layout ifNil: [ ^ self ].
	
	parentLayout := self layout parentLayoutOf: #child.

	parentLayout
		remove: child 
		ifAbsent: [ ].
	parentLayout announceChildRemoved: child.
	
	child := anObject
		ifNil: [ 
			self newLabel ]
		ifNotNil: [ 
			(anObject asPresenterIn: self application)
				parent: parent
				yourself ].
	
	parentLayout add: child.

	

]

{ #category : #accessing }
DocPanePresenter >> parent [

	^ parent
]

{ #category : #accessing }
DocPanePresenter >> parent: anObject [

	parent := anObject
]
