const isIOS = /iP(hone|(o|a)d)/.test(navigator.userAgent)
var random = Math.floor( Math.random() * 31 );
var target = document.getElementById("addHome");

if (isIOS && random == 0 && target != null) {
  target.classList.remove('hidden');
}
