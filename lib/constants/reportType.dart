const STOCK_NUM = "STOCK_NUM";
const START_DATE = "START_DATE";

const HOST = "http://hope2.qianyitian.com:8003";
const DEMARK_CHART_URL = "$HOST/demark-flag.html?code=$STOCK_NUM";
const SEARCH_STOCK_URL =
    "http://hope2.qianyitian.com:8002/search?word=$STOCK_NUM";

const REPORT_TYPES = [
  {
    "name": "昨日重现（算法收益回溯）",
    "router": "BackTracking",
    "url": "$HOST/backtracking/$STOCK_NUM?startDate=$START_DATE"
  },
  {
    "name": "Demark（优选股票）",
    "router": "ReportDetail",
    "url": "$HOST/demark?days2Now=200"
  },
  {
    "name": "DeMark",
    "router": "ReportDetail",
    "url": "$HOST/analysis/Demark/daily"
  },
  {
    "name": "短期放量",
    "router": "ReportDetail",
    "url": "$HOST/analysis/SuddentHighVolume/daily"
  },
  {
    "name": "短期放量简化版",
    "router": "ReportDetail",
    "url": "$HOST/analysis/SuddentHighVolumeLite/daily"
  },
  {
    "name": "短期涨",
    "router": "ReportDetail",
    "url": "$HOST/analysis/SuddentIncrease/daily"
  },
  {
    "name": "短期缩量",
    "router": "ReportDetail",
    "url": "$HOST/analysis/SuddentLowVolume/daily"
  },
  {
    "name": "昨日重现",
    "router": "ReportDetail",
    "url": "$HOST/analysis/YesterdayOnceMore/daily"
  },
  {"name": "新股", "router": "ReportDetail", "url": "$HOST/analysis/IPO/daily"},
  {
    "name": "日线MACD上穿",
    "router": "ReportDetail",
    "url": "$HOST/analysis/MACD/daily"
  },
  {
    "name": "日线MACD上穿高级版",
    "router": "ReportDetail",
    "url": "$HOST/analysis/MACDAdvance/daily"
  },
  {
    "name": "周线MACD上穿",
    "router": "ReportDetail",
    "url": "$HOST/analysis/MACD/weekly"
  },
  {
    "name": "月线MACD上穿",
    "router": "ReportDetail",
    "url": "$HOST/analysis/MACD/monthly"
  },
];
