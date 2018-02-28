/* HMTLエスケープ */
var escapeHTML = function(val) {
  return $('<div />').text(val).html();
};

$(function() {
  /**
   * Check the validity state and update field accordingly.
   * see. https://github.com/google/material-design-lite/issues/1502#issue-103886485
   * @public
   */
  MaterialTextfield.prototype.checkValidity = function () {
      if (this.input_.validity.valid) {
          this.element_.classList.remove(this.CssClasses_.IS_INVALID);
      } else {
          if (this.element_.getElementsByTagName('input')[0]
            && this.element_.getElementsByTagName('input')[0].value.length > 0) {
                this.element_.classList.add(this.CssClasses_.IS_INVALID);
          }
          if (this.element_.getElementsByTagName('textarea')[0]
            && this.element_.getElementsByTagName('textarea')[0].value.length > 0) {
                this.element_.classList.add(this.CssClasses_.IS_INVALID);
          }
      }
  };
});


var chart;
var chartDoughnut = function chartDoughnut (elementId, title, labels, data) {

  var backgroundColors = [
    "rgb(255, 99, 132)",  // red
    "rgb(255, 159, 64)",  // orange
    "rgb(255, 205, 86)",  // yellow
    "rgb(75, 192, 192)",  // green
    "rgb(54, 162, 235)"   // blue
  ]

  if(!data || data.length == 0) {
    backgroundColors = [];
    labels = ["No data"]
    data = ["0"]
  }
  if (chart) {
    chart.destroy();
  }

  chart = new Chart(document.getElementById(elementId), {
    "type": "doughnut",
    "data": {
      "labels": labels,
      "datasets": [{
        "data": data,
        "backgroundColor": backgroundColors
      }]
    },
    options: {
      title: {
        display: true,
        text: title
      },
      animation: {
        animateRotate: false
      }
    }
  });
};

/**
 * initialize for dialog
 *
 * @param {String} dialogButtonStyleClassName ダイアログ開くボタンのclass名
 * @param {String} dialogDivStyleId　ダイアログタグのid名
 */
var settingDialog = function settingDialog(dialogButtonStyleClassName, dialogDivStyleId) {
  var dialogButton = document.querySelector('.' + dialogButtonStyleClassName);
  var dialog = document.querySelector('#' + dialogDivStyleId);

  if (!dialog || !dialogButton) {
    return;
  }

  if (!dialog.showModal) {
    dialogPolyfill.registerDialog(dialog);
  }
  dialogButton.addEventListener('click', function() {
    if (!dialog.open) {
      dialog.showModal();
    }
  });
  dialog.querySelector('.close').addEventListener('click', function() {
    dialog.close();
  });
};

/**
 * table の全trタグをリンクにする
 * リンク先はdata-href属性の値
 *
 * @param {String} tableId 対象のテーブルのID
 *
 * sample.
 * <table>
 *   <tbody>
 *     <tr data-href="https://kpter.net/communities/6/boards/3">
 *       <td>board name</td>
 *     </tr>
 *   </tbody>
 * </table>
 */
var tableClickable = function tableClickable(tableId) {
  $("#" + tableId  + " tbody tr[data-href]").addClass('clickable').click( function() {
    window.location = $(this).attr('data-href');
  }).find('a').hover( function() {
    $(this).parents('tr').unbind('click');
  }, function() {
    $(this).parents('tr').click( function() {
      window.location = $(this).attr('data-href');
    });
  });
}

/**
 * table tdをクリックすることで非同期でリクエストする
 * リンク先はdata-href属性の値
 * HTTPメソッドはdata-method属性の値
 *
 * @param {String} tableId 対象のテーブルのID
 * @param {String} eventTdClassName クリック対象のtd要素のクラス名
 * sample.
 * <table>
 *   <tbody>
 *     <tr data-href="https://kpter.net/communities/6/boards/3" data-method="GET">
 *       <td>board name</td>
 *     </tr>
 *   </tbody>
 * </table>
 */
var tableTdClickableAjax = function tableTdClickableAjax(tableId, eventTdClassName) {
  $("#" + tableId  + " tbody tr[data-href] td." + eventTdClassName).addClass('clickable').click( function() {
    var link = $(this).parents("tr").attr('data-href');
    var method = $(this).parents("tr").attr('data-method');
    var data = $("#" + tableId).data();
    $.ajax({
      type: method,
      url: link,
      data: {
        chaindata : data
      }
    });
  });
}

/**
 * table trをクリックすることで非同期でリクエストする
 * リンク先はdata-href属性の値
 * HTTPメソッドはdata-method属性の値
 *
 * @param {String} tableId 対象のテーブルのID
 * @param {String} trId 対象のテーブルtrのID
 * @param {String} eventTdClassName クリック対象のtd要素のClass名
 * sample.
 * <table>
 *   <tbody>
 *     <tr data-href="https://kpter.net/communities/6/boards/3" data-method="GET">
 *       <td>board name</td>
 *     </tr>
 *   </tbody>
 * </table>
 */
var tableTrTdClickableAjax = function tableTrTdClickableAjax(tableId, trId, eventTdClassName) {
  $("#" + tableId  + " tbody " + "#" + trId + " td." + eventTdClassName).addClass('clickable').click( function() {
    var link = $(this).parents("tr").attr('data-href');
    var method = $(this).parents("tr").attr('data-method');
    var data = $("#" + tableId).data();
    $.ajax({
      type: method,
      url: link,
      data: {
        chaindata : data
      }
    });
  });
}

/**
 * フォームを非表示にする
 *
 * @param {String} containerStyleId display:noneする要素のstyleId
 * @param {String} editableStyleId 入力値を受け付けるinput要素のstyleId
 */
var hiddenForm = function hiddenForm(containerStyleId, inputStyleId) {
  // 前回入力値が残らないように、値をクリアする
  document.getElementById(inputStyleId).value = "";
  // contentEditableをdisplay:noneする
  document.getElementById(containerStyleId).style.display="none";
}

/**
 * フォームを表示する。
 *
 * @param {String} containerStyleId 表示する要素
 * @param {String} inputStyleId 入力値を受け付けるinput要素のstyleId
 */
var visibleForm = function visibleForm(containerStyleId, inputStyleId) {
  // 前回入力値が残らないように、値をクリアする
  document.getElementById(inputStyleId).value = "";
  // contentEditableをdisplay:noneする
  document.getElementById(containerStyleId).style.display="block";
  // editable要素にfocus当てる
  document.getElementById(inputStyleId).focus();
}
