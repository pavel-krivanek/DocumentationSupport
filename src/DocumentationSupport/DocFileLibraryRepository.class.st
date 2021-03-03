"
I am a documentation repository that uses a folder structure on disc.
"
Class {
	#name : #DocFileLibraryRepository,
	#superclass : #DocLibraryRepository,
	#instVars : [
		'folder'
	],
	#category : #'DocumentationSupport-Model'
}

{ #category : #exporting }
DocFileLibraryRepository >> export: aLibrary [ 

	| serializer |

	serializer := DocSerializerSton new.
	serializer export: aLibrary to: self folder.

]

{ #category : #accessing }
DocFileLibraryRepository >> folder [

	^ folder
]

{ #category : #accessing }
DocFileLibraryRepository >> folder: anObject [

	folder := anObject
]

{ #category : #accessing }
DocFileLibraryRepository >> libraries [  

	| materializer |
	
	materializer := DocMaterializerSton new.

	^ folder directories collect: [ :dir |
		| aLibrary |
		aLibrary := materializer readLibraryFrom: dir.
		aLibrary repository: self.
		aLibrary
	]
]
