/*
Soul
@author Jonas Skovmand <jonas.skovmand@tres-bien.com>
*/


(function() {
  var Soul,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Soul = (function() {
    Soul.prototype.init = false;

    Soul.prototype.request = {
      referrer: null,
      searchEngine: null,
      socialNetwork: null,
      searchQuery: null
    };

    Soul.prototype.rules = {};

    Soul.prototype.master = null;

    Soul.prototype.cookie = null;

    Soul.prototype.cookiePrefix = '_tb_sl3_';

    Soul.prototype.pageviews = false;

    Soul.prototype.debug = null;

    Soul.prototype.colorbox = {
      transition: 'none'
    };

    Soul.prototype.config = {
      timeout: 1000,
      tokenPath: '/soul/rules/rule/token/'
    };

    Soul.prototype._matches = {
      socialNetworks: [
        {
          site: 'facebook',
          regex: "^(?:http(s)?://)?(.*.)?facebook\\.com/.*$"
        }, {
          site: 'twitter',
          regex: "^(?:http(s)?://)?(.*.)?(twitter|t)\\.(com|co)/.*$"
        }
      ],
      searchEngines: [
        {
          site: 'adwords',
          regex: "^(?:http(s)?://)?(www\\.)?google\\..*/(aclk.*)?(.*adurl.*)?$",
          query: "q"
        }, {
          site: 'googleads',
          regex: "^(?:http(s)?://)?googleads\.g\.doubleclick\\..*/pagead/ads.*$",
          query: false
        }, {
          site: 'google',
          regex: "^(?:http(s)?://)?(www\\.)?google\\..*/.*$",
          query: "q"
        }, {
          site: 'yahoo',
          regex: "^(?:http://)?(?:([a-z]{2})\\.)?search\\.yahoo\\.com/.*$",
          query: "p"
        }, {
          site: 'bing',
          regex: "^(?:http://)?((?:www|[a-z]{2})\\.)?bing\\.com/search\\?.*$",
          query: "q"
        }, {
          site: 'naver',
          regex: "^(?:http://)?search\\.naver\\.com/.*$",
          query: "query"
        }
      ]
    };

    function Soul(token) {
      if (token === false) {
        return null;
      }
      this.init(token);
    }

    Soul.prototype.init = function(token) {
      var _this = this;
      this._installDependencies();
      if (this.init === true) {
        return null;
      }
      this.init = true;
      this.token = token;
      this._initCookie();
      this._trackPageview();
      return this._loadScript(this._getTokenURL(token), function() {
        var master, name, rule, _i, _len, _ref, _results;
        if ((typeof _soul_routes === "undefined" || _soul_routes === null) || ((_soul_routes.status != null) && _soul_routes.status === 'error')) {
          if ((typeof _soul_routes !== "undefined" && _soul_routes !== null) && (_soul_routes.status != null)) {
            _this._log('ERROR: ' + _soul_routes.message);
          } else {
            _this._log('UNKNOWN ERROR WHEN LOADING ROUTES');
          }
          return 0;
        }
        for (_i = 0, _len = _soul_routes.length; _i < _len; _i++) {
          rule = _soul_routes[_i];
          _this._addRule(rule);
        }
        master = _this._getMasterCookie();
        _ref = _this.rules;
        _results = [];
        for (name in _ref) {
          rule = _ref[name];
          if (_this._checkRule(rule) !== false) {
            _results.push(_this._goSoul(rule));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
    };

    Soul.prototype._debug = function() {
      var debug;
      if (this.debug !== null) {
        return this.debug;
      }
      debug = this._getCookie('debug');
      this.debug = debug && (debug === 1 || debug === true || debug === '1') ? true : false;
      return this._debug;
    };

    Soul.prototype._log = function() {
      var argument, _i, _len;
      if (!this._debug()) {
        return null;
      }
      if ((typeof console !== "undefined" && console !== null) && (console.log != null) && typeof console.log === 'function') {
        for (_i = 0, _len = arguments.length; _i < _len; _i++) {
          argument = arguments[_i];
          console.log(argument);
        }
      }
      return null;
    };

    Soul.prototype._checkRule = function(rule) {
      var dateCurrent, dateEnd, dateStart, keyword, referrer, status, _found, _i, _j, _len, _len1, _q, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _referrer;
      if (rule.date_start || rule.date_end) {
        dateCurrent = new Date().getTime();
        if (rule.date_start) {
          dateStart = this._readDate(rule.date_start);
          if (dateStart > dateCurrent) {
            return false;
          }
        }
        if (rule.date_end) {
          dateEnd = this._readDate(rule.date_end);
          if (dateEnd < dateCurrent) {
            return false;
          }
        }
      }
      this._log('passed date');
      if (rule.referrer != null) {
        _referrer = this._getReferrer();
        if (typeof rule.referrer === 'string') {
          status = (_ref = _referrer.indexOf(rule.referrer) === 0) != null ? _ref : {
            yes: false
          };
          if (!status) {
            return false;
          }
        } else if ((rule.referrer.length != null) && rule.referrer.length > 0) {
          _ref1 = rule.referrer;
          for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
            referrer = _ref1[_i];
            status = (_ref2 = _referrer.indexOf(referrer) === 0) != null ? _ref2 : {
              yes: false
            };
            if (!status) {
              return false;
            }
          }
        }
      }
      this._log('passed referrer');
      if ((rule.searchEngine != null) && rule.searchEngine !== false) {
        if (rule.searchEngine === true) {
          status = (_ref3 = this._getSearchEngine(rule.searchEngine.length && rule.searchEngine.length > 0 ? rule.searchEngine : void 0)) != null ? _ref3 : false;
          if (!status) {
            return false;
          }
        }
        if ((rule.query != null) && rule.query !== false) {
          _q = this._getSearchQuery();
          if (_q == null) {
            return false;
          }
          if (rule.query !== true && (rule.query.length != null) && rule.query.length > 0) {
            _found = false;
            _ref4 = rule.query;
            for (_j = 0, _len1 = _ref4.length; _j < _len1; _j++) {
              keyword = _ref4[_j];
              if (keyword.indexOf(_q) !== -1) {
                _found = keyword;
              }
            }
            if (!_found) {
              return false;
            }
          }
        }
      }
      this._log('passed search');
      if ((rule.socialNetwork != null) && rule.socialNetwork !== false) {
        if (rule.socialNetwork === true) {
          status = (_ref5 = this._getSocialNetwork(rule.socialNetwork.length && rule.socialNetwork.length > 0 ? rule.socialNetwork : void 0)) != null ? _ref5 : false;
          if (!status) {
            return false;
          }
        }
      }
      this._log('passed social');
      if (rule.path != null) {
        status = this._checkPath(rule);
        if (status === false) {
          return false;
        }
      }
      this._log('passed path');
      if (rule.pageviews != null) {
        status = this._getPageviews() < rule.pageviews ? false : true;
        if (status === false) {
          return false;
        }
      }
      this._log('passed pageviews');
      return true;
    };

    Soul.prototype._checkPath = function(rule) {
      var status, _match;
      if ((rule.path == null) || rule.path === false) {
        return true;
      }
      _match = rule.path._match != null ? rule.path._match : 'strict';
      if (rule.path._include != null) {
        status = this._checkPaths(rule.path._include, _match);
        if (status === true) {
          return true;
        }
      } else if (rule.path._exclude != null) {
        status = this._checkPaths(rule.path._exclude, _match);
        if (status === false) {
          return true;
        }
      } else {
        status = this._checkPaths(rule.path, _match);
        if (status === true) {
          return true;
        }
      }
      return false;
    };

    Soul.prototype._checkPaths = function(paths, match) {
      var path, test, _found, _i, _len, _ref, _req;
      if (match == null) {
        match = 'strict';
      }
      _req = (_ref = this._getLandingPage()) != null ? _ref : '';
      _req = '' + _req;
      _found = false;
      for (_i = 0, _len = paths.length; _i < _len; _i++) {
        path = paths[_i];
        if (match === 'fuzzy') {
          test = _req.indexOf(path);
          if (test !== -1) {
            return true;
          }
        } else if (path === _req) {
          return true;
        }
      }
      return false;
    };

    Soul.prototype._readDate = function(date) {
      var dateParts, parts, timeParts;
      parts = date.split(' ');
      dateParts = parts[0].split('-');
      timeParts = parts[1].split(':');
      return new Date(parseInt(dateParts[0], 10), parseInt(dateParts[1], 10) - 1, parseInt(dateParts[2], 10), parseInt(timeParts[0], 10), parseInt(timeParts[1], 10), parseInt(timeParts[2], 10)).getTime();
    };

    Soul.prototype._goSoul = function(rule) {
      var timeout, _c, _ref,
        _this = this;
      this.currentRule = rule;
      _c = (_ref = this._getMasterCookie()) != null ? _ref : {};
      this._log(_c);
      if ((_c != null) && (_c.minimized != null) && (_c.minimized[rule.name] != null)) {
        if (_c.minimized[rule.name] === false || _c.minimized[rule.name] === "false") {
          return null;
        }
        this._minimizePopup();
        return null;
      }
      timeout = rule.timeout && rule.timeout > 0 ? rule.timeout * 1000 : this.config.timeout;
      return setTimeout(function() {
        return _this._trackAndFire(rule);
      }, timeout);
    };

    Soul.prototype._trackAndFire = function(rule) {
      var _c, _ref, _ref1;
      this._trackSoulEvent('Popup', rule.name);
      _c = (_ref = this._getMasterCookie()) != null ? _ref : {};
      _c.fired = (_ref1 = _c.fired) != null ? _ref1 : {};
      _c.fired['' + rule.name] = 'yes';
      this._setCookie('mc', this._jsonToText(_c));
      return this._showPopup(rule);
    };

    Soul.prototype._goalComplete = function() {
      var _c;
      this._trackSoulEvent('Success', this.currentRule.name);
      _c = this._getMasterCookie();
      _c.complete = true;
      return this._setCookie('mc', this._jsonToText(_c));
    };

    Soul.prototype._showPopup = function(rule) {
      if (typeof jQuery === "undefined" || jQuery === null) {
        return null;
      }
      return this._defaultPopup();
    };

    Soul.prototype._defaultPopup = function() {
      var _emailCallback,
        _this = this;
      this._setMinimized(true);
      _emailCallback = function() {
        var colorboxSettings, email, submit, _ereg;
        email = jQuery('#soul_email');
        submit = jQuery('#soul_action').find('input[type=submit]');
        submit.attr('disabled', true);
        colorboxSettings = jQuery.extend({}, _this.colorbox, {
          width: _this.currentRule.container_width === 'auto' || _this.currentRule.container_width === false ? false : _this.currentRule.container_width,
          html: _this.currentRule.mode !== 'html' ? false : '<div class="static-block-inner">' + _this.currentRule.template + '</div>',
          href: _this.currentRule.mode !== 'html' ? _this.currentRule.href : false,
          onClosed: function() {
            return jQuery('#colorbox').removeClass(_this.currentRule.container_class);
          }
        });
        email.removeClass('error');
        _ereg = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if (email.val() === '' || !_ereg.test(email.val())) {
          email.css('border', '1px solid red');
          submit.removeAttr('disabled');
          return false;
        }
        _this._log('cbfirst', colorboxSettings);
        /*
        jQuery.post jQuery('#soul_action').attr('action'), jQuery('#soul_action').serialize(), (data) =>
          if data? and typeof(data) is 'object' and data.status? and data.status is error
            alert 'ERROR: ' + data.message
            submit.removeAttr 'disabled'
            return no
          email.removeAttr 'style'
          console.log 'cb', colorboxSettings
          colorboxSettings.html = '<div class="static-block-inner">' + @currentRule.thankyou + '</div>'
          jQuery.colorbox colorboxSettings
          submit.removeAttr 'disabled'
          @_goalComplete()
        , 'text'
        */

        return setTimeout(function() {
          email.removeAttr('style');
          colorboxSettings.html = '<div class="static-block-inner">' + _this.currentRule.thankyou + '</div>';
          jQuery.colorbox(colorboxSettings);
          submit.removeAttr('disabled');
          return _this._goalComplete();
        }, 1000);
      };
      return jQuery.colorbox(jQuery.extend({}, this.colorbox, {
        width: this.currentRule.container_width === 'auto' || this.currentRule.container_width === false ? false : this.currentRule.container_width,
        html: this.currentRule.mode !== 'html' ? false : '<div class="static-block-inner">' + this.currentRule.template + '</div>',
        href: this.currentRule.mode !== 'html' ? this.currentRule.href : false,
        onLoad: function() {
          jQuery('#colorbox').addClass(_this.currentRule.container_class);
          if (jQuery.on != null) {
            return jQuery(document).on('submit', '#soul_action', _emailCallback);
          } else {
            return jQuery('#soul_action').live('submit', _emailCallback);
          }
        },
        onClosed: function() {
          jQuery('#colorbox').removeClass(_this.currentRule.container_class);
          _this._setMinimized(true);
          return _this._minimizePopup();
        }
      }));
    };

    Soul.prototype._setMinimized = function(minimized) {
      var _c, _ref, _ref1;
      this._log('setting minimized', minimized);
      _c = (_ref = this._getMasterCookie()) != null ? _ref : {};
      _c.minimized = (_ref1 = _c.minimized) != null ? _ref1 : {};
      _c.minimized[this.currentRule.name] = minimized;
      this._setCookie('mc', this._jsonToText(_c));
      return this._log(_c);
    };

    Soul.prototype._minimizePopup = function() {
      var minimized,
        _this = this;
      this._log('minimize');
      if (this.currentRule.minimize !== true) {
        this._closeMinimize();
        return false;
      }
      this._trackSoulEvent('Minimize', this.currentRule.name);
      minimized = '<div id="' + this.currentRule.name + 'minimized" style="position:fixed; bottom:0; padding: 0 13px; background-color:#fff; text-align: left; width: 180px; height: 25px; line-height:25px; z-index: 300; right: 0; margin-right: 15px; border:1px solid #000; border-bottom: 0; cursor: context-menu;"><div style="position: relative; width: 180px; height: 25px;">' + this.currentRule.title + ' <span style="position: absolute; right: -7px; top:6px;"><a href="#"><img src="/skin/frontend/default/tresbien/images/close_button.png" id="' + this.currentRule.name + 'close" /></a></span></div></div>';
      jQuery(this.currentRule.name + 'minimized').remove();
      jQuery('body').append(minimized);
      jQuery('#' + this.currentRule.name + 'minimized').hover(function() {
        return jQuery(_this).css('backgroundColor', '#eee');
      }, function() {
        return jQuery(_this).css('backgroundColor', '#fff');
      });
      jQuery('#' + this.currentRule.name + 'minimized').click(function() {
        _this._closeMinimize();
        _this._maximizePopup();
        return false;
      });
      return jQuery('#' + this.currentRule.name + 'close').click(function() {
        _this._closeMinimize();
        return false;
      });
    };

    Soul.prototype._closeMinimize = function() {
      this._log('closing minimize');
      this._setMinimized(false);
      jQuery('#' + this.currentRule.name + 'minimized').remove();
      if (this.currentRule.minimize === true) {
        return this._trackSoulEvent('Close minimize', this.currentRule.name);
      }
    };

    Soul.prototype._maximizePopup = function() {
      this._log('maximize');
      this._trackSoulEvent('Maximize', this.currentRule.name);
      return this._defaultPopup();
    };

    Soul.prototype._getReferrer = function() {
      var host, ref, _c, _cref, _dref;
      if (this.request.referrer != null) {
        return this.request.referrer;
      }
      _c = this._getMasterCookie();
      ref = '';
      host = window.location.hostname;
      _dref = document.referrer;
      _cref = (_c != null) && (_c.ref != null) ? _c.ref : _dref;
      ref = _cref !== '' && _cref.indexOf(host) === -1 ? ref = _cref : _dref !== '' && _dref.indexOf(host) === -1 ? ref = _dref : ref = _cref;
      this.request.referrer = ref;
      return ref;
    };

    Soul.prototype._getUrl = function() {
      return window.location.host;
    };

    Soul.prototype._getLandingPage = function() {
      var _c, _ref;
      _c = (_ref = this._getMasterCookie()) != null ? _ref : {
        lp: window.location
      };
      return _c.lp;
    };

    Soul.prototype._getUrlPath = function() {
      var a;
      if (this.urlPath != null) {
        return this.urlPath;
      }
      a = document.createElement('a');
      a.href = window.location;
      this.urlPath = a.pathname + a.search;
      return this.urlPath;
    };

    Soul.prototype._setReferrer = function(referrer) {
      return this.request.referrer = referrer;
    };

    Soul.prototype._getSearchQuery = function() {
      var regex, searchEngine, test;
      if (this.request.searchQuery === !null) {
        return this.request.searchQuery;
      }
      searchEngine = this._getSearchEngine();
      if (searchEngine === null) {
        return null;
      }
      if (searchEngine.query != null) {
        return true;
      }
      regex = new RegExp("[\\?&]" + searchEngine.query + "=([^&#]*)");
      test = regex.exec(this._getReferrer());
      if ((test != null) && (test[1] != null)) {
        return decodeURIComponent(test[1].replace(/\+/g, '%20'));
      } else {
        return null;
      }
    };

    Soul.prototype._getSearchEngine = function(list) {
      var regex, searchEngine, _i, _len, _ref, _ref1;
      if (list == null) {
        list = [];
      }
      if (this.request.searchEngine === !null) {
        return this.request.searchEngine;
      }
      _ref = this._matches.searchEngines;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        searchEngine = _ref[_i];
        if ((list === null || list !== null && list.length === 0) || (list !== null && (_ref1 = searchEngine.site, __indexOf.call(list, _ref1) >= 0))) {
          regex = new RegExp(searchEngine.regex);
          this._log(regex, this._getReferrer());
          if (regex.exec(this._getReferrer())) {
            this.request.searchEngine = searchEngine;
            return searchEngine;
          }
        }
      }
      return false;
    };

    Soul.prototype._getSocialNetwork = function(list) {
      var regex, socialNetwork, _i, _len, _ref, _ref1;
      if (list == null) {
        list = [];
      }
      if (this.request.socialNetwork === !null) {
        return this.request.socialNetwork;
      }
      _ref = this._matches.socialNetworks;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        socialNetwork = _ref[_i];
        if ((list === null || list !== null && list.length === 0) || (list !== null && (_ref1 = socialNetwork.site, __indexOf.call(list, _ref1) >= 0))) {
          regex = new RegExp(socialNetwork.regex);
          if (regex.exec(this._getReferrer())) {
            this.request.socialNetwork = socialNetwork;
            return socialNetwork;
          }
        }
      }
      return false;
    };

    Soul.prototype._addRule = function(rule) {
      this._log('addRule', rule);
      return this.rules[rule.name] = this._replaceTemplateVariables(rule);
    };

    Soul.prototype._getRule = function(rule) {
      if ((rule != null) && (this.rules[rule] != null)) {
        return this.rules[rule];
      } else {
        return this.rules;
      }
    };

    Soul.prototype._removeRule = function(ruleName) {
      return delete (this.rules[ruleName] ? delete this.rules[ruleName] : void 0);
    };

    Soul.prototype._replaceTemplateVariables = function(rule) {
      if (rule.template) {
        rule.template = rule.template.replace(/\{\{(\w+)\}\}/gi, function(match, placeholder) {
          var _ref;
          return (_ref = rule[placeholder]) != null ? _ref : '';
        });
      }
      return rule;
    };

    Soul.prototype._trackSoulEvent = function(event, name) {
      if (typeof _gaq !== "undefined" && _gaq !== null) {
        return _gaq.push(['_trackEvent', 'Soul', event, name]);
      }
    };

    Soul.prototype._getTokenURL = function(token) {
      return this.config.tokenPath + token + '.js';
    };

    Soul.prototype._loadScript = function(src, callback) {
      var doc, ele, error, head, process, win;
      win = window;
      doc = win.document;
      callback = callback || function() {};
      error = function(event) {
        event = event || win.event;
        ele.onload = ele.onreadystatechange = ele.onerror = null;
        return callback();
      };
      process = function(event) {
        event = event || win.event;
        if (event.type === 'load' || (/loaded|complete/.test(ele.readyState) && (!doc.documentMode || doc.documentMode < 9))) {
          ele.onload = ele.onreadystatechange = ele.onerror = null;
          return callback();
        }
      };
      ele = doc.createElement('script');
      ele.type = 'text/javascript';
      ele.src = src;
      ele.onload = ele.onreadystatechange = process;
      ele.onerror = error;
      ele.async = false;
      ele.defer = false;
      head = doc.head || doc.getElementsByTagName('head')[0];
      return head.insertBefore(ele, head.lastChild);
    };

    Soul.prototype._initCookie = function() {
      var _c;
      _c = this._getMasterCookie();
      if (_c == null) {
        _c = {
          ref: this._getReferrer(),
          td: new Date().getTime(),
          lp: window.location
        };
        return this._setCookie('mc', this._jsonToText(_c));
      }
    };

    Soul.prototype._getMasterCookie = function() {
      var _c;
      if (this.master != null) {
        return this.master;
      }
      _c = this._textToJson(this._getCookie('mc'));
      this._log(_c);
      if (_c != null) {
        this.master = _c;
        return _c;
      }
      return null;
    };

    Soul.prototype._getPageviews = function() {
      var pageviews;
      if (this.pageviews !== false) {
        return this.pageviews;
      }
      pageviews = this._getCookie('pv');
      pageviews = !pageviews ? 1 : pageviews;
      this.pageviews = parseInt(pageviews, 10);
      return this.pageviews;
    };

    Soul.prototype._trackPageview = function() {
      var pageviews, _cookie;
      _cookie = this._getCookie('pv');
      pageviews = !_cookie ? 0 : this._getPageviews();
      this.pageviews = pageviews + 1;
      return this._setCookie('pv', this.pageviews);
    };

    Soul.prototype._getCookie = function(check_name) {
      var all_cookies, cookie_found, cookie_name, cookie_value, tCookie, temp_cookie, _i, _len;
      check_name = this.cookiePrefix + check_name;
      all_cookies = document.cookie.split(';');
      temp_cookie = '';
      cookie_name = '';
      cookie_value = '';
      cookie_found = false;
      for (_i = 0, _len = all_cookies.length; _i < _len; _i++) {
        tCookie = all_cookies[_i];
        temp_cookie = tCookie.split('=');
        cookie_name = temp_cookie[0].replace(/^\s+|\s+$/g, '');
        if (cookie_name === check_name) {
          cookie_found = true;
          if (temp_cookie.length > 1) {
            cookie_value = decodeURIComponent(temp_cookie[1].replace(/^\s+|\s+$/g, ''));
          }
          if (cookie_value === null) {
            return '';
          } else {
            return cookie_value;
          }
          break;
        }
        temp_cookie = null;
        cookie_name = '';
      }
      if (!cookie_found) {
        return null;
      }
    };

    Soul.prototype._setCookie = function(name, value) {
      return this._writeCookie(name, value, 30);
    };

    Soul.prototype._writeCookie = function(name, value, days, hours) {
      var date, expires;
      name = this.cookiePrefix + name;
      expires = '';
      if (days) {
        date = new Date;
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = '; expires=' + date.toGMTString();
      } else if (hours) {
        date = new Date;
        date.setTime(date.getTime() + (hours * 60 * 60 * 1000));
        expires = '; expires=' + date.toGMTString();
      }
      return document.cookie = name + '=' + encodeURIComponent(value) + '; path=/' + expires;
    };

    Soul.prototype._installDependencies = function() {
      return null;
    };

    Soul.prototype._textToJson = function(sJSON) {
      var error, _json;
      if (sJSON != null) {
        _json = null;
        try {
          _json = eval("(" + sJSON + ")");
        } catch (_error) {
          error = _error;
          return null;
        }
        return _json;
      }
      return null;
    };

    Soul.prototype._jsonToText = function(vContent) {
    if (vContent instanceof Object) {
        var sOutput = "";
        if (vContent.constructor === Array) {
          for (var nId = 0; nId < vContent.length; sOutput += this._jsonToText(vContent[nId]) + ",", nId++);
          return "[" + sOutput.substr(0, sOutput.length - 1) + "]";
        }
        if (vContent.toString !== Object.prototype.toString) { return "\"" + vContent.toString().replace(/"/g, "\\$&") + "\""; }
        for (var sProp in vContent) { sOutput += "\"" + sProp.replace(/"/g, "\\$&") + "\":" + this._jsonToText(vContent[sProp]) + ","; }
        return "{" + sOutput.substr(0, sOutput.length - 1) + "}";
      }
      return typeof vContent === "string" ? "\"" + vContent.replace(/"/g, "\\$&") + "\"" : "\"" + String(vContent) + "\"";
    };

    return Soul;

  })();

  window.Soul = Soul;

  if (navigator.appName === 'Microsoft Internet Explorer') {
    if (document.body && (document.body.readyState === 'loaded' || document.body.readyState === 'complete')) {
      window.SoulInit();
    } else {
      if (window.addEventListener) {
        window.addEventListener('load', window.SoulInit, false);
      } else if (window.attachEvent) {
        window.attachEvent('onload', window.SoulInit);
      }
    }
  } else {
    window.SoulInit();
  }

}).call(this);
