const STOCK_NUM = "STOCK_NUM";
const START_DATE = "START_DATE";

const HOST = "https://www.qianyitian.com";
const PHOTO_GALLERY_HOST = "http://photo-gallery.frankwang.cn";
const PHOTO_GALLERY_DOWNLOAD_URL =
    "http://zhihu-spider.frankwang.cn/spider/start?detailUrl=";
// const DEMARK_CHART_URL = "$HOST/demark-flag.html?code=$STOCK_NUM";
const DEMARK_CHART_URL =
    "http://127.0.0.1:8008/h5/deMarkDetail/Hope2.html?code=$STOCK_NUM";
// const DEMARK_FUND_CHART_URL =
// "http://127.0.0.1:8008/h5/deMarkDetail/Hope2Fund.html?code=$STOCK_NUM";
const DEMARK_FUND_CHART_URL =
    "https://www.qianyitian.com/demark-fund-flag.html?code=$STOCK_NUM";
const DEMARK_STOCK_MARK_CHART_URL =
    "https://www.qianyitian.com/demark-flag.html?code=$STOCK_NUM";
const SEARCH_STOCK_URL =
    "http://www.qianyitian.com:8002/search?word=$STOCK_NUM";
const MEMU_URL = "$HOST/menu.json";

const REPORT_TYPES = [
  {
    "id": 'RPS',
    "order": 10,
    "group": 10,
    "groupName": '热门指数',
    "version": 1,
    "name": "RPS 指标",
    "router": "RpsReport",
    "url": "/rps/fund_lite",
    "image": "https://s3.ax1x.com/2021/01/12/sYRCbq.png",
    "description":
        "RPS指标衡量了某基金在过去一段时间，相对市场中其他基金的表现。市场内每只基金都被指定了0-100范围内的某一数值，100代表相对强度最高"
  },
  {
    "id": 'stock-top',
    "order": 10,
    "group": 10,
    "groupName": '热门指数',
    "version": 1,
    "name": "股票综合评分",
    "router": "StockReport",
    "url": "/grade/stock_lite",
    "image": "https://s3.ax1x.com/2021/01/12/sYREPU.png",
    "description": "根据Hope2内的各种策略，算出股票的综合得分，得分高者为佳"
  },
  {
    "id": 'ddu',
    "order": 11,
    "group": 10,
    "groupName": '热门指数',
    "version": 1,
    "name": "DDU 指标",
    "router": "DduReport",
    "url": "/ddu/fund",
    "image": "https://s3.ax1x.com/2021/01/12/sYR9rn.png",
    "description": "DDU指标衡量了某基金在过去一段时间，相对自身过往的表现。"
  },
  {
    "id": 'demark20',
    "order": 20,
    "group": 20,
    "groupName": 'DeMark',
    "version": 1,
    "name": "优选 20",
    "router": "DeMarkReport",
    "url": "/demark/h20?days2Now=200",
    "image": "https://s3.ax1x.com/2021/01/12/sYRk5T.png",
    "description": "精选A股最优秀的20只股票,采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'demark150',
    "order": 21,
    "group": 20,
    "groupName": 'DeMark',
    "version": 1,
    "name": "优选 150",
    "router": "DeMarkReport",
    "url": "/demark/h150?days2Now=200",
    "image": "https://s3.ax1x.com/2021/01/12/sYRGGD.png",
    "description": "精选A股最优秀的150只股票150组合，采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'demarkHK',
    "order": 22,
    "group": 20,
    "groupName": 'DeMark',
    "version": 1,
    "name": "港股",
    "router": "DeMarkReport",
    "url": "/demark/hk?days2Now=200",
    "image": "https://s3.ax1x.com/2021/01/12/sYR8PO.png",
    "description": "港股采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'demarkUS',
    "order": 23,
    "group": 20,
    "groupName": 'DeMark',
    "version": 1,
    "name": "美股",
    "router": "DeMarkReport",
    "url": "/demark/us?days2Now=200",
    "image": "https://s3.ax1x.com/2021/01/12/sYR1IK.png",
    "description": "美股采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'demarkETF',
    "order": 24,
    "group": 20,
    "groupName": 'DeMark',
    "version": 1,
    "name": "ETF基金",
    "router": "DeMarkReport",
    "url": "/demark/etf?days2Now=200",
    "image": "https://s3.ax1x.com/2021/01/12/sYRla6.png",
    "description": "ETF基金采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'demarkZQZS',
    "order": 25,
    "group": 20,
    "groupName": 'DeMark',
    "version": 1,
    "name": "证券指数",
    "router": "DeMarkReport",
    "url": "/demark/index?days2Now=200",
    "image": "https://s3.ax1x.com/2021/01/12/sYRQVx.png",
    "description": "证券指数采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'demarkDaily',
    "order": 26,
    "group": 20,
    "groupName": 'DeMark',
    "version": 1,
    "name": "全量",
    "router": "DeMarkReport",
    "url": "/analysis/Demark/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRKq1.png",
    "description": "全量采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'suddentHighVolume',
    "order": 30,
    "group": 30,
    "groupName": '短期放量',
    "version": 1,
    "name": "短期放量",
    "router": "ReportDetail",
    "url": "/analysis/SuddentHighVolume/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRurR.png",
    "description": "在20个工作日内，发生过3次成交量是前一天的2.5倍"
  },
  {
    "id": 'suddentHighVolumeLite',
    "order": 31,
    "group": 30,
    "groupName": '短期放量',
    "version": 1,
    "name": "短期放量简化版",
    "router": "ReportDetail",
    "url": "/analysis/SuddentHighVolumeLite/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRnM9.png",
    "description": "在2个工作日内，发生过1次成交量是前一天的2.4倍,换手大于1.2%,涨幅大于0"
  },
  {
    "id": 'SuddentIncrease',
    "order": 32,
    "group": 30,
    "groupName": '短期放量',
    "version": 1,
    "name": "短期涨",
    "router": "ReportDetail",
    "url": "/analysis/SuddentIncrease/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRnM9.png",
    "description": "10天之内有近似涨停，目前跌幅大于 -3.5%"
  },
  {
    "id": 'suddentLowVolume',
    "order": 33,
    "group": 30,
    "groupName": '短期放量',
    "version": 1,
    "name": "短期缩量",
    "router": "ReportDetail",
    "url": "/analysis/SuddentLowVolume/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRexJ.png",
    "description": "5天之内某一天的跌幅超过-4.0，成交量小于前一天百分之50"
  },
  {
    "id": 'yesterdayOnceMore',
    "order": 40,
    "group": 40,
    "groupName": '昨日重现',
    "version": 1,
    "name": "昨日重现",
    "router": "ReportDetail",
    "url": "/analysis/YesterdayOnceMore/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRZ24.png",
    "description": "只考虑110天内的股票，曾经在20天内涨幅超过50.0%，现值比前期低点涨幅大于 -50.0%， 小于 30.0%"
  },
  {
    "id": 'backTracking',
    "order": 44,
    "group": 40,
    "groupName": '昨日重现',
    "version": 1,
    "name": "昨日重现（算法收益回溯）",
    "router": "BackTracking",
    "url": "/backtracking/{code}?startDate=$START_DATE",
    "image": "https://s3.ax1x.com/2021/01/12/sYRk5T.png",
    "description": "比较长期持有和高抛低吸的盈利差别"
  },
  {
    "id": 'ipo',
    "order": 50,
    "group": 50,
    "groupName": 'IPO',
    "version": 1,
    "name": "新股",
    "router": "ReportDetail",
    "url": "/analysis/IPO/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRVGF.png",
    "description": "上市10个月以内，当前价格低于最高价的1/2"
  },
  {
    "id": 'macdDaily',
    "order": 60,
    "group": 60,
    "groupName": 'MACD',
    "version": 1,
    "name": "日线MACD上穿",
    "router": "ReportDetail",
    "url": "/analysis/MACD/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYREPU.png",
    "description": "MACD 介于0和0.1之间，且大于前一天的值，换手率大于2%"
  },
  {
    "id": 'macdAdvance',
    "order": 61,
    "group": 60,
    "groupName": 'MACD',
    "version": 1,
    "name": "日线MACD上穿高级版",
    "router": "ReportDetail",
    "url": "/analysis/MACDAdvance/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRFaV.png",
    "description": "30 天之内 MACD小于0过，目前MACD大于0，股价高于30天均线"
  },
  {
    "id": 'macdWeekly',
    "order": 62,
    "group": 60,
    "groupName": 'MACD',
    "version": 1,
    "name": "周线MACD上穿",
    "router": "ReportDetail",
    "url": "/analysis/MACD/weekly",
    "image": "https://s3.ax1x.com/2021/01/12/sYRiV0.png",
    "description": "MACD 介于0和0.1之间，且大于前一天的值，换手率大于2%"
  },
  {
    "id": 'macdMonthly',
    "order": 63,
    "group": 60,
    "groupName": 'MACD',
    "version": 1,
    "name": "月线MACD上穿",
    "router": "ReportDetail",
    "url": "/analysis/MACD/monthly",
    "image": "https://s3.ax1x.com/2021/01/12/sYRCbq.png",
    "description": "MACD 介于0和0.1之间，且大于前一天的值，换手率大于2%"
  },
];
