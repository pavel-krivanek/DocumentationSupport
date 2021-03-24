"
I perform loading of serialized document libraries.
"
Class {
	#name : #DocMaterializerMicrodown,
	#superclass : #Object,
	#instVars : [
		'keysDictionary'
	],
	#category : #'DocumentationSupport-Serialization'
}

{ #category : #initialization }
DocMaterializerMicrodown >> initialize [ 

	super initialize.
	
	keysDictionary := Dictionary new.
]

{ #category : #materialization }
DocMaterializerMicrodown >> readBookFrom: bookDirectory [ 

	| aBook |
	aBook := (bookDirectory / 'description', 'md') readStreamDo: [ :stream | 
		DocBook new  materializeFrom: stream ].
	aBook chapters: (self readChaptersFrom: bookDirectory) asOrderedCollection.
	self register: aBook as: aBook key.
	^ aBook
]

{ #category : #materialization }
DocMaterializerMicrodown >> readBooksFrom: bookDirectory [

	^ bookDirectory directories collect: [ :dir |
		self readBookFrom: dir]
]

{ #category : #materialization }
DocMaterializerMicrodown >> readChaptersFrom: bookDirectory [ 

	| chapterFiles |
	
	chapterFiles := bookDirectory files reject: [ :file | file basename = 'description.md' ].
	^ chapterFiles collect: [ :each | 
		| aChapter |
		aChapter := DocChapter new.
		aChapter materializeFrom: each readStream.
		self register: aChapter as: aChapter key.
		aChapter ]
]

{ #category : #materialization }
DocMaterializerMicrodown >> readLibrariesFrom: directoryFileReference [

	^ directoryFileReference directories collect: [ :dir |
		self readLibraryFrom: dir]
]

{ #category : #materialization }
DocMaterializerMicrodown >> readLibraryFrom: libraryDirectory [ 
	| library | 
	
	library := DocLibrary new.
	library name: libraryDirectory basename.
	library books: (self readBooksFrom: libraryDirectory) asOrderedCollection.
	library fixParentReferencesUsing: keysDictionary.
	library books do: [ :each | each setLibrary: library ].
	
	^ library
]

{ #category : #private }
DocMaterializerMicrodown >> register: anObject as: aKey [ 

	keysDictionary at: aKey put: anObject
]
