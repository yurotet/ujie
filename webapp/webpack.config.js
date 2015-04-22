var webpack = require("webpack");
var HtmlWebpackPlugin = require('html-webpack-plugin')

module.exports = {
    entry: {
        // app: ["./node_modules/webpack/hot/dev-server", "./src/app.js"],
        app: ["./node_modules/webpack/hot/dev-server", "./src/app.js"]
        // vendor: ["vue"]
    }, 
    output: {
        path: "./build/",
        filename: "app.bundle.js",
        publicPath: '/res/'
    },
    module: {
        loaders: [
            { test: /\.vue$/, loader: "vue" },
            { test: /\.css$/, loader: "style!css" },
            { test: /\.less$/, loader: "style!css!less" }
        ]
    },
    resolve: {
        // root: [__dirname + '/src'],
        modulesDirectories: ['node_modules', 'src'],
        extensions: ['', '.js', '.json', '.coffee', '.vue'],
    },
    plugins: [
        new HtmlWebpackPlugin({
            filename: 'index.html',
            template: 'src/index.html'
        }),
        // new webpack.optimize.CommonsChunkPlugin("vendor", "vendor.bundle.js"),
        new webpack.ProvidePlugin({
            "$": "browserify-zepto",
            // "_": "underscore",
        }),
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