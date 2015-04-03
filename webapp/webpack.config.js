var webpack = require("webpack");

module.exports = {
    entry: {
        app: ["./node_modules/webpack/hot/dev-server", "./src/app.js"],
        // app: ["./src/app.js"],
        vendor: ["vue"]
    }, 
    output: {
        path: "./build/assets",
        filename: "app.bundle.js",
        publicPath: '/assets/'
    },
    module: {
        loaders: [
            { test: /\.css$/, loader: "style!css" },
            { test: /\.vue$/, loader: "vue" }
        ]
    },
    resolve: {
        // root: [__dirname + '/src'],
        modulesDirectories: ['node_modules', 'src'],
        extensions: ['', '.js', '.json', '.coffee', '.vue'],
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
        contentBase: "build/"
    }
};