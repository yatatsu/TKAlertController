# TKAlertController

---

TKAlertController supports both UIAlertView (or UIActionSheet) and UIAlertController.

## About

- TKAlertController is UIAlertController for under iOS8.
- In iOS8, It works as UIAlertController. 
- And in previous OS version, It works as UIAlertView or UIAcitonSheet.
- You can use it in same way for any versions.
- It works in both Xcode 6beta and 5x.

## Known issue

- It does not support delegates about UITextField in UIAlertView.
- It does not support Localized String.
- when ``UIAlertController`` show, ``ViewWillDisapper:`` is not called. (but in ``TKAlertController``, it's called.)

## Usage

1. First we create ``TKAlertController``, as ``UIAlertController``.

```
UIViewController *alertController =
[TKAlertController alertControllerWithTitle:@"title"
                                    message:@"message"
                             preferredStyle:TKAlertControllerStyleAlert];
```

``TKAlertControllerStyleAlert`` is insted of ``UIAlertContollerStyleAlert``.

and ``TKAlertControllerStyleActionSheet`` is instead of ``UIAlertControllerStyleActionSheet``.

2. Second, we prepare ``TKAlertAction`` as ``UIAlertAction``.

```
TKAlertAction *cancelAction =
     [TKAlertAction actionWithTitle:kButtonTitleCancel
                              style:TKAlertActionStyleCancel
                            handler:^(TKAlertAction *action) {
							// something to do.
                            }];

TKAlertAction *OKAction =
     [TKAlertAction actionWithTitle:kButtonTitleOK
                              style:TKAlertActionStyleDestructive
                            handler:^(TKAlertAction *action) {
							// something to do.
							}];

```

3. then, add action to controller.

```
[alertController addAction:cancelAction];
[alertController addAction:OKAction];
```

4. finally, call the method to show.

```
[self presentTKAlertController:alertController animated:YES completion:^{
	  // 
}];
```

``presentTKAlertController:animated:completion:`` is in category in UIViewController.

## LICENSE

MIT