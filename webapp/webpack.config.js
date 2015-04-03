var webpack = require("webpack");

module.exports = {
    entry: {
        app: ["./node_modules/webpack/hot/dev-server", "./src/app.js"],
        // app: ["./src/app.js"],
        vendor: ["vue"]
    }, 
    output: {
        path: __dirname + "/build/assets",
        filename: "app.bundle.js",
        publicPath: '/assets/'
    },
    module: {
        loaders: [
            { test: /\.css$/, loader: "style!css" }
        ]
    },
    resolve: {
        root: [__dirname + '/src'],
        extensions: ['', '.js', '.json', '.coffee']
    },
    plugins: [
        new webpack.optimize.CommonsChunkPlugin("vendor", "vendor.bundle.js"),
        // new webpack.optimize.UglifyJsPlugin({
        //     compress: {
        //         warnings: false
        //     }
        // })
    ],
    devServer: {
        contentBase: "./build"
    }
};