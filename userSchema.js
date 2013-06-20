(function() {

    "use strict";

var mongoose = require("mongoose"),
    ObjectId = mongoose.Schema.ObjectId;

var UserSchema = new mongoose.Schema({
    firstName: {type: String, required: true},
    lastName: {type: String, required: true},
    userName: {type: String, required: true, index: {unique: true}},
    email: {type: String, required: true, index: {unique: true}},
    password:  {type: String, required: true},
    salt: {type: String, required: true},
    creationDate: {type: Date, index: true},
    lastLogin: {type: Date, default: new Date()},
    socialMediaPersonae: [{type: ObjectId, ref: "SocialMediaUser"}]
});

module.exports = UserSchema;
}).call(this);
