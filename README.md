# ujie
车的信息的抓取代码在data-capture里面的car.js, 用node运行，npm install两个模块, `request` 和 `process`，懒得写package.json

抓取好了数据之后处理如下：
```nodejs
// 把结果处理代码放到这个回调里面
// 数据结果的格式为{'bmw':['1 serises','3 series']...}
var handleResult = function(result) {...}
```
