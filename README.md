# LocalFileManager

[![CI Status](http://img.shields.io/travis/asashin227/LocalFileManager.svg?style=flat)](https://travis-ci.org/asashin227/LocalFileManager)
[![Version](https://img.shields.io/cocoapods/v/LocalFileManager.svg?style=flat)](http://cocoapods.org/pods/LocalFileManager)
[![License](https://img.shields.io/cocoapods/l/LocalFileManager.svg?style=flat)](http://cocoapods.org/pods/LocalFileManager)
[![Platform](https://img.shields.io/cocoapods/p/LocalFileManager.svg?style=flat)](http://cocoapods.org/pods/LocalFileManager)

LocalFileManager is Wrapped FileManager so that it can be used easily.

## TODO
- [ ] Add comment
- [ ] Genarate Thumbnail image
- [ ] Throw correct error
- [ ] Use Optional class correctly
- [ ] Test  

## Usage
### Howto display all files under the path.


 ```swift
 let fileManager = LocalFileManager()
 let dirPath = try! fileManager.absolutePath(.libraryDirectory)
 let files = try! fileManager.files(at: directoryPath)!
 files.forEach() {
 	file in
 	
 	let fileName = file.name
 	let path = file.path!
 	let data = file.data!
 }
 
 ```


### Manage file.

```swift
 let fileManager = LocalFileManager()

 // Load file.
 let filePath = try! fileManager.absolutePath(.libraryDirectory, path: "/hoge/fuga/img.png")
 let file = try! fileManager.load(filePath)
 
  // Delete file. 
 try! fileManager.delete(file)
 
 // Save file.
 try! fileManager.save(file)
 
 // Delete file. 
 let copyPath = try! fileManager.absolutePath(.libraryDirectory, path: "/hoge/fuga/img.png")
 let copiedFile = try! fileManager.copy(file, to: copyPath)

```


## Requirements

- iOS 8.0 or later

## Installation

LocalFileManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LocalFileManager"
```

## Author

[asashin227](https://github.com/asashin227)

## License
[MIT]: http://www.opensource.org/licenses/mit-license.php
LocalFileManager is available under the [MIT license][MIT]. 
