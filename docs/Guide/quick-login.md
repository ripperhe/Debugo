# 快速登陆

在开发的时候，可能需要用多个账号进行自测，以便 cover 到各种情况。但是说实话，来来回回切换账号，输入账号密码，真的很麻烦，浪费时间，所以衍生出了这个功能~

## 集成步骤

这个功能没办法一行代码集成，因为不可能帮你写完所有代码，每个 app 的登陆都不同，这里仅限账号登陆，三方登陆没法实现。集成方法如下：

1. 遵守协议

	```objectivec
	@interface SomeClass ()<DGDebugoDelegate>
	```

2. 设置代理

	```objectivec
	DGDebugo.shared.delegate = self;
	```

3. 实现协议方法

	```objectivec
	- (void)debugoLoginAccount:(DGAccount *)account
	{
		// 在这里利用账号信息实现你的自动登陆
	}
	```

4. 在 Debugo 的 fire 方法里配置 configuration

	```objectivec
	[DGDebugo fireWithConfiguration:^(DGConfiguration * _Nonnull configuration) {
        // 启用快速登陆按钮，不开启则快速登陆相关设置均无意义
        configuration.needLoginBubble = YES;
        // 初始化 Debugo 时是否为登陆状态; 用于判断当前是否需要开启 login bubble
        configuration.haveLoggedIn = NO;
        // 考虑到公司可能有测试环境和正式环境，所以两种环境的账号分开设置和存储的；这个参数代表当前是什么账号环境，默认为测试环境
        configuration.accountEnvironmentIsBeta = YES;
        // 公用的测试环境账号（便于每次卸载重装都能有账号可以直接登录）
        configuration.commonBetaAccounts = @[
                                             [DGAccount accountWithUsername:@"jintianyoudiantoutong@qq.com" password:@"dasinigewangbadan🤣"],
                                             [DGAccount accountWithUsername:@"wozhendeyoudianxinfan@qq.com" password:@"niyoubenshizaishuoyiju🧐"],
                                             ];
        // 公用的正式环境账号（同上）
        configuration.commonOfficialAccounts = @[
                                                 [DGAccount accountWithUsername:@"wolaile@gmail.com" password:@"😴wozouleoubuwoshuile"],
                                                 [DGAccount accountWithUsername:@"woshixianshangzhanghao@qq.com" password:@"😉wojiuwennipabupa"],
                                                 ];
    }];
	```

5. 登陆成功的时调用 `loginSuccessWithAccount:` 方法，用于保存账号信息以及隐藏 Login Bubble

	```objectivec
	// e.g.
	[DGDebugo loginSuccessWithAccount:[DGAccount accountWithUsername:account password:password]]
	```

6. 退出登陆成功的时调用 `logoutSuccess` 方法，用户重新显示 Login Bubble

	```objectivec
	// e.g.
 	[DGDebugo logoutSuccess];
	```

## 注意点 ❗️

按照如上步骤，即可完成一套自动登陆。不过有些细节需要注意以下

### 第 3 步

第 3 步实现代理方法，没必要写在登陆页面，最好是和配置的地方写在一起，然后利用 OC 运行时方法实现自动登录，尽量做到代码污染最小化~

Debugo 提供了一些方法辅助实现自动登录，例如直接获取某一 window 最上面的控制器，如下代码即可直接获取到 `[UIApplication sharedApplication].delegate.window` 最上面的控制器

```objectivec
[DGDebugo topViewControllerForWindow:nil]
```

可以参考工程的 Example 项目

### 第 4 步

第 4 步配置 configuration 的时候，`needLoginBubble` 需要设置为 `YES`，否者一切与登陆相关的设置都没有意义

`haveLoggedIn` 和 `accountEnvironmentIsBeta` 不要写死，我相信工程里一定有单例或者宏定义直接判断是否为登录状态以及是什么账号环境的参数；这样的好处是，切换环境的时候，这里配置的代码都不需要修改~

另外值得一提的是，考虑到公司可能有测试环境和正式环境的区分，为了防止账号混淆，则设置了 `Beta` 和 `Official` 系列参数，默认是 `accountEnvironmentIsBeta` 参数就是 YES，所以如果你公司没有这些环境区分，那么直接设置 `commonBetaAccounts` 即可

## 使用

使用快速登陆主要看你 `- (void)debugoLoginAccount:(DGAccount *)account` 方法中支持了哪些页面，点击 Login Bubble 调出账号列表，选中某一账号则会回调账号数据，进行登陆了~

另外该框架会存储手动登陆的所有账号到沙盒文件，在 `library/Caches/com.ripperhe.debugo/` 路径下面，可自行查看或删除

真正配置好了之后，一定会方便很多的，不麻烦，试试吧~ 😉
