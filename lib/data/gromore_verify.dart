/// @Author: gstory
///
/// @CreateDate: 2022/8/12 18:19
///
/// @Email gstory0404@gmail.com
///
/// @Description: 激励广告奖励信息
///
/// [verify] 是否有效
///
/// [transId] 验证id
///
/// [rewardName] 奖励名称
///
/// [rewardAmount] 奖励数量
class GromoreVerify {
  bool? verify;
  String? transId;
  String? rewardName;
  int? rewardAmount;

  GromoreVerify(
      {this.verify, this.transId, this.rewardName, this.rewardAmount});

  GromoreVerify.fromJson(Map<String, dynamic> json) {
    verify = json['verify'];
    transId = json['transId'];
    rewardName = json['rewardName'];
    rewardAmount = json['rewardAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['verify'] = verify;
    data['transId'] = transId;
    data['rewardName'] = rewardName;
    data['rewardAmount'] = rewardAmount;
    return data;
  }
}

