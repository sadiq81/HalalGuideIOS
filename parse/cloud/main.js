var Image = require("parse-image");

// Use Parse.Cloud.define to define as many cloud functions as you want.

Parse.Cloud.beforeSave("LocationPicture", function (request, response) {

    Parse.Cloud.useMasterKey();

    var locationPicture = request.object;

    Parse.Cloud.httpRequest({
        url: locationPicture.get("picture").url()

    }).then(function (response) {
        var image = new Image();
        return image.setData(response.buffer);

    }).then(function (image) {
        // Resize the image.
        var width = image.width();
        var height = image.height();
        var min = Math.min(width, height);
        var scale = 140 / min;

        return image.scale({
            ratio: scale
        });

    }).then(function (image) {
        // Make sure it's a JPEG to save disk space and bandwidth.
        return image.setFormat("JPEG");

    }).then(function (image) {
        // Get the image data in a Buffer.
        return image.data();

    }).then(function (buffer) {
        // Save the image into a new file.
        var base64 = buffer.toString("base64");
        var cropped = new Parse.File("thumbnail.png", {base64: base64});
        return cropped.save();

    }).then(function (cropped) {
        // Attach the image file to the original object.
        locationPicture.set("thumbnail", cropped);

    }).then(function () {

        Parse.Cloud.httpRequest({
            url: locationPicture.get("picture").url()

        }).then(function (response) {
            var image = new Image();
            return image.setData(response.buffer);

        }).then(function (image) {
            // Resize the image.
            var width = image.width();
            var height = image.height();
            var min = Math.min(width, height);
            var scale = 540 / min;

            return image.scale({
                ratio: scale
            });

        }).then(function (image) {
            // Make sure it's a JPEG to save disk space and bandwidth.
            return image.setFormat("JPEG");

        }).then(function (image) {
            // Get the image data in a Buffer.
            return image.data();

        }).then(function (buffer) {
            // Save the image into a new file.
            var base64 = buffer.toString("base64");
            var cropped = new Parse.File("mediumPicture.png", {base64: base64});
            return cropped.save();

        }).then(function (cropped) {
            // Attach the image file to the original object.
            locationPicture.set("mediumPicture", cropped);

        }).then(function (result) {
            response.success();
        }, function (error) {
            response.error(error);
        });
    });
});

