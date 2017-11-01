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
