// Generated by CoffeeScript 1.6.1

(function() {
  "use strict";  process.env.test = true;
  return describe("RSLStartEnd", function() {
    var RSLStartEnd;
    RSLStartEnd = require("../../models/RSLParser/RSLStartEnd.coffee");
    it("should exist", function() {
      return expect(RSLStartEnd).toBeDefined;
    });
    describe("constructor", function() {
      return it("does nothing", function() {
        return expect(new RSLStartEnd()).toBeDefined;
      });
    });
    return describe("SOR", function() {
      return it("Returns a dataTable with activeRung = '0'", function() {
        return expect(RSLStartEnd.SOR(["SOR,0", "0"], {
          data: "table"
        }).activeRung).toEqual('0');
      });
    });
  });
}).call(this);
