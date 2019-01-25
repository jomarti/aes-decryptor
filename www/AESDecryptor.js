var exec = require('cordova/exec');

/**
   * decrypt
   *
   * @param {String} path File URI
   * @param {String} destPath File URI
   * @param {String} passPhrase Passphrase for decryption
   * @param {Function} success Success callback
   * @param {Function} error Failure callback
   * @returns {void}
   */
module.exports.decrypt = function (path, destPath, passPhrase, success, error) {
    encryptSuccess = onSuccess.bind(null, success);
    encryptError = onError.bind(null, error);
    exec(encryptSuccess, encryptError, 'AESDecryptor', 'decrypt', [path, destPath, passPhrase]);
};

/**
   * encrypt
   *
   * @param {String} path File URI
   * @param {String} destPath File URI
   * @param {String} passPhrase Passphrase for encryption
   * @param {Function} success Success callback
   * @param {Function} error Failure callback
   * @returns {void}
   */
module.exports.encrypt = function (path, destPath, passPhrase, success, error) {
    decryptSuccess = onSuccess.bind(null, success);
    decryptError = onError.bind(null, error);
    exec(decryptSuccess, decryptError, 'AESDecryptor', 'encrypt', [path, destPath, passPhrase]);
};

/**
 * onSuccess
 *
 * @param {Function} success Success callback
 * @param {String} path Encrypted file URI
 * @returns {String} Encrypted file URI
 */
function onSuccess(success, path) {
    if (typeof success === 'function') {
      window.requestFileSystem(window.PERSISTENT, 0, function(fs) {
        fs.root.getFile(path.split('/').pop(), {create: false}, function(file) {
          file.file(function(fileObj) {
            success(fileObj);
          }, onError);
        }, onError);
      }, onError);
    }
  }
  
  /**
   * onError
   *
   * @param {String} error Error callback
   * @param {Function} code Error code
   * @returns {String} Decrypted file URI
   */
  function onError(error, code) {
    if (typeof error === 'function') error(code);
    return code;
  }
  
