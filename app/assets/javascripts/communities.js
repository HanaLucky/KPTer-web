(function() {
  'use strict';
  var dialogButton = document.querySelector('.dialog-button-invitable-users');
  var dialog = document.querySelector('#invitable-users-dialog');
  if (! dialog.showModal) {
    dialogPolyfill.registerDialog(dialog);
  }
  dialogButton.addEventListener('click', function() {
     dialog.showModal();
  });
  dialog.querySelector('button:not([disabled])')
  .addEventListener('click', function() {
    dialog.close();
  });
}());
