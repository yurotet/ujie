var webpack = require("webpack");

module.exports = {
    entry: {
        app: ["./node_modules/webpack/hot/dev-server", "./src/app.js"],
        // app: ["./src/app.js"],
        vendor: ["vue"]
    }, 
    output: {
        path: "./build",
        filename: "app.js",
        publicPath: '/assets/'
    },
    module: {
        loaders: [
            { test: /\.css$/, loader: "style!css" }
        ]
    },
    resolve: {
        modulesDirectories: ["node_modules", "src"],
        extensions: ['', '.js', '.json', '.coffee']
    },
    plugins: [
        new webpack.optimize.CommonsChunkPlugin("vendor", "vendor.bundle.js")
    ]
};