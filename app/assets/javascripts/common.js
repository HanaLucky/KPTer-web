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
var chartDoughnut = function(elementId, title, labels, data) {

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

var settingDialog = function(dialogButtonStyleClassName, dialogDivStyleId){
  var dialogButton = document.querySelector('.' + dialogButtonStyleClassName);
  var dialog = document.querySelector('#' + dialogDivStyleId);
  if (! dialog.showModal) {
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
