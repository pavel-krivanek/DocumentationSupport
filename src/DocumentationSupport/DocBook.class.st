"
A collection of chapters. Books cannot be nested.
"
Class {
	#name : #DocBook,
	#superclass : #DocModelWithKey,
	#instVars : [
		'chapters'
	],
	#category : #'DocumentationSupport-Model'
}

{ #category : #'drag and drop' }
DocBook >> acceptChapter: aChapter [ 

	aChapter library = self library ifFalse: [ ^ self ].

	(self hasSubchapter: aChapter) ifTrue: [ 
		aChapter parent: self.
		library aspectChanged: #chapters.
		^ self ].
	
	"from antother book"
	aChapter withAllSubchapters do: [ :each |
		self takeChapter: each ].
	
	aChapter parent: self.
	
	library aspectChanged: #chapters.

]

{ #category : #visiting }
DocBook >> acceptVisitor: aVisitor [ 

	aVisitor visitBook: self
]

{ #category : #adding }
DocBook >> addChapter: aChapter [ 

	self makeDirty.
	aChapter parent: self.
	chapters add: aChapter.
	^ aChapter

]

{ #category : #adding }
DocBook >> addNewChapter [

	| newChapter |
	
	newChapter := self addNewChapterWithoutNotification.
	library aspectChanged: #chapters.
	^ newChapter
]

{ #category : #adding }
DocBook >> addNewChapterWithoutNotification [

	| newChapter |
	
	newChapter := DocChapter new.
	newChapter library: self library.
	self addChapter: newChapter.
	^ newChapter
]

{ #category : #accessing }
DocBook >> book [ 

	^ self
]

{ #category : #accessing }
DocBook >> chapterOfKey: aKey [ 

	^ chapters detect: [ :each | each key = aKey ] ifNone: [ nil ].
]

{ #category : #accessing }
DocBook >> chapters [ 

	^ chapters
]

{ #category : #accessing }
DocBook >> chapters: anObject [

	chapters := anObject
]

{ #category : #accessing }
DocBook >> children [ 

	^ self sortedChapters: (chapters select: [ :each | each parent = self ])
]

{ #category : #removing }
DocBook >> delete [ 

	self library deleteBook: self.
	self makeDirty.
	library aspectChanged: #chapters.


]

{ #category : #removing }
DocBook >> deleteChapter: aChapter [ 

	aChapter subchapters do: [ :each | 
		self deleteChapter: each ].

	chapters remove: aChapter.
	chapters do: [ :each | 
		each chapterRemoved: aChapter ].
	library aspectChanged: #chapters.

	

]

{ #category : #'serialization support' }
DocBook >> fixParentReferencesUsing: aDictionary [

	self chapters do: [ :each |
		each fixParentReferencesUsing: aDictionary ].

	parent ifNil: [ ^ self ].
	parent isParentReference ifFalse: [ ^ self ].
	
	parent := parent key 
		ifNil: [ nil ]
		ifNotNil: [ aDictionary at: parent key ]
]

{ #category : #accessing }
DocBook >> hasSubchapter: aChapter [

	^ chapters includes: aChapter
]

{ #category : #initialization }
DocBook >> initialize [ 

	super initialize.
	
	chapters := OrderedCollection new.
]

{ #category : #accessing }
DocBook >> setLibrary: aLibrary [ 

	super setLibrary: aLibrary.
	chapters do: [ :each | each setLibrary: aLibrary ].
]

{ #category : #adding }
DocBook >> takeChapter: aChapter [ 

	"change ownership"

	aChapter book chapters remove: aChapter.
	self chapters add: aChapter 
]
