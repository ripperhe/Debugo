# 添加测试条目

我们在开发的时候，需要调试，也需要自测，所以难免会有这样的一些需求

* 一些测试代码，例如直接 Push 到某个页面...
* 一些功能代码，比如打印当前的控制器对象，打印所有 window，手动插入某些数据...

这些代码直接写在页面代码里面，可能就会污染代码，一不小心提上去还会影响同事开发。本功能就是为了解决这个痛点，可以随处添加测试代码，也不影响其他功能，直接提交也无妨。因为这是逃逸闭包，唯一要关系的就是引用问题~

## 添加一个测试条目

原理就是利用 block 块儿存储测试代码，通过点击调用。下面就是直接添加一个测试条目的方法：

```objectivec
[DGDebugo addActionWithTitle:@"Wo Shi Ce Shi" handler:^(DGTestAction *action, UIViewController *actionVC) {
	NSLog(@"wo kan ni xie le duo shao bug!");
}];
```

点击 Debug Bubble 调出 Debug Window，在 `Test Go` 页面点击对应的 Cell 即可调用对应代码。

## 不自动关闭 Debug Window

利用上面这个方法，点击之后则会调用对应代码，并且自动关闭 Debug Window。有的时候不想自动关闭，则可以使用这个方法：

```objectivec
[DGDebugo addActionForUser:nil title:@"Xin Tian Di 👉" autoClose:NO handler:^(DGTestAction *action, UIViewController *actionVC) {
    UIViewController *vc = [UIViewController new];
    [actionVC.navigationController pushViewController:vc animated:YES];
}];
```

这个方法多了一个 `autoClose` 参数，传入 `NO` 即可不自动关闭。就像例子中的一样，可能有的时候需要 push 到一个页面，可以使用 block 的 `actionVC` 的 `navigationController` 直接进行 push。

## 优先显示当前 User 测试条目

在该 user 电脑下，优先显示该 user 的测试条目，`$ whoami` 查看用户名。

所有没有设置 user 的 action 都会放在匿名分组。


```objectivec
[DGDebugo addActionForUser:@"ripper" title:@"今天吃啥啊？" handler:^(DGTestAction * _Nonnull action, UIViewController * _Nonnull actionVC) {
	DGLog(@"不知道啊...");
}];
```

## 公用的测试条目

前面介绍的都是随处直接添加的测试条目，不过有的功能代码是我们大家都要用的，而且是一直都要用的。比如我之前公司做体脂秤的，可能就需要一个手动插入体重数据的功能方便测试，像这种功能就没必要零零散散地添加，直接一次性配置好。

Debugo 时的 fire 方法里面 configuration 有个参数为 `commonTestActions`，设置这个参数即可

```objectivec
configuration.commonTestActions = @[
                                            [DGTestAction actionWithTitle:@"Log Top ViewController 😘" autoClose:YES handler:^(DGTestAction *action, UIViewController *actionVC) {
                                                UIViewController *vc = [DGDebugo topViewControllerForWindow:nil];
                                                NSLog(@"%@", vc);
                                            }],
                                            [DGTestAction actionWithTitle:@"Log All Window 🧐" autoClose:YES handler:^(DGTestAction *action, UIViewController *actionVC) {
                                                NSArray *array = [DGDebugo getAllWindows];
                                                NSLog(@"%@", array);
                                            }],
                                            ];
```
