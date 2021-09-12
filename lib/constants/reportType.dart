const STOCK_NUM = "STOCK_NUM";
const START_DATE = "START_DATE";

const HOST = "https://www.qianyitian.com";
const PHOTO_GALLERY_HOST = "http://photo-gallery.yanqiw.qianyitian.com";
// const DEMARK_CHART_URL = "$HOST/demark-flag.html?code=$STOCK_NUM";
const DEMARK_CHART_URL =
    "http://127.0.0.1:8008/h5/deMarkDetail/Hope2.html?code=$STOCK_NUM";
const SEARCH_STOCK_URL =
    "http://www.qianyitian.com:8002/search?word=$STOCK_NUM";
const MEMU_URL = "$HOST/menu.json";

const REPORT_TYPES = [
  {
    "id": 'photoGallery',
    "group": '0_其他',
    "version": 1,
    "name": "相册",
    "router": "PhotoGallery",
    "url": "/question?bucket=zhihu-spider&prefix=resources/zhihu-images/",
    "image": "https://s3.ax1x.com/2021/01/12/sYRCbq.png",
    "description": "一些好看的图片"
  },
  {
    "id": 'demark20',
    "group": 'DeMark',
    "version": 1,
    "name": "优选 20",
    "router": "DeMarkReport",
    "url": "/demark/h20?days2Now=200",
    "image": "https://s3.ax1x.com/2021/01/12/sYRk5T.png",
    "description": "精选A股最优秀的20只股票,采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'demark150',
    "group": 'DeMark',
    "version": 1,
    "name": "优选 150",
    "router": "DeMarkReport",
    "url": "/demark/h150?days2Now=200",
    "image": "https://s3.ax1x.com/2021/01/12/sYRGGD.png",
    "description": "精选A股最优秀的150只股票150组合，采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'demarkHK',
    "group": 'DeMark',
    "version": 1,
    "name": "港股",
    "router": "DeMarkReport",
    "url": "/demark/hk?days2Now=200",
    "image": "https://s3.ax1x.com/2021/01/12/sYR8PO.png",
    "description": "港股采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'demarkUS',
    "group": 'DeMark',
    "version": 1,
    "name": "美股",
    "router": "DeMarkReport",
    "url": "/demark/us?days2Now=200",
    "image": "https://s3.ax1x.com/2021/01/12/sYR1IK.png",
    "description": "美股采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'demarkETF',
    "group": 'DeMark',
    "version": 1,
    "name": "ETF基金",
    "router": "DeMarkReport",
    "url": "/demark/etf?days2Now=200",
    "image": "https://s3.ax1x.com/2021/01/12/sYRla6.png",
    "description": "ETF基金采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'demarkZQZS',
    "group": 'DeMark',
    "version": 1,
    "name": "证券指数",
    "router": "DeMarkReport",
    "url": "/demark/index?days2Now=200",
    "image": "https://s3.ax1x.com/2021/01/12/sYRQVx.png",
    "description": "证券指数采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'demarkDaily',
    "group": 'DeMark',
    "version": 1,
    "name": "全量",
    "router": "DeMarkReport",
    "url": "/analysis/Demark/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRKq1.png",
    "description": "全量采用DeMark策略进行预测和回溯，规避垃圾股，提高盈利概率"
  },
  {
    "id": 'suddentHighVolume',
    "group": '短期放量',
    "version": 1,
    "name": "短期放量",
    "router": "ReportDetail",
    "url": "/analysis/SuddentHighVolume/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRurR.png",
    "description": "在20个工作日内，发生过3次成交量是前一天的2.5倍"
  },
  {
    "id": 'suddentHighVolumeLite',
    "group": '短期放量',
    "version": 1,
    "name": "短期放量简化版",
    "router": "ReportDetail",
    "url": "/analysis/SuddentHighVolumeLite/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRnM9.png",
    "description": "在2个工作日内，发生过1次成交量是前一天的2.4倍,换手大于1.2%,涨幅大于0"
  },
  {
    "id": 'SuddentIncrease',
    "group": '短期放量',
    "version": 1,
    "name": "短期涨",
    "router": "ReportDetail",
    "url": "/analysis/SuddentIncrease/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRnM9.png",
    "description": "10天之内有近似涨停，目前跌幅大于 -3.5%"
  },
  {
    "id": 'suddentLowVolume',
    "group": '短期放量',
    "version": 1,
    "name": "短期缩量",
    "router": "ReportDetail",
    "url": "/analysis/SuddentLowVolume/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRexJ.png",
    "description": "5天之内某一天的跌幅超过-4.0，成交量小于前一天百分之50"
  },
  {
    "id": 'yesterdayOnceMore',
    "group": '昨日重现',
    "version": 1,
    "name": "昨日重现",
    "router": "ReportDetail",
    "url": "/analysis/YesterdayOnceMore/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRZ24.png",
    "description": "只考虑110天内的股票，曾经在20天内涨幅超过50.0%，现值比前期低点涨幅大于 -50.0%， 小于 30.0%"
  },
  {
    "id": 'backTracking',
    "group": '昨日重现',
    "version": 1,
    "name": "昨日重现（算法收益回溯）",
    "router": "BackTracking",
    "url": "/backtracking/{code}?startDate=$START_DATE",
    "image": "https://s3.ax1x.com/2021/01/12/sYRk5T.png",
    "description": "比较长期持有和高抛低吸的盈利差别"
  },
  {
    "id": 'ipo',
    "group": 'IPO',
    "version": 1,
    "name": "新股",
    "router": "ReportDetail",
    "url": "/analysis/IPO/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRVGF.png",
    "description": "上市10个月以内，当前价格低于最高价的1/2"
  },
  {
    "id": 'macdDaily',
    "group": 'MACD',
    "version": 1,
    "name": "日线MACD上穿",
    "router": "ReportDetail",
    "url": "/analysis/MACD/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYREPU.png",
    "description": "MACD 介于0和0.1之间，且大于前一天的值，换手率大于2%"
  },
  {
    "id": 'macdAdvance',
    "group": 'MACD',
    "version": 1,
    "name": "日线MACD上穿高级版",
    "router": "ReportDetail",
    "url": "/analysis/MACDAdvance/daily",
    "image": "https://s3.ax1x.com/2021/01/12/sYRFaV.png",
    "description": "30 天之内 MACD小于0过，目前MACD大于0，股价高于30天均线"
  },
  {
    "id": 'macdWeekly',
    "group": 'MACD',
    "version": 1,
    "name": "周线MACD上穿",
    "router": "ReportDetail",
    "url": "/analysis/MACD/weekly",
    "image": "https://s3.ax1x.com/2021/01/12/sYRiV0.png",
    "description": "MACD 介于0和0.1之间，且大于前一天的值，换手率大于2%"
  },
  {
    "id": 'macdMonthly',
    "group": 'MACD',
    "version": 1,
    "name": "月线MACD上穿",
    "router": "ReportDetail",
    "url": "/analysis/MACD/monthly",
    "image": "https://s3.ax1x.com/2021/01/12/sYRCbq.png",
    "description": "MACD 介于0和0.1之间，且大于前一天的值，换手率大于2%"
  },
];
