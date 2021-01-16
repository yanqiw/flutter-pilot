const STOCK_NUM = "STOCK_NUM";
const START_DATE = "START_DATE";

const HOST = "https://hope2.qianyitian.com";
const DEMARK_CHART_URL = "$HOST/demark-flag.html?code=$STOCK_NUM";
const SEARCH_STOCK_URL =
    "http://hope2.qianyitian.com:8002/search?word=$STOCK_NUM";
const MEMU_URL = "$HOST/menu.json";

const REPORT_TYPES = [
  {
    "name": "Demark（优选股票）",
    "router": "ReportDetail",
    "url": "/demark?days2Now=200"
  },
  {"name": "DeMark", "router": "ReportDetail", "url": "/analysis/Demark/daily"},
  {
    "name": "短期放量",
    "router": "ReportDetail",
    "url": "/analysis/SuddentHighVolume/daily"
  },
  {
    "name": "短期放量简化版",
    "router": "ReportDetail",
    "url": "/analysis/SuddentHighVolumeLite/daily"
  },
  {
    "name": "短期涨",
    "router": "ReportDetail",
    "url": "/analysis/SuddentIncrease/daily"
  },
  {
    "name": "短期缩量",
    "router": "ReportDetail",
    "url": "/analysis/SuddentLowVolume/daily"
  },
  {
    "name": "昨日重现",
    "router": "ReportDetail",
    "url": "/analysis/YesterdayOnceMore/daily"
  },
  {
    "name": "昨日重现（算法收益回溯）",
    "router": "BackTracking",
    "url": "/backtracking/{code}?startDate=$START_DATE"
  },
  {"name": "新股", "router": "ReportDetail", "url": "/analysis/IPO/daily"},
  {"name": "日线MACD上穿", "router": "ReportDetail", "url": "/analysis/MACD/daily"},
  {
    "name": "日线MACD上穿高级版",
    "router": "ReportDetail",
    "url": "/analysis/MACDAdvance/daily"
  },
  {
    "name": "周线MACD上穿",
    "router": "ReportDetail",
    "url": "/analysis/MACD/weekly"
  },
  {
    "name": "月线MACD上穿",
    "router": "ReportDetail",
    "url": "/analysis/MACD/monthly"
  },
];
