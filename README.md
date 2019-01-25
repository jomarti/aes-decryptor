AESDecryptor
====

AES file encryption/decryption for Cordova.

## Install

```bash
$ cordova plugin add https://github.com/jomarti/aes-decryptor.git
```

## Usage

```javascript

 let key = 'VVFQLG305';


function success(encryptedFile) {
  console.log('Encrypted file: ' + encryptedFile);

  AESDecryptor.decrypt(encryptedFile, key, function(decryptedFile) {
    console.log('Decrypted file: ' + decryptedFile);
  }, error);
}

function error() {
  console.log('Error with cryptographic operation');
}

AESDecryptor.encrypt('file:/storage/sdcard/DCIM/Camera/1404177327783.jpg', key, success, error);
```

## API

The plugin exposes the following methods:

```javascript
AESDecryptor.encrypt(file, key, success, error);
AESDecryptor.decrypt(file, key, success, error);
```

#### Parameters:
* __file:__ A string representing a local URI
* __key:__ A key for the crypto operations
* __success:__ Optional success callback
* __error:__ Optional error callback

## License

ISC © [crash_soft](http://crash_soft.io)