// 成功
function success_msg(msg) {
  alertify.logPosition("buttom right").closeLogOnClick(true).success(msg);
};

// 失敗
function error_msg(msg) {
  alertify.logPosition("buttom right").closeLogOnClick(true).error(msg);
}
