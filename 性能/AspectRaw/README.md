## [blog juejin:  Aspects swift 源代码分析](https://juejin.cn/post/6964553187307028487)


### 基于 woshiccm/Aspect


### Features


- [x] Hook object selector
- [x] Hook different classes selector in the same hierarchy
- [x] Hook class and static selector
- [x] Provide more friendly Swift interfaces




## Usage
### Hook object selector with OC block

```
public class Test: NSObject {

    @objc dynamic func test(id: Int, name: String) {

    }

    @objc dynamic static func classSelector(id: Int, name: String) {

    }
}

let test = Test()

let wrappedBlock: @convention(block) (AspectInfo, Int, String) -> Void = { aspectInfo, id, name in

}
let block: AnyObject = unsafeBitCast(wrappedBlock, to: AnyObject.self)
test.hook(selector: #selector(Test.test(id:name:)), strategy: .before, block: )
```

### Hook object selector with Swift block

```
let test = Test()

_ = try? test.hook(selector: #selector(Test.test(id:name:)), strategy: .before) { (_, id: Int, name: String) in

}

```

### Hook class instance selector with Swift block

```
_ = try? Test.hook(selector: #selector(Test.test(id:name:)), strategy: .before) { (_, id: Int, name: String) in

}

```

### Hook class class and static selector with Swift block
```

_ = try? Test.hook(selector: #selector(Test.classSelector(id:name:)), strategy: .before) { (_, id: Int, name: String) in

}
```






## 不足


* Support remove aspect
* Improve detail
* Support Cocopods install



