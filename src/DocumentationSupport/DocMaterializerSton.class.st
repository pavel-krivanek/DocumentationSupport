"
I perform loading of serialized document libraries.
"
Class {
	#name : #DocMaterializerSton,
	#superclass : #Object,
	#instVars : [
		'keysDictionary'
	],
	#category : #'DocumentationSupport-Serialization'
}

{ #category : #initialization }
DocMaterializerSton >> initialize [ 

	super initialize.
	
	keysDictionary := Dictionary new.
]

{ #category : #materialization }
DocMaterializerSton >> readBookFrom: bookDirectory [ 

	| aBook |
	aBook := (bookDirectory / 'description', 'ston') readStreamDo: [ :stream | 
		STON fromStream: stream ].
	aBook chapters: (self readChaptersFrom: bookDirectory) asOrderedCollection.
	self register: aBook as: aBook key.
	^ aBook
]

{ #category : #materialization }
DocMaterializerSton >> readBooksFrom: bookDirectory [

	^ bookDirectory directories collect: [ :dir |
		self readBookFrom: dir]
]

{ #category : #materialization }
DocMaterializerSton >> readChaptersFrom: bookDirectory [ 

	| chapterFiles |
	
	chapterFiles := bookDirectory files reject: [ :file | file basename = 'description.ston' ].
	^ chapterFiles collect: [ :each | 
		| aChapter |
		aChapter := STON fromStream: each readStream.
		self register: aChapter as: aChapter key.
		aChapter ]
]

{ #category : #materialization }
DocMaterializerSton >> readLibrariesFrom: directoryFileReference [

	^ directoryFileReference directories collect: [ :dir |
		self readLibraryFrom: dir]
]

{ #category : #materialization }
DocMaterializerSton >> readLibraryFrom: libraryDirectory [ 
	| library | 
	
	library := DocLibrary new.
	library name: libraryDirectory basename.
	library books: (self readBooksFrom: libraryDirectory) asOrderedCollection.
	library fixParentReferencesUsing: keysDictionary.
	library books do: [ :each | each setLibrary: library ].
	
	^ library
]

{ #category : #private }
DocMaterializerSton >> register: anObject as: aKey [ 

	keysDictionary at: aKey put: anObject
]
