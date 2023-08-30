"
Editor of documentation book properties.
"
Class {
	#name : #DocBookPresenter,
	#superclass : #DocModelPresenter,
	#instVars : [
		'book',
		'titleInput',
		'keyInput',
		'parent'
	],
	#category : #'DocumentationSupport-UI-Presenters'
}

{ #category : #specs }
DocBookPresenter class >> defaultLayout [

	^ SpGridLayout new
		beColumnNotHomogeneous;
		add: 'Name:' at: 1 @ 1;
		add: #titleInput at: 2 @ 1 span: 4@1;
		add: 'Key:' at: 1 @ 2;
		add: #keyInput at: 2 @ 2 span: 4@1;
		yourself
]

{ #category : #'instance creation' }
DocBookPresenter class >> on: aBook [ 

	^ self basicNew 
		book: aBook;
		initialize
]

{ #category : #'instance creation' }
DocBookPresenter class >> on: aBook application: anApplication [

	^ self basicNew 
		application: anApplication;
		book: aBook;
		initialize
]

{ #category : #actions }
DocBookPresenter >> aspect: anAspect changedFrom: anOrigin [

	anOrigin = self ifTrue: [ ^ self ].
	
	anAspect = #title ifTrue: [ titleInput text: book title. ].
	anAspect = #key ifTrue: [ keyInput text: book key. ].

]

{ #category : #accessing }
DocBookPresenter >> book [

	^ book
]

{ #category : #accessing }
DocBookPresenter >> book: anObject [

	book := anObject
]

{ #category : #initialization }
DocBookPresenter >> initializePresenters [ 

	titleInput := self newTextInput.
	titleInput text: self book title.
	titleInput whenTextChangedDo: [ :aText | self book title: aText ].
	
	keyInput := self newTextInput.
	keyInput enabled: false.
	keyInput text: self book key.
	
	book whenAspectChangedNotify: self 

]

{ #category : #accessing }
DocBookPresenter >> parent [

	^ parent
]

{ #category : #accessing }
DocBookPresenter >> parent: anObject [

	parent := anObject
]
