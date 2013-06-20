(function() {

  "use strict";

var bcryptUtils = require("./node_modules/login-utils/lib/util/bcryptUtils"),
  UserSchema = require("./UserSchema"),
  SocialMediaUserSchema = require("./SocialMediaUserSchema"),
  PasswordResetTokenSchema = require("./PasswordResetTokenSchema"),
  mongoose = require("mongoose"),
  moment = require("moment"),
  crypto = require('crypto');

var connectString = "";

if(!process.env.TEST_MODE) {
  if(typeof(process.argv[2]) !== "undefined")
    connectString = process.argv[2];
  else if(typeof(process.env.MONGOLAB_URI) !== "undefined")
    connectString = process.env.MONGOLAB_URI;
}

if(connectString === "")
  connectString = "mongodb://localhost:27017/login-utils-test";

module.exports.mongoose = mongoose.connect(connectString, function(err, res) {
  if(err)
    console.log("Failed to connect");
  else
    console.log("Connected!");
});

var User = mongoose.model("User", UserSchema);
var SocialMediaUser = mongoose.model("SocialMediaUser", SocialMediaUserSchema);
var PasswordResetToken = mongoose.model("PasswordResetToken", PasswordResetTokenSchema);

var TOKEN_LENGTH = 48;

//Default token validity is 1 hour
var passwordResetTokenValidityInMillis = 1000 * 60 * 60;

module.exports.setBcryptNumberOfRounds = function(saltFactor){
  bcryptUtils.setBcryptNumberOfRounds(saltFactor);
};

module.exports.getBcryptNumberOfRounds = function(){
  return bcryptUtils.getBcryptNumberOfRounds();
};

module.exports.setPasswordResetTokenValidityInMillis = function(expiryInMillis){
  var ret = expiryInMillis;
  if(typeof expiryInMillis === "number" && !isNaN(expiryInMillis)){
    passwordResetTokenValidityInMillis = expiryInMillis;
  }else{
    ret = new Error("The argument supplied is not a number");
  }

  return ret;
};

module.exports.createPasswordResetToken = function(email, callback){
  findUserByEmail(email, function(err, user){
    if(err){
      process.nextTick(function(){
        callback(err);
      });
    }else if(!user){
      process.nextTick(function(){
        callback(null, null);
      });
    }else{
      var expiryDate = moment().add("ms", passwordResetTokenValidityInMillis).toDate();
      crypto.randomBytes(TOKEN_LENGTH, function(err, buf){
        if(err){
          process.nextTick(function(){
            callback(err);
          });
        }else{
          var tokenString = buf.toString("hex");
          var token = new PasswordResetToken({
            user: user._id,
            token: tokenString,
            expiry: expiryDate
          });
          token.save(function(err){
            process.nextTick(function(){
              callback(err, err ? null : token);
            });
          });
        }
      });
    }
  });
};

module.exports.findPasswordResetTokenByTokenString = function(tokenString, callback){
  PasswordResetToken.findOne({token: tokenString}, callback);
};

module.exports.findPasswordResetTokensForUser = function(email, callback){
  findUserByEmail(email, function(err, user){
    if(err){
      process.nextTick(function(){
        callback(err);
      });
    }else if(!user){
      process.nextTick(function(){
        callback(null);
      });
    }else{
      PasswordResetToken.find({user: user._id}, callback);
    }
  });
};

/**
 * This method assumes the email and password have already been validated AND sanitized
 * @param email the user's email
 * @param password the user's password
 * @param callback
 */
module.exports.loginCheck = function (email, password, callback) {
  User.findOne({email: email}, function (err, user) {
    if (err) {
      process.nextTick(function () {
        callback(err);
      });
    } else if (!user) {
      process.nextTick(function () {
        callback(null, {user: null, message: "User with email '" + email + "' does not exist in store"});
      });
    } else {
      bcryptUtils.checkHash(password, user.salt, user.password, function (err, match) {
        if (err) {
          process.nextTick(function () {
            callback(err);
          });
        } else {
          if (!match) {
            process.nextTick(function () {
              callback(null, {user: null, message: "Incorrect user/password combination. Please try again."});
            });
          } else {
            process.nextTick(function () {
              callback(null, {user: user});
            });
          }
        }
      });
    }
  });
};

function findUserByUserName(userName, callback){
  User.findOne({userName: userName}, callback);
}

function findUserByEmail(userEmail, callback) {
  User.findOne({email: userEmail}, callback);
}

function findUsersByFirstAndLastName(firstName, lastName, callback){
  User.find({firstName: firstName, lastName: lastName}, callback);
}

module.exports.findUserByUserName = findUserByUserName;
module.exports.findUserByEmail = findUserByEmail;
module.exports.findUsersByFirstAndLastName = findUsersByFirstAndLastName;

function findSocialMediaUser (providerName, providerUserId, callback) {
  SocialMediaUser.findOne({providerName: providerName, providerUserId: providerUserId})
    .populate("user")
    .exec(function (err, socialMediaUser) {
      if (err) {
        process.nextTick(function () {
          callback(err);
        });
      } else {
        process.nextTick(function () {
          callback(null, socialMediaUser);
        });
      }
    });
}

module.exports.findSocialMediaUser = findSocialMediaUser;

module.exports.createSocialMediaUser = function(socialMediaUserData, callback){

  var cb3 = function(dontCare,user){
    var socialMediaUser = new SocialMediaUser({
      providerName: socialMediaUserData.providerName,
      providerUserId: socialMediaUserData.providerUserId,
      displayName: socialMediaUserData.displayName,
      user: user._id
    });

    socialMediaUser.save(function(err){
      if(err){
        process.nextTick(function(){
           callback(err);
        });
      }else{
        user.socialMediaPersonae.push(socialMediaUser._id);
        user.save(function(err){
          if(err){
            SocialMediaUser.remove({_id: socialMediaUser._id}, function(dontCare){});
            process.nextTick(function(){
              callback(err);
            });
          }else{
            process.nextTick(function(){
              findSocialMediaUser(socialMediaUser.providerName, socialMediaUser.providerUserId, callback);
            });
          }
        });
      }
    });
  };

  var cb2 = function(){
      var userObj = {
        firstName: socialMediaUserData.firstName,
          lastName: socialMediaUserData.lastName,
          userName: socialMediaUserData.userName,
          email: socialMediaUserData.email,
          password: "Random-Date-pwd_" + Math.floor(Math.random()*1000)
        };
        createNewUser(userObj, cb3);
    };

    var cb1 = function(err, user){
      if(err){
        process.nextTick(function(){
          callback(err);
        });
      }else if(!user){
        process.nextTick(function(){
          cb2();
        });
      }else{
        process.nextTick(function(){
          cb3(null, user);
        });
      }
    };

    findUserByEmail(socialMediaUserData.email, cb1);

  };

  /**
   * This function assumes all input has been validated beforehand
   * @param userData an object containing all the values to create the user
   * @param callback
   */
  function createNewUser(userData, callback) {
    var password = userData.password;
    bcryptUtils.generateSaltAndHash(password, function (err, saltAndHash) {
      if (err) {
        process.nextTick(function () {
          callback(err);
        });

      } else {
        var salt = saltAndHash.salt;
        var hash = saltAndHash.hash;

        var user = new User({
          firstName: userData.firstName,
          lastName: userData.lastName,
          userName: userData.userName,
          email: userData.email,
          salt: salt,
          password: hash,
          creationDate: new Date(),
          socialMediaPersonae: []
        });
        user.save(function (err) {
          if (err) {
            process.nextTick(function () {
              callback(err);
            });
          } else {
            process.nextTick(function () {
              callback(null, user);
            });
          }
        });
      }
    });
  }

  module.exports.createNewUser = createNewUser;
}).call(this);