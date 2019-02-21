# 添加测试条目

我们在开发的时候，需要调试，也需要自测，所以难免会有这样的一些需求

* 一些测试代码，例如直接 Push 到某个页面...
* 一些功能代码，比如打印当前的控制器对象，打印所有 window，手动插入某些数据...

这些代码直接写在页面代码里面，可能就会污染代码，一不小心提上去还会影响同事开发。本功能就是为了解决这个痛点，可以随处添加测试代码，也不影响其他功能，直接提交也无妨。因为这是逃逸闭包，唯一要关系的就是引用问题~

## 添加一个测试条目

原理就是利用 block 块儿存储测试代码，通过点击调用。下面就是直接添加一个测试条目的方法：

```objectivec
[Debugo addTestActionWithTitle:@"Wo Shi Ce Shi" handler:^(DGTestAction *action, UIViewController *actionViewController) {
	NSLog(@"wo kan ni xie le duo shao bug!");
}];
```

点击 Debug Bubble 调出 Debug Window，在 `Test Go` 页面点击对应的 Cell 即可调用对应代码。

## 不自动关闭 Debug Window

利用上面这个方法，点击之后则会调用对应代码，并且自动关闭 Debug Window。有的时候不想自动关闭，则可以使用这个方法：

```objectivec
[Debugo addTestActionWithTitle:@"Xin Tian Di 👉" autoClose:NO handler:^(DGTestAction *action, UIViewController *actionViewController) {
    UIViewController *vc = [UIViewController new];
    [actionViewController.navigationController pushViewController:vc animated:YES];
}];
```

这个方法多了一个 `autoClose` 参数，传入 `NO` 即可不自动关闭。就像例子中的一样，可能有的时候需要 push 到一个页面，可以使用 block 的 `actionViewController` 的 `navigationController` 直接进行 push。

## 仅显示指定测试条目

我们在实际使用的时候，遇到这样一个问题，添加测试条目虽然快捷，但是用的人多了之后，列表里面的测试条目就会有很多，每次都要滑很久。

现目前的解决方案是设计了一个 user 参数，也就是指定是谁添加的这个测试条目，然后再把 user 和 Mac 的 UUID 绑定在一起，同时给工程添加一个脚本，每次 build 的时候获取 Mac 的 UUID，每次程序运行的时候，就把 user 和 当前的 Mac 的 UUID 进行比对，自动显示指定的测试条目。具体需要如下配置：

1. Debugo 时的 fire 方法里面需要设置 `configuration.debugoUserArray` 参数，数组元素为 `DGUser` 对象，name 值即为 user 名，随意一个字符串就行，只要和后续使用一致即可；macUUID 值为这个 user 的 Mac 电脑的 UUID。有多少个用户，则添加多少个该对象

	```objectivec
    configuration.debugoUserArray = @[
                                      [DGUser userWithName:@"Tony"     macUUID:@"BBSDFSDF-FFFA-DSDF-A2D3-ADFADFGDFDSD"],
                                      [DGUser userWithName:@"xiaodi"   macUUID:@"CSDFFS32-WEFR-B4WR-WERG-45453453535Q"],
                                      [DGUser userWithName:@"baomu"    macUUID:@"KSF3ASDF-SDAF-34R1-SJ33-WERTWRTTRTRT"],
                                      [DGUser userWithName:@"siji"     macUUID:@"SDFSGREW-QGHH-RWRE-1FYY-SDFADAFEQERE"],
                                      ];
	```
2. 在工程的 `Build Phases` 页面添加一个 shell 脚本，用于获取当前电脑的 UUID 等信息，[具体做法看这里 🚀](Guide/build-info.md)
3. 在添加测试条目的时候使用这个方法，user 参数谁添加的就传谁

	```objectivec
	[Debugo addTestActionForUser:@"siji" withTitle:@"Fa Che Le 😍" autoClose:YES handler:^(DGTestAction *action, UIViewController *actionViewController) {
        NSLog(@"qiu ming shan deng ni!");
    }];
	```

按照上面的办法，即可做到不改代码的同时，不同电脑 build 的包只显示不同的测试条目。如果没有设置 `configuration.debugoUserArray` 或者没有添加脚本获取电脑 UUID，则默认显示所有的测试条目~

附带一句，Mac 终端获取 UUID 的命令如下：

```bash
$ system_profiler SPHardwareDataType | awk '/UUID/{print $3;}'
```

## 再快一点 🚀

上面这个显示指定测试条目的方法也不算麻烦，第一步和第二步仅需配置一次即可，以后都不用管。不过第三步就略显累赘了，要传好几个参数，而且 user 传错了还不行，怎么办？

当然是代码块儿啦，比如搞这个样一个代码块儿

```objectivec
[Debugo addTestActionForUser:@"ripper" withTitle:<#title#> autoClose:YES handler:^(DGTestAction *action) {
	<#code ... #>
}];
```

user 直接写死，反正不变，设置 title 以及代码即可。

我还嫌麻烦， title 都懒得写，但是这个参数是必须传入的，怎么办呢？这样吧...

```objectivec
[Debugo addTestActionForUser:@"ripper" withTitle:[NSString stringWithFormat:@"%@ • %d", [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent, __LINE__] autoClose:YES handler:^(DGTestAction *action) {
	<#code ... #>
}];
```

来一波骚操作，直接用文件名和代码行数命名，也不会重名 😆

## 永久的测试条目

前面介绍的都是随处直接添加的测试条目，不过有的功能代码是我们大家都要用的，而且是一直都要用的。比如我之前公司做体脂秤的，可能就需要一个手动插入体重数据的功能方便测试，像这种功能就没必要零零散散地添加，直接一次性配置好。

Debugo 时的 fire 方法里面 configuration 有个参数为 `permanentTestActionArray`，设置这个参数即可

```objectivec
configuration.permanentTestActionArray = @[
                                           [DGTestAction actionWithTitle:@"Log Top ViewController 😘" autoClose:YES handler:^(DGTestAction *action, UIViewController *actionViewController) {
                                               UIViewController *vc = [Debugo topViewControllerForWindow:nil];
                                               NSLog(@"%@", vc);
                                           }],
                                           [DGTestAction actionWithTitle:@"Log All Window 🧐" autoClose:YES handler:^(DGTestAction *action, UIViewController *actionViewController) {
                                               NSArray *array = [Debugo getAllWindows];
                                               NSLog(@"%@", array);
                                           }],
                                           ];
```

两种测试条目除了代码添加的不同，UI 上也有体现，`Test Go` 页面展现测试条目的时候分为两个 Section，前面一系列添加临时的测试条目的方法到第一个 Section (Temporary)，后面这个属性设置的则添加到第二个 Section (Permanent)
