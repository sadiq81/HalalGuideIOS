#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();

target.delay(3)
captureLocalizedScreenshot("0-FrontPageScreen")

target.frontMostApp().mainWindow().buttons()[2].tap();
target.delay(3)
captureLocalizedScreenshot("1-LocationScreen")

target.frontMostApp().toolbar().buttons()["Filter"].tap();
target.delay(3)
captureLocalizedScreenshot("2-FilterScreen")

target.frontMostApp().toolbar().buttons()["Færdig"].tap();
target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.33, y:0.13}});
target.delay(3)
captureLocalizedScreenshot("3-LocationDetailsScreen")