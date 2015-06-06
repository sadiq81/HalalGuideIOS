var Image = require("parse-image");

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

Parse.Cloud.beforeSave("Message", function (request, response) {

    Parse.Cloud.useMasterKey();

    var message = request.object;
    if (message.get("objectId") == null) {

        var Subject = Parse.Object.extend("Subject");
        var query = new Parse.Query(Subject);

        query.get(message.get("subjectId"), {
            success: function (subject) {

                subject.increment("count");
                subject.set("lastMessage", new Date())
                subject.save();

                var User = Parse.Object.extend("User");
                var query = new Parse.Query(User);

                query.get(message.get("userId"), {
                    success: function (user) {

                        //Channels must start with letter, ids can start with numbers
                        var parsePushChannel = "subject-" + message.get("subjectId");

                        var userData = user.get("userData");
                        var name = userData['name'];

                        var pushMessage = name + " : " + message.get("text");

                        var query = new Parse.Query(Parse.Installation);
                        query.equalTo('channels', parsePushChannel);
                        query.notEqualTo('user', user);

                        Parse.Push.send({
                            where: query,
                            data: {
                                alert: pushMessage,
                                context: "HGChat",
                                contextData: message.get("subjectId")
                            }
                        }, {
                            success: function () {
                                response.success();
                            },
                            error: function (error) {
                                response.success();
                                console.log(error);
                            }
                        });

                    },
                    error: function (error) {
                        response.success();
                        console.log(error);
                    }
                });
            },
            error: function (object, error) {
                response.success();
                console.log(error);
            }
        });
    }
});


//Parse.Cloud.job("importSmileyData", function (request, status) {
//
//    Parse.Cloud.useMasterKey();
//
//    Parse.Cloud.httpRequest({
//        url: 'http://www.findsmiley.dk/xml/allekontrolresultater.xml',
//        success: function (httpResponse) {
//
//            console.log(httpResponse.headers);
//
//
//
//            request.success();
//        },
//        error: function (httpResponse) {
//            console.error('Request failed with response code ' + httpResponse.status);
//            request.error();
//        }
//    })
//});



