# MongooseServer
Mongoose is the most easy to use web server on the planet. If you want to use embedded web server on your iOS device, I recomment to use this.

# How to use
If you want to use this,
1. Copy [the mongoose webserver source](https://github.com/cesanta/mongoose) to your project. (MongooseServer supports version 5.6)
2. And write this code

	MongooseServer *mServer = [MongooseServer sharedInstance];
    [mServer setRootPath:NSHomeDirectory()];
    [mServer setPort:8080];
    [mServer start];