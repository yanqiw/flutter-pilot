$(".input-group").append(
  '<input type="text" class="form-control" id="code2" />'
);
$("#code2")
  .bsSuggest({
    indexId: 0, //data.value 的第几个数据，作为input输入框的内容
    indexKey: 0, //data.value 的第几个数据，作为input输入框的内容
    allowNoKeyword: false, //是否允许无关键字时请求数据。为 false 则无输入时不执行过滤请求
    multiWord: true, //以分隔符号分割的多关键字支持
    separator: ",", //多关键字支持时的分隔符，默认为空格
    getDataMethod: "url", //获取数据的方式，总是从 URL 获取
    showHeader: false, //显示多个字段的表头
    ignorecase: true,
    showBtn: false, //不显示下拉按钮
    autoDropup: false, //自动判断菜单向上展开
    effectiveFieldsAlias: { code: "代码", name: "名称" },
    url: "http://hope2.qianyitian.com:8002/search?word=",
    fnProcessData: function (json) {
      var index,
        len,
        data = { value: [] };

      if (!json || !json.symbols || !json.symbols.length) {
        return false;
      }

      len = json.symbols.length;

      for (index = 0; index < len; index++) {
        data.value.push({
          code: json.symbols[index].code,
          name: json.symbols[index].name,
        });
      }
      console.log("股票搜索API: ", data);
      return data;
    },
  })
  .on("onDataRequestSuccess", function (e, result) {
    console.log("onDataRequestSuccess: ", result);
  })
  .on("onSetSelectValue", function (e, keyword, data) {
    console.log("onSetSelectValue: ", keyword, data);
  })
  .on("onUnsetSelectValue", function () {
    console.log("onUnsetSelectValue");
  });
