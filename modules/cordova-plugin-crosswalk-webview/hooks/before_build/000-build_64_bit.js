#!/usr/bin/env node

module.exports = function(context) {
  var qiniu = require("qiniu");
  var fs = require('fs');
  var path = require('path');
  var request = require('request');
  var paths = {
    dev:{
      x86: 'http://7vilzw.com1.z0.glb.clouddn.com/xwalk_core_library-15.44.384.13.aar',
      arm: 'http://7vilzw.com1.z0.glb.clouddn.com/xwalk_core_library-15.44.384.13.aar'
    },
    release:{
      x86: 'http://7vilzw.com1.z0.glb.clouddn.com/xwalk_core_library-15.44.384.13.aar',
      arm: 'http://7vilzw.com1.z0.glb.clouddn.com/xwalk_core_library-15.44.384.13.aar'
    }
  };
  var HOME = process.env.HOME;
  var tailPath = '.gradle/caches/modules-2/files-2.1/org.xwalk/xwalk_core_library/15.44.384.13/a4f7b2788de45653d2e25640b4d7a07bb18d8e8/xwalk_core_library-15.44.384.13.aar';
  var xwalkPath = path.join(HOME, tailPath);
  var platform = context.cmdLine.indexOf('--x86')>-1?'x86':'arm';
  var channel = context.cmdLine.indexOf('--debug')>-1?'dev':'release';
  var cloudPath = paths[channel][platform];
  var deferral = context.requireCordovaModule('q').defer(),
    UpdateConfig = require('./../update_config.js'),
    updateConfig = new UpdateConfig(context);

  function createXwalkDir(){
    if(fs.existsSync(xwalkPath)){
      return;
    }
    var tmpPath = HOME;
    var names = tailPath.split('/');
    names.forEach(function(name, i){
      tmpPath = path.join(tmpPath, name);
      if(!fs.existsSync(tmpPath)){
        if(i==names.length-1){
          fs.openSync(tmpPath,'a+');
        }else{
          fs.mkdirSync(tmpPath);
        }
      }
    });
  }

  function generateQiniuUrl(url){
    qiniu.conf.ACCESS_KEY = 'fJMBWKEqMtPHowI4bRF02lF7RsJFBh012d9D4bxE';
    qiniu.conf.SECRET_KEY = 'XX9JpXzFl6kduQmZJ8mZ4TaDlAYCsmoLoM4z_F0q';
    var policy = new qiniu.rs.GetPolicy();
    var downloadUrl = policy.makeRequest(url);
    console.log('Gegerate qiniu url :', downloadUrl);
    return downloadUrl;
  }

  console.log('download xwalk lib core :');
  /** Main method */
  var main = function() {
    createXwalkDir();
    cloudPath = generateQiniuUrl(cloudPath);
    var stream = fs.createWriteStream(xwalkPath);

    // download and replace xwalk file
    request
      .get(cloudPath)
      .on('error', function(err) {
        console.log('download '+cloudPath+'failure!', err);
        throw err;
      })
      .on('response', function (res) {
        stream.on('finish', function(){
          console.log(cloudPath, 'downloaded!!!!!');
          // Remove the xwalk variables
          updateConfig.beforeBuild64bit();
          deferral.resolve();
        });
      }).pipe(stream);
  };

  main();
  // setTimeout(function(){
  //   updateConfig.beforeBuild64bit();
  //   deferral.resolve();
  // },100);

  return deferral.promise;

};
