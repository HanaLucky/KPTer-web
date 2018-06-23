$(function () {
  // init modal
  MicroModal.init();

  // cropper object
  var cropper;

  // モーダル生成
  var dialog = document.querySelector('dialog');
  if (! dialog.showModal) {
    // dialog,showModal未実装のブラウザ対応 see.https://github.com/GoogleChrome/dialog-polyfill
    dialogPolyfill.registerDialog(dialog);
  }

  // クローズボタンにクリックイベントを付加
  dialog.querySelector('.close').addEventListener('click', function() {
    if (cropper) {
      // モーダル閉じたらcropperを破棄（しないと、画像を差し替えられない）
      cropper.destroy();
    }
    $('#avatar').hide();
    dialog.close();
  });

  $('#preview-avatar-image').bind('load', function(){
    var image = document.getElementById('preview-avatar-image');
    cropper = new Cropper(image, {
      aspectRatio: 1 / 1,
      guides: false,
      zoomable: false,
      crop: function (e) {

      }
    });
    $('#avatar').show();
  });

  // fine uploader
  var uploader = new qq.FineUploaderBasic({
    autoUpload: false,
    button: document.getElementById('btn-file-uploader'),
    validation: {
      acceptFiles: ['image/jpeg', 'image/gif', 'image/png'],
      allowedExtensions: ['jpeg', 'jpg', 'gif', 'png']
    },
    request: {
      endpoint: '/users/upload',
      params: {
        authenticity_token: $('input[name="authenticity_token"]').val()
      }
    },
    callbacks: {
      // エラーが発生した場合
      onError: function (id, filename, message, xhr) {
        alert(message);
      },
      // ファイルが選択されたあとに動く。モーダルを表示しプレビューを表示する。
      onSubmit: function (id, filename) {
        var self = this;
        // プレビュー表示（src 属性に data スキーマがセットされる）
        self.drawThumbnail(id, document.getElementById('preview-avatar-image'))

        // アップロードボタンにクリックイベントを付加
        document.getElementById('upload-image-btn').addEventListener('click', function (e) {
          // キャンセル押されたらイベント中止
          e.preventDefault();
          // クロッピングしたデータをFileにしてサーバー送信
          cropper.getCroppedCanvas().toBlob(function (blob) {
            var croppedFile = new File([blob], filename, {
              lastModified: new Date(0),
              type: self.getFile(id).type
            });
            // クロッピングされる前のファイルを削除する
            self.clearStoredFiles();
            //クロッピングされたファイルを追加する
            self.addFiles(croppedFile);
            // アップロード開始
            self.uploadStoredFiles();
          })
        }, false);
      },
      onSubmitted: function(id, filename) {
          // サムネイル設定が終わったらダイアログを開く
          if (!dialog.open) {
            dialog.showModal();
          }
      },
      // アップロードが完了した時
      onComplete: function (id, filename, response, xhr) {
        var self = this;
        // this will free up all consumed memory.
        self.removeFileRef(id);
        // redirect to self
        location.href = '/users/edit';
      }
    }
  });
});
