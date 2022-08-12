/// @Author: gstory
///
/// @CreateDate: 2022/8/12 18:30
///
/// @Email gstory0404@gmail.com
///
/// @Description: 广告加载相关信息
///
/// [adnName] ADN的名称，与平台配置一致，自定义ADN时为ADN唯一标识
///
/// [customAdnName] 自定义ADN的名称，与平台配置一致，非自定义ADN为nil
///
/// [slotID]  代码位
///
/// [levelTag] 价格标签，多阶底价下有效
///
/// [ecpm] 返回价格，nil为无权限
///
/// [biddingType] 广告类型
///
/// [errorMsg] 额外错误信息,一般为空(扩展字段)
///
/// [requestID]  adn提供的真实广告加载ID，可为空
class GromoreAdInfo {
  String? adnName;
  String? customAdnName;
  String? slotID;
  String? levelTag;
  String? ecpm;
  int? biddingType;
  String? errorMsg;
  String? requestID;

  GromoreAdInfo(
      {this.adnName,
        this.customAdnName,
        this.slotID,
        this.levelTag,
        this.ecpm,
        this.biddingType,
        this.errorMsg,
        this.requestID});

  GromoreAdInfo.fromJson(Map<String, dynamic> json) {
    adnName = json['adnName'];
    customAdnName = json['customAdnName'];
    slotID = json['slotID'];
    levelTag = json['levelTag'];
    ecpm = json['ecpm'];
    biddingType = json['biddingType'];
    errorMsg = json['errorMsg'];
    requestID = json['requestID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adnName'] = this.adnName;
    data['customAdnName'] = this.customAdnName;
    data['slotID'] = this.slotID;
    data['levelTag'] = this.levelTag;
    data['ecpm'] = this.ecpm;
    data['biddingType'] = this.biddingType;
    data['errorMsg'] = this.errorMsg;
    data['requestID'] = this.requestID;
    return data;
  }
}

