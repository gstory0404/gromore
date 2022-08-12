/// @Author: gstory
/// @CreateDate: 2022/8/12 18:13
/// @Email gstory0404@gmail.com
/// @Description: 广告加载错误信息
///
/// [code] 错误码
///
/// [message] 错误信息

class GromoreError {

  int? code;
  String? message;

  GromoreError({this.code, this.message});

  GromoreError.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}


