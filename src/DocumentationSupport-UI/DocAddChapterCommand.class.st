"
A command to add a chapter to a book or another chapter used in the toolbar.
"
Class {
	#name : #DocAddChapterCommand,
	#superclass : #DocStCommand,
	#category : #'DocumentationSupport-UI-Commands'
}

{ #category : #default }
DocAddChapterCommand class >> defaultDescription [

	^ 'Add a new chapter'
]

{ #category : #default }
DocAddChapterCommand class >> defaultIconName [

	^ #glamorousAdd
]

{ #category : #default }
DocAddChapterCommand class >> defaultName [

	^ 'Add chapter'
]

{ #category : #accessing }
DocAddChapterCommand class >> priority [ 

	^ 200
]

{ #category : #executing }
DocAddChapterCommand >> execute [ 

	context addNewChapter 
]
