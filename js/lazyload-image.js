/**
 * <lazyload-image>
 * HTMLImageElement extension for lazy loading.
 * http://github.com/1000ch/lazyload-image
 *
 * Copyright 1000ch
 * licensed under the MIT license.
 */
(function () {
  'use strict';

  var FALLBACK_IMAGE = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAEElEQVR42gEFAPr/AP///wAI/AL+Sr4t6gAAAABJRU5ErkJggg==';
  var DEFAULT_OFFSET = 0;

  /**
   * throttle
   * @param fn
   * @param delay
   * @returns {Function}
   * @private
   * @description forked from underscore.js
   */
  function throttle(fn, delay) {
    var context, args, result;
    var timeout = null;
    var previous = 0;
    return function() {
      var now = Date.now();
      if (!previous) {
        previous = now;
      }
      var remaining = delay - (now - previous);
      context = this;
      args = arguments;
      if (remaining <= 0) {
        clearTimeout(timeout);
        timeout = null;
        previous = now;
        result = fn.apply(context, args);
        context = args = null;
      }
      return result;
    };
  }

  // create prototype from HTMLImageElement
  var LazyloadImagePrototype = Object.create(HTMLImageElement.prototype);

  // lifecycle callbacks
  LazyloadImagePrototype.createdCallback = function () {

    if (this.complete || this.readyState === 'complete') return;

    var that = this;

    // swap original src attribute
    this.original = this.currentSrc || this.src;
    this.src = FALLBACK_IMAGE;

    // get offset attribute for pre-loading
    this.offset = Number(this.getAttribute('offset')) || DEFAULT_OFFSET;

    this.onLoad = function (e) {
      window.removeEventListener('scroll', that.onScroll);
      window.removeEventListener('resize', that.onScroll);
    };

    this.onError = function (e) {
      that.removeAttribute('srcset');
      that.src = FALLBACK_IMAGE;
      window.removeEventListener('scroll', that.onScroll);
      window.removeEventListener('resize', that.onScroll);
    };

    this.onScroll = throttle(function (e) {

      var rect   = that.getBoundingClientRect();
      var top    = document.documentElement.scrollTop - that.offset;
      var bottom = document.documentElement.clientHeight + that.offset;

      if ((rect.bottom > top && rect.bottom < bottom) ||
             (rect.top > top && rect.bottom < bottom) ||
             (rect.top > top && rect.top < bottom )) {

        that.addEventListener('load', that.onLoad);
        that.addEventListener('error', that.onError);
        that.src = that.original;
      }
    }, 300);
  };

  LazyloadImagePrototype.attachedCallback = function () {

    var rect   = this.getBoundingClientRect();
    var top    = document.documentElement.scrollTop - this.offset;
    var bottom = document.documentElement.clientHeight + this.offset;

    if ((rect.bottom > top && rect.bottom < bottom) ||
           (rect.top > top && rect.bottom < bottom) ||
           (rect.top > top && rect.top < bottom )) {

      this.addEventListener('load', this.onLoad);
      this.addEventListener('error', this.onError);
      this.src = this.original;

    } else {
      window.addEventListener('scroll', this.onScroll);
      window.addEventListener('resize', this.onScroll);
    }
  };

  LazyloadImagePrototype.detachedCallback = function () {

    this.removeEventListener('load', this.onLoad);
    this.removeEventListener('error', this.onError);
    window.removeEventListener('scroll', this.onScroll);
    window.removeEventListener('resize', this.onScroll);

  };

  // register element as lazyload-image
  if (document.registerElement != null) {
    window.LazyloadImage = document.registerElement('lazyload-image', {
      prototype: LazyloadImagePrototype,
      "extends": 'img'
    });
  }

})();
