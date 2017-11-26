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
          if (this.element_.getElementsByTagName('input')[0].value.length > 0) {
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
 * table trをリンクにする
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
var tableTrClickable = function tableTrClickable(tableId) {
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
 * contentEditableの値をフォーム要素に設定する
 *
 * @param {String} fromStyleId コピー元
 * @param {String} toStyleId コピー先
 */
var setEditableContentValue = function setEditableContentValue(fromStyleId, toStyleId) {
  var fromElement = document.getElementById(fromStyleId);
  var fromData = fromElement.innerHTML;

  if (!fromData) {
    fromElement.focus();
    return false;
  }

  document.getElementById(toStyleId).value = fromData;

  return true;
}

/**
 * contentEditableをキャンセルする。
 *
 * @param {String} containerStyleId display:noneする要素
 * @param {String} editableStyleId 入力値を受け付けるcontentEditable要素
 */
var hiddenEditable = function hiddenEditable(containerStyleId, editableStyleId) {
  // 前回入力値が残らないように、値をクリアする
  document.getElementById(editableStyleId).innerHTML = "";
  // contentEditableをdisplay:noneする
  document.getElementById(containerStyleId).style.display="none";
}

/**
 * contentEditableを表示する。
 *
 * @param {String} containerStyleId 表示する要素
 * @param {String} editableStyleId 入力値を受け付けるcontentEditable要素
 */
var visibleEditable = function visibleEditable(containerStyleId, editableStyleId) {
  // 前回入力値が残らないように、値をクリアする
  document.getElementById(editableStyleId).innerHTML = "";
  // contentEditableをdisplay:noneする
  document.getElementById(containerStyleId).style.display="block";
  // editable要素にfocus当てる
  document.getElementById(editableStyleId).focus();
}

/**
 * enterでSubmitする
 *
 * @param {String} targetFormStyleId Submit対象のフォーム
 */
var onEnterSubmit = function onEnterSubmit(targetFormStyleId) {
  var code = event.which;
  var ctrl = (typeof event.modifiers == "undefined") ?
    event.ctrlKey : event.modifiers & Event.CONTROL_MASK;

  if(ctrl && code == 86) {
    // control + v
    return false;
  } else if (event.keyCode == 13) {
    // enter
    $("#" + targetFormStyleId).click();

    return false;
  }
}
