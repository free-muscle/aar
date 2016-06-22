#!/usr/bin/env node

module.exports = function(context) {
  console.log('contxt :', context);
  var fs = require('fs');
  var path = require('path');
  var paths = {
    dev:{
      x86: 'http://webstore.com/uploads/dev/x86/xwalk_core_library-17.46.448.10.aar',
      arm: 'http://webstore.com/uploads/dev/arm/xwalk_core_library-17.46.448.10.aar'
    },
    release:{
      x86: 'http://webstore.com/uploads/release/x86/xwalk_core_library-17.46.448.10.aar',
      arm: 'http://webstore.com/uploads/release/arm/xwalk_core_library-17.46.448.10.aar'
    }
  };
  var HOME = process.env.HOME;
  var rootPath = path.join(HOME, '.gradle/caches/modules-2/files-2.1');
  var libPath = path.join(rootPath, 'org.xwalk/xwalk_core_library/17.46.448.10/cd626c32360d9b48b60cf685b38fa7f5b31156df');
  var tailPath = 'org.xwalk/xwalk_core_library/17.46.448.10/cd626c32360d9b48b60cf685b38fa7f5b31156df/xwalk_core_library-17.46.448.10.aar';
  var xwalkPath = path.join(rootPath, tailPath);
  // var platform = context.cmdLine.indexOf('--x86')>-1?'x86':'arm';
  // var channel = context.opts.options.indexOf('--dev')>-1?'dev':'release';
  // var cloudPath = paths[channel][platform];
  var deferral = context.requireCordovaModule('q').defer(),
    UpdateConfig = require('./../update_config.js'),
    updateConfig = new UpdateConfig(context);

  console.log('befor build >>>>>> :');
  console.log(rootPath, fs.existsSync(rootPath));
  console.log(libPath, fs.existsSync(libPath));
  deferral.resolve();

  return deferral.promise;

};
