// Generated by CoffeeScript 1.6.1
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function() {
  var RSLCounterTimer;
  RSLCounterTimer = (function() {
    var Counter, CounterTimer, Timer,
      _this = this;

    function RSLCounterTimer() {}

    RSLCounterTimer.CounterTimer = CounterTimer = (function() {

      function CounterTimer(number, preset) {
        this.number = number;
        this.preset = preset;
        this.acc = 0;
        this.dn = this.done();
        this.en = false;
      }

      CounterTimer.prototype.tickUp = function() {
        this.acc++;
        return this.dn = this.done();
      };

      CounterTimer.prototype.tickDown = function() {
        this.acc--;
        return this.dn = this.done();
      };

      CounterTimer.prototype.done = function() {
        return this.acc >= this.preset;
      };

      CounterTimer.prototype.reset = function() {
        this.acc = 0;
        return this.dn = this.done();
      };

      return CounterTimer;

    })();

    RSLCounterTimer.Counter = Counter = (function(_super) {

      __extends(Counter, _super);

      function Counter() {
        return Counter.__super__.constructor.apply(this, arguments);
      }

      Counter.prototype.CU = function() {
        this.tickUp();
        return this.cu = true;
      };

      Counter.prototype.CD = function() {
        this.tickDown();
        return this.cd = true;
      };

      return Counter;

    })(RSLCounterTimer.CounterTimer);

    RSLCounterTimer.Timer = Timer = (function(_super) {

      __extends(Timer, _super);

      function Timer() {
        return Timer.__super__.constructor.apply(this, arguments);
      }

      Timer.prototype.tick = function() {
        if (!this.done()) {
          this.tickUp();
          return this.tt = true;
        } else {
          return this.tt = false;
        }
      };

      return Timer;

    })(RSLCounterTimer.CounterTimer);

    RSLCounterTimer.counterTimerInstruction = function(file, onAction, offAction) {
      var _this = this;
      return function(matchValues, dataTable) {
        var activeBranch, matchText, number, numberString, preset, presetString;
        matchText = matchValues[0], numberString = matchValues[1], presetString = matchValues[2];
        number = parseInt(numberString, 10);
        preset = parseInt(presetString, 10);
        dataTable[file] = dataTable[file] || {};
        if (dataTable[file][number] == null) {
          if (file === "T4") {
            dataTable["T4"][number] = new _this.Timer(number, preset);
          } else {
            dataTable["C5"][number] = new _this.Counter(number, preset);
          }
        }
        if (dataTable.activeBranch) {
          activeBranch = dataTable.branches[dataTable.activeBranch - 1];
        }
        if (dataTable.rungOpen && ((!dataTable.activeBranch) || (activeBranch.onTopLine && activeBranch.topLine) || (!activeBranch.onTopLine && activeBranch.bottomLine))) {
          onAction(dataTable[file][number]);
        } else {
          offAction(dataTable[file][number]);
        }
        return dataTable;
      };
    };

    RSLCounterTimer.timerInstruction = function(onTimerAction, offTimerAction) {
      return this.counterTimerInstruction("T4", onTimerAction, offTimerAction);
    };

    RSLCounterTimer.TON = RSLCounterTimer.timerInstruction(function(timer) {
      timer.tick();
      return timer.en = true;
    }, function(timer) {
      timer.reset();
      return timer.en = false;
    });

    RSLCounterTimer.TOF = RSLCounterTimer.timerInstruction(function(timer) {
      timer.reset();
      timer.dn = true;
      timer.en = true;
      return timer.tt = false;
    }, function(timer) {
      timer.tick();
      timer.dn = timer.dn && timer.acc < timer.preset;
      timer.en = false;
      return timer.tt = !timer.dn;
    });

    RSLCounterTimer.RTO = RSLCounterTimer.timerInstruction(function(timer) {
      timer.tick();
      return timer.en = true;
    }, function(timer) {
      timer.en = false;
      return timer.tt = false;
    });

    RSLCounterTimer.RES = function(matchValues, dataTable) {
      var activeBranch, file, matchText, rank, rankString;
      if (dataTable.activeBranch) {
        activeBranch = dataTable.branches[dataTable.activeBranch - 1];
      }
      if (dataTable.rungOpen && ((!dataTable.activeBranch) || (activeBranch.onTopLine && activeBranch.topLine) || (!activeBranch.onTopLine && activeBranch.bottomLine))) {
        matchText = matchValues[0], file = matchValues[1], rankString = matchValues[2];
        rank = parseInt(rankString, 10);
        dataTable[file][rank].reset();
      }
      return dataTable;
    };

    RSLCounterTimer.counterInstruction = function(onCounterAction, offCounterAction) {
      return this.counterTimerInstruction("C5", onCounterAction, offCounterAction);
    };

    RSLCounterTimer.CTU = RSLCounterTimer.counterInstruction(function(counter) {
      return counter.CU();
    }, function(counter) {
      return counter.cu = false;
    });

    RSLCounterTimer.CTD = RSLCounterTimer.counterInstruction(function(counter) {
      return counter.CD();
    }, function(counter) {
      return counter.cd = false;
    });

    return RSLCounterTimer;

  }).call(this);
  return module.exports = RSLCounterTimer;
}).call(this);